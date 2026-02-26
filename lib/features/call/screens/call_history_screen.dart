import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/call/controllers/call_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    Get.find<CallController>().getCallHistory();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(
            title: 'call_history'.tr,
            showBackButton: true,
          ),
          body: GetBuilder<CallController>(builder: (callController) {
            return callController.callHistory.isEmpty
                ? Center(
                    child: Text(
                      'no_call_history'.tr,
                      style: textRegular.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: callController.callHistory.length,
                    itemBuilder: (context, index) {
                      final call = callController.callHistory[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ImageWidget(
                            height: 50,
                            width: 50,
                            image: call.contactImage,
                          ),
                        ),
                        title: Text(
                          call.contactName,
                          style: textRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              '${call.callType == 'audio' ? 'audio_call'.tr : 'video_call'.tr} • ${call.direction == 'incoming' ? 'incoming'.tr : 'outgoing'.tr}',
                              style: textSmall.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateConverter.formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                  call.timestamp * 1000,
                                ),
                              ),
                              style: textSmall.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Call icon indicating missed/answered
                            Icon(
                              call.callStatus == 'missed'
                                  ? Icons.call_missed
                                  : Icons.call_received,
                              color: call.callStatus == 'missed'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${call.duration ~/ 60}m ${call.duration % 60}s',
                              style: textSmall.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          }),
        ),
      ),
    );
  }
}
