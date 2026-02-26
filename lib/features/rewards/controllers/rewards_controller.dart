import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/rewards/domain/models/rewards_model.dart';
import 'package:ride_sharing_user_app/features/rewards/domain/services/rewards_service_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

class RewardsController extends GetxController implements GetxService {
  final RewardsServiceInterface rewardsServiceInterface;

  RewardsController({required this.rewardsServiceInterface});

  bool isLoading = false;
  bool isSpinning = false;
  SpinnerConfigModel? spinnerConfigModel;
  SpinResult? lastSpinResult;

  late AnimationController spinAnimationController;

  @override
  void onInit() {
    super.onInit();
    getSpinnerConfig();
  }

  /// Wrapper method for UI - loads spinner rewards
  Future<void> getSpinnerRewards() async {
    await getSpinnerConfig();
  }

  Future<void> getSpinnerConfig() async {
    isLoading = true;
    update();

    try {
      Response response = await rewardsServiceInterface.getSpinnerConfig();

      if (response.statusCode == 200) {
        spinnerConfigModel = SpinnerConfigModel.fromJson(response.body);
        isLoading = false;
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      //displayErrorSnackbar('failed_to_load_rewards'.tr);
      showCustomSnackBar('failed_to_load_rewards'.tr, isError: true);
    }
    update();
  }

  Future<void> spinWheel() async {
    if (isSpinning) return;
    if (!(spinnerConfigModel?.data?.canSpin ?? false)) {
      //displayErrorSnackbar('no_spins_remaining'.tr);
      showCustomSnackBar('no_spins_remaining'.tr, isError: true);
      return;
    }

    isSpinning = true;
    update();

    try {
      Response response = await rewardsServiceInterface.spinWheel();

      if (response.statusCode == 200) {
        lastSpinResult = SpinResult.fromJson(response.body['data']);
        
        // Credit reward to wallet
        //if (lastSpinResult?.walletCreditAmount ?? 0.0 > 0)
         if ((lastSpinResult?.walletCreditAmount ?? 0.0) > 0){
          _creditRewardToWallet(lastSpinResult?.walletCreditAmount ?? 0.0);
        }

        // Show reward result dialog
        _showRewardDialog(lastSpinResult!);

        // Refresh spinner config
        Future.delayed(const Duration(seconds: 2), () {
          getSpinnerConfig();
        });

        isSpinning = false;
      } else {
        isSpinning = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isSpinning = false;
      //displayErrorSnackbar('spin_failed'.tr);
      showCustomSnackBar('spin_failed'.tr, isError: true);
    }
    update();
  }

  void _creditRewardToWallet(double amount) {
    try {
      // Update profile wallet balance
      final profileController = Get.find<ProfileController>();
      profileController.getProfileInfo();

      // Refresh wallet controller
      try {
        final walletController = Get.find<WalletController>();
        walletController.getTransactionList(1);
      } catch (e) {
        // Wallet controller might not be initialized
      }
    } catch (e) {
      //displayErrorSnackbar('failed_to_update_wallet'.tr);
      showCustomSnackBar('failed_to_update_wallet'.tr, isError: true);
    }
  }

  void _showRewardDialog(SpinResult result) {
    Get.dialog(
      AlertDialog(
        title: Text('congratulations'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              size: 48,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              result.reward?.title ?? 'reward_received'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (result.reward?.description != null)
              Text(
                result.reward!.description!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 16),
            //if(result.walletCreditAmount ?? 0.0 > 0)
            if ((result.walletCreditAmount ?? 0.0) > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${result.walletCreditAmount} ${result.reward?.type == 'wallet_credit' ? 'currency'.tr : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  bool get canSpin => (spinnerConfigModel?.data?.canSpin ?? false) && !isSpinning;

  int? get spinsRemaining => spinnerConfigModel?.data?.spinsRemaining;
}
