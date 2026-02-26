import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/call/controllers/call_controller.dart';
import 'package:ride_sharing_user_app/features/call/screens/call_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callerId;
  final String callerName;
  final String callerImage;
  final String callType; // 'audio' or 'video'
  final String callId;
  const IncomingCallScreen({
    super.key,
    required this.callerId,
    required this.callerName,
    required this.callerImage,
    required this.callType, 
    required this.callId,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
  canPop: false,
  child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: GetBuilder<CallController>(builder: (callController) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'incoming_call'.tr,
                    style: textBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ImageWidget(
                      height: 150,
                      width: 150,
                      image: widget.callerImage,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    widget.callerName,
                    style: textBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    widget.callType == 'video'
                        ? 'video_call'.tr
                        : 'audio_call'.tr,
                    style: textRegular.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Accept button
                      InkWell(
                        onTap: callController.isLoading
                            ? null
                            : () async {
                                await callController.acceptCall(
                                  widget.callId,
                                  widget.callType == 'video'
                                      ? CallType.video
                                      : CallType.audio,
                                );
                                if (callController.callStatus ==
                                    CallStatus.connecting) {
                                  Get.off(
                                    () => CallScreen(
                                      recipientId: widget.callerId,
                                      recipientName: widget.callerName,
                                      recipientImage: widget.callerImage,
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                      // Reject button
                      InkWell(
                        onTap: callController.isLoading
                            ? null
                            : () async {
                                await callController.rejectCall(widget.callId);
                                Get.back();
                              },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
