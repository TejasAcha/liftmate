import 'dart:async';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/call/domain/models/call_model.dart';
import 'package:ride_sharing_user_app/features/call/domain/services/call_service_interface.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

enum CallStatus { connecting, connected, disconnected, failed }
enum CallType { audio, video }

class CallController extends GetxController implements GetxService {
  final CallServiceInterface callServiceInterface;
  CallController({required this.callServiceInterface});

  // Call state variables
  CallStatus callStatus = CallStatus.disconnected;
  CallType callType = CallType.audio;
  CallModel? currentCall;
  List<CallHistoryModel> callHistory = [];
  bool isLoading = false;
  bool isMuted = false;
  bool isSpeakerOn = true;
  bool isVideoEnabled = false;

  // Agora engine
  late RtcEngine agoraEngine;
  int? remoteUid;
  bool localUserJoined = false;
  int callDuration = 0;
  Timer? callTimer;

  // Call configuration
  static const String agoraAppId = 'YOUR_AGORA_APP_ID'; // Replace with actual Agora App ID
  String generatedToken = '';

  @override
  void onInit() {
    super.onInit();
    initAgoraEngine();
  }

  /// Initialize Agora Engine
  Future<void> initAgoraEngine() async {
    try {
      agoraEngine = createAgoraRtcEngine();
      await agoraEngine.initialize(
        RtcEngineContext(
          appId: agoraAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      agoraEngine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            localUserJoined = true;
            startCallTimer();
            update();
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            this.remoteUid = remoteUid;
            callStatus = CallStatus.connected;
            update();
          },
          onUserOffline: (connection, remoteUid, reason) {
            this.remoteUid = null;
            endCallProcess();
            update();
          },
          onError: (err, msg) {
            callStatus = CallStatus.failed;
            showCustomSnackBar('call_error'.tr);
            update();
          },
        ),
      );

      if (callType == CallType.video) {
        await agoraEngine.enableVideo();
      } else {
        await agoraEngine.disableVideo();
      }

      await agoraEngine.enableAudio();
    } catch (e) {
      callStatus = CallStatus.failed;
      showCustomSnackBar('failed_to_initialize_call'.tr);
    }
  }

  /// Safe method to initiate call from trip - validates preconditions
  /// Returns true if call initiation started successfully, false otherwise
  Future<bool> startCallFromTrip({
    required String? recipientId,
    required String? recipientName,
    required String? recipientImage,
    CallType type = CallType.audio,
  }) async {
    // Validate all required parameters are not null or empty
    if (recipientId == null || recipientId.isEmpty) {
      showCustomSnackBar('recipient_id_invalid'.tr);
      return false;
    }

    if (recipientName == null || recipientName.isEmpty) {
      showCustomSnackBar('recipient_name_invalid'.tr);
      return false;
    }

    // Ensure Agora engine is initialized before attempting call
    if (callStatus == CallStatus.disconnected || callStatus == CallStatus.failed) {
      await initAgoraEngine();
    }

    // recipientImage can be empty, use default if needed
    final validImage = recipientImage ?? '';

    try {
      await startCall(
        recipientId: recipientId,
        recipientName: recipientName,
        recipientImage: validImage,
        type: type,
      );
      return true;
    } catch (e) {
      showCustomSnackBar('failed_to_initiate_call'.tr);
      return false;
    }
  }

  /// Wrapper method for UI - initiates call with driver data
  Future<void> startCall({
    required String recipientId,
    required String recipientName,
    required String recipientImage,
    CallType type = CallType.audio,
  }) async {
    currentCall = CallModel(
      callId: recipientId,
      callerId: recipientId,
      callerName: recipientName,
      callerImage: recipientImage,
      callType: type == CallType.video ? 'video' : 'audio',
      callStatus: 'initiated',
      callStartTime: DateTime.now().millisecondsSinceEpoch,
      callEndTime: 0,
      callDirection: 'outgoing',
    );
    await initiateCall(recipientId, type);
  }

  /// Initiate a call to another user
  Future<void> initiateCall(String recipientId, CallType type) async {
    isLoading = true;
    callType = type;
    callStatus = CallStatus.connecting;
    update();

    try {
      Response response = await callServiceInterface.initiateCall(
        recipientId,
        type == CallType.audio ? 'audio' : 'video',
      );

      if (response.statusCode == 200) {
        // Generate a unique channel name
        final String channelName = 'call_${DateTime.now().millisecondsSinceEpoch}';
        generatedToken = generateToken();

        // Join the Agora channel
        await agoraEngine.joinChannel(
          token: generatedToken,
          channelId: channelName,
          uid: 0,
          options: ChannelMediaOptions(
            publishCameraTrack: callType == CallType.video,
            publishMicrophoneTrack: true,
            autoSubscribeAudio: true,
            autoSubscribeVideo: callType == CallType.video,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            channelProfile: ChannelProfileType.channelProfileCommunication,
          ),
        );

        isLoading = false;
        callStatus = CallStatus.connecting;
        update();
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      callStatus = CallStatus.failed;
      showCustomSnackBar('failed_to_initiate_call'.tr);
      update();
    }
  }

  /// Accept an incoming call
  Future<void> acceptCall(String callId, CallType type) async {
    isLoading = true;
    callType = type;
    callStatus = CallStatus.connecting;
    update();

    try {
      Response response = await callServiceInterface.acceptCall(callId);

      if (response.statusCode == 200) {
        final String channelName = 'call_$callId';
        generatedToken = generateToken();

        await agoraEngine.joinChannel(
          token: generatedToken,
          channelId: channelName,
          uid: 0,
          options: ChannelMediaOptions(
            publishCameraTrack: type == CallType.video,
            publishMicrophoneTrack: true,
            autoSubscribeAudio: true,
            autoSubscribeVideo: type == CallType.video,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            channelProfile: ChannelProfileType.channelProfileCommunication,
          ),
        );

        isLoading = false;
        callStatus = CallStatus.connecting;
        update();
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      callStatus = CallStatus.failed;
      showCustomSnackBar('failed_to_accept_call'.tr);
      update();
    }
  }

  /// Reject an incoming call
  Future<void> rejectCall(String callId) async {
    isLoading = true;
    update();

    try {
      Response response = await callServiceInterface.rejectCall(callId);

      if (response.statusCode == 200) {
        callStatus = CallStatus.disconnected;
        currentCall = null;
        isLoading = false;
        update();
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      showCustomSnackBar('failed_to_reject_call'.tr);
      update();
    }
  }

  /// End the current call
  Future<void> endCall() async {
    try {
      if (currentCall != null) {
        Response response = await callServiceInterface.endCall(
          currentCall!.callId,
          callDuration,
        );

        if (response.statusCode == 200) {
          endCallProcess();
        } else {
          ApiChecker.checkApi(response);
        }
      } else {
        endCallProcess();
      }
    } catch (e) {
      endCallProcess();
    }
  }

  /// Process call ending
  void endCallProcess() {
    callTimer?.cancel();
    callDuration = 0;
    callStatus = CallStatus.disconnected;
    remoteUid = null;
    localUserJoined = false;
    currentCall = null;
    isMuted = false;
    isSpeakerOn = true;
    isVideoEnabled = false;
    agoraEngine.leaveChannel();
    update();
  }

  /// Toggle microphone
  Future<void> toggleMicrophone() async {
    isMuted = !isMuted;
    await agoraEngine.muteLocalAudioStream(isMuted);
    update();
  }

  /// Toggle speaker
  Future<void> toggleSpeaker() async {
    isSpeakerOn = !isSpeakerOn;
    await agoraEngine.setEnableSpeakerphone(isSpeakerOn);
    update();
  }

  /// Toggle video
  Future<void> toggleVideo() async {
    if (callType == CallType.video) {
      isVideoEnabled = !isVideoEnabled;
      await agoraEngine.muteLocalVideoStream(!isVideoEnabled);
      update();
    }
  }

  /// Get call history
  Future<void> getCallHistory({int offset = 1}) async {
    isLoading = true;
    update();

    try {
      Response response = await callServiceInterface.getCallHistory(offset);

      if (response.statusCode == 200) {
        if (offset == 1) {
          callHistory.clear();
        }

        if (response.body['data'] != null) {
          response.body['data'].forEach((call) {
            callHistory.add(CallHistoryModel.fromJson(call));
          });
        }

        isLoading = false;
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      showCustomSnackBar('failed_to_load_call_history'.tr);
    }

    update();
  }

  /// Start call timer
  void startCallTimer() {
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration++;
      update();
    });
  }

  /// Format call duration
  String getFormattedDuration() {
    int minutes = callDuration ~/ 60;
    int seconds = callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Generate random token (should be from backend)
  String generateToken() {
    return Random().nextInt(1000000).toString();
  }

  /// Cleanup on dispose
  @override
  void onClose() {
    callTimer?.cancel();
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.onClose();
  }
}