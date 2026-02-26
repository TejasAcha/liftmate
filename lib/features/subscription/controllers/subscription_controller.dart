import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/subscription/domain/models/subscription_plan_model.dart';
import 'package:ride_sharing_user_app/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionServiceInterface subscriptionServiceInterface;

  SubscriptionController({required this.subscriptionServiceInterface});

  List<SubscriptionPlanModel> subscriptionPlans = [];
  UserSubscriptionModel? userSubscription;
  bool isLoading = false;

  @override
  void onInit() {
    getSubscriptionPlans();
    getUserSubscription();
    super.onInit();
  }

  Future<void> getSubscriptionPlans() async {
    isLoading = true;
    update();

    try {
      Response response = await subscriptionServiceInterface.getSubscriptionPlans();

      if (response.statusCode == 200) {
        subscriptionPlans.clear();
        if (response.body['data'] != null) {
          response.body['data'].forEach((plan) {
            subscriptionPlans.add(SubscriptionPlanModel.fromJson(plan));
          });
        }
        isLoading = false;
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      showCustomSnackBar('error_loading_plans'.tr);
    }

    update();
  }

  Future<void> getUserSubscription() async {
    try {
      Response response = await subscriptionServiceInterface.getUserSubscription();

      if (response.statusCode == 200) {
        if (response.body['data'] != null) {
          userSubscription = UserSubscriptionModel.fromJson(response.body['data']);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('Error getting user subscription: $e');
    }

    update();
  }

  Future<void> purchaseSubscription(String planId) async {
    isLoading = true;
    update();

    try {
      Response response =
          await subscriptionServiceInterface.purchaseSubscription(planId);

      if (response.statusCode == 200) {
        isLoading = false;
        showCustomSnackBar('subscription_purchased'.tr, isError: false);
        await getUserSubscription();
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      showCustomSnackBar('error_purchasing_subscription'.tr);
    }

    update();
  }

  Future<void> cancelSubscription() async {
    if (userSubscription == null) return;

    isLoading = true;
    update();

    try {
      Response response = await subscriptionServiceInterface
          .cancelSubscription(userSubscription!.id);

      if (response.statusCode == 200) {
        isLoading = false;
        showCustomSnackBar('subscription_cancelled'.tr, isError: false);
        userSubscription = null;
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      showCustomSnackBar('error_cancelling_subscription'.tr);
    }

    update();
  }

  Future<void> renewSubscription() async {
    if (userSubscription == null) return;

    isLoading = true;
    update();

    try {
      Response response =
          await subscriptionServiceInterface.renewSubscription(userSubscription!.id);

      if (response.statusCode == 200) {
        isLoading = false;
        showCustomSnackBar('subscription_renewed'.tr, isError: false);
        await getUserSubscription();
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      showCustomSnackBar('error_renewing_subscription'.tr);
    }

    update();
  }

  bool hasActiveSubscription() {
    return userSubscription != null && userSubscription!.isActive;
  }

  int getDaysRemainingInSubscription() {
    if (userSubscription == null) return 0;
    final difference = userSubscription!.expiryDate.difference(DateTime.now());
    return difference.inDays;
  }

  String getSubscriptionStatus() {
    if (userSubscription == null) return 'no_subscription'.tr;
    if (hasActiveSubscription()) {
      return '${'active_until'.tr}: ${userSubscription!.expiryDate.toString().split(' ')[0]}';
    }
    return userSubscription!.status.tr;
  }
}
