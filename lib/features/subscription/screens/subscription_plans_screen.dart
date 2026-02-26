import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/subscription/controllers/subscription_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  @override
  void initState() {
    Get.find<SubscriptionController>().getSubscriptionPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(
            title: 'premium_plans'.tr,
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
                  : ListView.builder(
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeDefault,
                      ),
                      itemCount:
                          subscriptionController.subscriptionPlans.length,
                      itemBuilder: (context, index) {
                        final plan = subscriptionController
                            .subscriptionPlans[index];

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: plan.isMostPopular
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                              width: plan.isMostPopular ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault,
                            ),
                            color: plan.isMostPopular
                                ? Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.05)
                                : null,
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeDefault,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              plan.name,
                                              style: textBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              plan.description,
                                              style: textSmall.copyWith(
                                                color: Theme.of(context)
                                                    .hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$${plan.price.toStringAsFixed(2)}',
                                              style: textBold.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraLarge,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            Text(
                                              '/${plan.frequency.tr}',
                                              style: textSmall.copyWith(
                                                color: Theme.of(context)
                                                    .hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeDefault,
                                    ),
                                    // Features list
                                    ...plan.features.map((feature) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: Dimensions.paddingSizeSmall,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                feature,
                                                style: textSmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeDefault,
                                    ),
                                    ButtonWidget(
                                      buttonText: 'subscribe'.tr,
                                      onPressed: () {
                                        subscriptionController
                                            .purchaseSubscription(plan.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (plan.isMostPopular)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.paddingSizeSmall,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(
                                          Dimensions.radiusDefault,
                                        ),
                                        bottomLeft: Radius.circular(
                                          Dimensions.radiusSmall,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'most_popular'.tr,
                                      style: textSmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
