import 'package:get/get.dart';

abstract class CallServiceInterface {
  Future<Response> initiateCall(String recipientId, String callType);
  Future<Response> acceptCall(String callId);
  Future<Response> rejectCall(String callId);
  Future<Response> endCall(String callId, int duration);
  Future<Response> getCallHistory(int offset);
  Future<Response> updateCallStatus(String callId, String status);
}
