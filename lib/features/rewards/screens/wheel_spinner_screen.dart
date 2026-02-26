import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/rewards/controllers/rewards_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';

class WheelSpinnerScreen extends StatefulWidget {
  const WheelSpinnerScreen({super.key});

  @override
  State<WheelSpinnerScreen> createState() => _WheelSpinnerScreenState();
}

class _WheelSpinnerScreenState extends State<WheelSpinnerScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<RewardsController>().getSpinnerRewards();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Spin & Win'.tr),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'spin_to_win'.tr,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'spins_remaining'.tr,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${controller.spinsRemaining ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Rewards List
                        if (controller.spinnerConfigModel?.data?.rewards != null &&
                            controller.spinnerConfigModel!.data!.rewards!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'available_rewards'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount:
                                    controller.spinnerConfigModel!.data!.rewards!.length,
                                itemBuilder: (context, index) {
                                  final reward = controller
                                      .spinnerConfigModel!.data!.rewards![index];
                                  return _buildRewardCard(reward);
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),

                        // Spin Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: controller.canSpin
                                ? () => controller.spinWheel()
                                : null,
                            icon: controller.isSpinning
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.casino),
                            label: Text(
                              controller.isSpinning
                                  ? 'spinning'.tr
                                  : (controller.canSpin
                                      ? 'spin_now'.tr
                                      : 'no_spins_left'.tr),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildRewardCard(dynamic reward) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard,
              size: 32,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            Text(
              reward.title ?? 'Unknown',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (reward.amount != null && reward.amount! > 0)
              Text(
                '+${PriceConverter.convertPrice(reward.amount ?? 0.0)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}