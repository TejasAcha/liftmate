import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RewardCompleteBottomSheet extends StatefulWidget {
  final String rewardTitle;
  final double rewardPoints;
  final String rewardIcon;
  final VoidCallback onClaimTap;

  const RewardCompleteBottomSheet({
    super.key,
    required this.rewardTitle,
    required this.rewardPoints,
    required this.rewardIcon,
    required this.onClaimTap,
  });

  @override
  State<RewardCompleteBottomSheet> createState() =>
      _RewardCompleteBottomSheetState();
}

class _RewardCompleteBottomSheetState extends State<RewardCompleteBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusDefault),
            topRight: Radius.circular(Dimensions.radiusDefault),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Trophy icon with animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: Colors.amber,
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Congratulations text
              Text(
                'congratulations'.tr,
                style: textBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              // Reward title
              Text(
                widget.rewardTitle,
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor,
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Points earned
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    Text(
                      'points_earned'.tr,
                      style: textSmall.copyWith(
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${widget.rewardPoints.toStringAsFixed(0)}',
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Button
              ButtonWidget(
                buttonText: 'claim_reward'.tr,
                onPressed: () {
                  Get.back();
                  widget.onClaimTap();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
