import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/call/controllers/call_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CallScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String recipientImage;
  const CallScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
    required this.recipientImage,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.find<CallController>().endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
  canPop: false,
  child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: GetBuilder<CallController>(builder: (callController) {
            return Stack(
              children: [
                // Video view for video calls
                if (callController.callType == CallType.video)
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          child: callController.remoteUid != null
                              ? AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: callController.agoraEngine,
                                    canvas: VideoCanvas(
                                      uid: callController.remoteUid,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: ImageWidget(
                                          height: 120,
                                          width: 120,
                                          image: widget.recipientImage,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: Dimensions.paddingSizeSmall,
                                      ),
                                      Text(
                                        widget.recipientName,
                                        style: textBold.copyWith(
                                          color: Colors.white,
                                          fontSize: Dimensions.fontSizeDefault,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  )
                else
                  // Audio call view
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ImageWidget(
                            height: 150,
                            width: 150,
                            image: widget.recipientImage,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Text(
                          widget.recipientName,
                          style: textBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeExtraLarge,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          callController.getFormattedDuration(),
                          style: textRegular.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Call controls
                Positioned(
                  bottom: Dimensions.paddingSizeDefault,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Microphone button
                            InkWell(
                              onTap: () {
                                callController.toggleMicrophone();
                              },
                              child: Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  color: callController.isMuted
                                      ? Colors.red
                                      : Colors.grey[700],
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Icon(
                                  callController.isMuted
                                      ? Icons.mic_off
                                      : Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            // Speaker button
                            InkWell(
                              onTap: () {
                                callController.toggleSpeaker();
                              },
                              child: Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  color: callController.isSpeakerOn
                                      ? Colors.grey[700]
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Icon(
                                  callController.isSpeakerOn
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            // Video button (only for video calls)
                            if (callController.callType == CallType.video) ...[
                              const SizedBox(
                                width: Dimensions.paddingSizeDefault,
                              ),
                              InkWell(
                                onTap: () {
                                  callController.toggleVideo();
                                },
                                child: Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    color: callController.isVideoEnabled
                                        ? Colors.grey[700]
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Icon(
                                    callController.isVideoEnabled
                                        ? Icons.videocam
                                        : Icons.videocam_off,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        // End call button
                        InkWell(
                          onTap: () {
                            callController.endCall();
                            Get.back();
                          },
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
