import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class SubscriptionService implements SubscriptionServiceInterface {
  final ApiClient apiClient;

  SubscriptionService({required this.apiClient});

  @override
  Future<Response> getSubscriptionPlans() async {
    return await apiClient.getData(AppConstants.getSubscriptionPlans);
  }

  @override
  Future<Response> getUserSubscription() async {
    return await apiClient.getData(AppConstants.getUserSubscription);
  }

  @override
  Future<Response> purchaseSubscription(String planId) async {
    return await apiClient.postData(
      AppConstants.purchaseSubscription,
      {'plan_id': planId},
    );
  }

  @override
  Future<Response> cancelSubscription(String subscriptionId) async {
    return await apiClient.postData(
      AppConstants.cancelSubscription,
      {'subscription_id': subscriptionId},
    );
  }

  @override
  Future<Response> renewSubscription(String subscriptionId) async {
    return await apiClient.postData(
      AppConstants.renewSubscription,
      {'subscription_id': subscriptionId},
    );
  }
}
