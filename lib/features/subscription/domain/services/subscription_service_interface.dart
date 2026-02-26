import 'package:get/get.dart';


abstract class SubscriptionServiceInterface {
  Future<Response> getSubscriptionPlans();
  Future<Response> getUserSubscription();
  Future<Response> purchaseSubscription(String planId);
  Future<Response> cancelSubscription(String subscriptionId);
  Future<Response> renewSubscription(String subscriptionId);
}
