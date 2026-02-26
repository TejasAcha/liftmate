import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/widget/otp_car_bike_animated_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';


class OtpWidget extends StatefulWidget {
  final bool isParcel;
  const OtpWidget({super.key, required this.isParcel});

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  bool isAnimated = true;

  @override
  void initState() {
    if(widget.isParcel){
      Future.delayed(const Duration(seconds: 5)).then((_) {
        isAnimated = false;
        setState(() {});
      });
    }else{
      isAnimated = false;
      setState(() {});
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(children: [
          if(isAnimated && widget.isParcel)
            const OtpCarBikeAnimatedWidget(),

          if(!isAnimated)...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text.rich(TextSpan(
                        style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                        ), children: [
                      TextSpan(
                        text: 'please'.tr + ' ',
                        style: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),

                      TextSpan(
                        text: 'share_the_pin'.tr,
                        style: textSemiBold.copyWith(
                          color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),

                      TextSpan(
                        text: ' ' + 'with_the_driver'.tr,
                        style: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Row(children: [
                    _buildOtpBox(context, rideController.tripDetails?.otp, 0),
                    const SizedBox(width: 6),
                    _buildOtpBox(context, rideController.tripDetails?.otp, 1),
                    const SizedBox(width: 6),
                    _buildOtpBox(context, rideController.tripDetails?.otp, 2),
                    const SizedBox(width: 6),
                    _buildOtpBox(context, rideController.tripDetails?.otp, 3),
                  ])
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          ]
        ]),
      );
    });
  }

  Widget _buildOtpBox(BuildContext context, String? otp, int index){
    final double boxSize = 32;
    final double fontSize = 16;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? Theme.of(context).hintColor.withValues(alpha: 0.85) : Theme.of(context).primaryColorDark.withValues(alpha: 0.9);
    final Color textColor = Colors.white;

    String char = '';
    if(otp != null && otp.length > index){
      char = otp[index];
    }

    return Container(
      height: boxSize,
      width: boxSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(
        char,
        style: textBold.copyWith(fontSize: fontSize, color: textColor),
      )),
    );
  }
}
