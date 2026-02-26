import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/subscription/controllers/subscription_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  const SubscriptionDetailsScreen({super.key});

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  @override
  void initState() {
    Get.find<SubscriptionController>().getUserSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(
            title: 'my_subscription'.tr,
            showBackButton: true,
          ),
          body: GetBuilder<SubscriptionController>(
            builder: (subscriptionController) {
              return subscriptionController.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : subscriptionController.userSubscription == null
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge * 2,
                                ),
                                Icon(
                                  Icons.card_giftcard,
                                  size: 80,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                                Text(
                                  'no_active_subscription'.tr,
                                  textAlign: TextAlign.center,
                                  style: textBold.copyWith(
                                    fontSize:
                                        Dimensions.fontSizeExtraLarge,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeSmall,
                                ),
                                Text(
                                  'subscribe_to_unlock_features'.tr,
                                  textAlign: TextAlign.center,
                                  style: textSmall.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge * 2,
                                ),
                                ButtonWidget(
                                  buttonText: 'view_plans'.tr,
                                  onPressed: () {
                                    Get.toNamed('/subscription-plans');
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Current Plan Card
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Theme.of(context)
                                            .primaryColor
                                            .withValues(alpha: 0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeDefault,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'current_plan'.tr,
                                        style: textSmall.copyWith(
                                          color: Colors.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: Dimensions.paddingSizeSmall,
                                      ),
                                      Text(
                                        subscriptionController
                                            .userSubscription!.planName,
                                        style: textBold.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: Dimensions.paddingSizeDefault,
                                      ),
                                      // Status Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: subscriptionController
                                                      .userSubscription!
                                                      .isActive
                                                  ? Colors.green
                                                  : Colors.amber,
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall,
                                          ),
                                        ),
                                        child: Text(
                                          subscriptionController
                                              .getSubscriptionStatus(),
                                          style: textSmall.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge,
                                ),

                                // Dates Info
                                _buildInfoRow(
                                  context,
                                  'start_date'.tr,
                                  subscriptionController
                                      .userSubscription!.startDate
                                      .toString()
                                      .split(' ')[0],
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                                _buildInfoRow(
                                  context,
                                  'expiry_date'.tr,
                                  subscriptionController
                                      .userSubscription!.expiryDate
                                      .toString()
                                      .split(' ')[0],
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                                _buildInfoRow(
                                  context,
                                  'days_remaining'.tr,
                                  '${subscriptionController.getDaysRemainingInSubscription()} days',
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge * 2,
                                ),

                                // Action Buttons
                                if (subscriptionController
                                    .userSubscription!.isActive)
                                  Column(
                                    children: [
                                      ButtonWidget(
                                        buttonText: 'renew_subscription'.tr,
                                        onPressed: () {
                                          subscriptionController
                                              .renewSubscription();
                                        },
                                      ),
                                      const SizedBox(
                                        height: Dimensions.paddingSizeSmall,
                                      ),
                                      ButtonWidget(
                                        buttonText: 'cancel_subscription'.tr,
                                        backgroundColor: Colors.red
                                            .withValues(alpha: 0.1),
                                        textColor: Colors.red,
                                        onPressed: () {
                                          _showCancelConfirmation(context,
                                              subscriptionController);
                                        },
                                      ),
                                    ],
                                  )
                                else
                                  ButtonWidget(
                                    buttonText: 'upgrade_plan'.tr,
                                    onPressed: () {
                                      Get.toNamed('/subscription-plans');
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textSmall.copyWith(
            color: Theme.of(context).hintColor,
          ),
        ),
        Text(
          value,
          style: textSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmation(BuildContext context,
      SubscriptionController subscriptionController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('cancel_subscription'.tr),
        content: Text('confirm_cancel_subscription'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('no'.tr),
          ),
          TextButton(
            onPressed: () {
              subscriptionController.cancelSubscription();
              Navigator.pop(context);
            },
            child: Text(
              'yes'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
