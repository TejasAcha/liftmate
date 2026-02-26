import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/call/domain/services/call_service_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class CallService implements CallServiceInterface {
  final ApiClient apiClient;

  CallService({required this.apiClient});

  @override
  Future<Response> initiateCall(String recipientId, String callType) async {
    return await apiClient.postData(
      AppConstants.initiateCall,
      {
        'recipient_id': recipientId,
        'call_type': callType,
      },
    );
  }

  @override
  Future<Response> acceptCall(String callId) async {
    return await apiClient.postData(
      AppConstants.acceptCall,
      {'call_id': callId},
    );
  }

  @override
  Future<Response> rejectCall(String callId) async {
    return await apiClient.postData(
      AppConstants.rejectCall,
      {'call_id': callId},
    );
  }

  @override
  Future<Response> endCall(String callId, int duration) async {
    return await apiClient.postData(
      AppConstants.endCall,
      {
        'call_id': callId,
        'duration': duration,
      },
    );
  }

  @override
  Future<Response> getCallHistory(int offset) async {
    return await apiClient.getData(
      '${AppConstants.callHistory}?limit=10&offset=$offset',
    );
  }

  @override
  Future<Response> updateCallStatus(String callId, String status) async {
    return await apiClient.postData(
      AppConstants.updateCallStatus,
      {
        'call_id': callId,
        'status': status,
      },
    );
  }
}
