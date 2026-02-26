import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/screens/splash_screen.dart';
import 'package:ride_sharing_user_app/features/call/screens/call_screen.dart';
import 'package:ride_sharing_user_app/features/call/screens/call_history_screen.dart';
import 'package:ride_sharing_user_app/features/call/screens/incoming_call_screen.dart';
import 'package:ride_sharing_user_app/features/subscription/screens/subscription_plans_screen.dart';
import 'package:ride_sharing_user_app/features/subscription/screens/subscription_details_screen.dart';
import 'package:ride_sharing_user_app/features/invoice/screens/invoice_list_screen.dart';
import 'package:ride_sharing_user_app/features/invoice/screens/invoice_detail_screen.dart';
import 'package:ride_sharing_user_app/features/rewards/screens/wheel_spinner_screen.dart';

class RouteHelper {
  static const String splash = '/splash';
  static String getCallScreen({String recipientId = '', String recipientName = '', String recipientImage = '', String callType = 'audio'}) 
    => '/call-screen?recipientId=$recipientId&recipientName=$recipientName&recipientImage=$recipientImage&callType=$callType';
  static String getCallHistoryScreen() => '/call-history-screen';
  static String getIncomingCallScreen({String callId = '', String callType = 'audio', String callerId = '', String callerName = '', String callerImage = ''}) 
    => '/incoming-call-screen?callId=$callId&callType=$callType&callerId=$callerId&callerName=$callerName&callerImage=$callerImage';
  static String getSubscriptionPlansScreen() => '/subscription-plans-screen';
  static String getSubscriptionDetailsScreen() => '/subscription-details-screen';
  static String getInvoiceListScreen() => '/invoice-list-screen';
  static String getInvoiceDetailScreen({String invoiceId = ''}) => '/invoice-detail-screen';
  static String getWheelSpinnerScreen() => '/wheel-spinner-screen';
  
  // Short routes for navigation
  static const String invoiceList = '/invoice-list';
  static const String invoiceDetail = '/invoice-detail';
  
  static String getSplashRoute({Map<String,dynamic>? notificationData}) {
    notificationData?.remove('body');
    String userName = (notificationData?['user_name'] ?? '').replaceAll('&','a');
    notificationData?.remove('user_name');

    return '$splash?notification=${jsonEncode(notificationData)}&userName=$userName';
  }
  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(
        notificationData: Get.parameters['notification'] == null
            ? null
            : jsonDecode(Get.parameters['notification']!),
        userName: Get.parameters['userName']?.replaceAll('a', '&'),
      ),
    ),

    GetPage(
      name: getCallScreen(),
      page: () => CallScreen(
        recipientId: Get.parameters['recipientId'] ?? '',
        recipientName: Get.parameters['recipientName'] ?? '',
        recipientImage: Get.parameters['recipientImage'] ?? '',
      ),
    ),

    GetPage(
      name: getCallHistoryScreen(),
      page: () => CallHistoryScreen(),
    ),

    GetPage(
      name: getIncomingCallScreen(),
      page: () => IncomingCallScreen(
        callId: Get.parameters['callId'] ?? '',
        callType: Get.parameters['callType'] ?? 'audio',
        callerId: Get.parameters['callerId'] ?? '',
        callerName: Get.parameters['callerName'] ?? '',
        callerImage: Get.parameters['callerImage'] ?? '',
      ),
    ),

    GetPage(
      name: getSubscriptionPlansScreen(),
      page: () => SubscriptionPlansScreen(),
    ),

    GetPage(
      name: getSubscriptionDetailsScreen(),
      page: () => SubscriptionDetailsScreen(),
    ),

    GetPage(
      name: getInvoiceListScreen(),
      page: () => InvoiceListScreen(),
    ),

    GetPage(
      name: getInvoiceDetailScreen(),
      page: () => const InvoiceDetailScreen(),
    ),

    GetPage(
      name: invoiceList,
      page: () => InvoiceListScreen(),
    ),

    GetPage(
      name: invoiceDetail,
      page: () => InvoiceDetailScreen(),
    ),

    GetPage(
      name: getWheelSpinnerScreen(),
      page: () => WheelSpinnerScreen(),
    ),
  ];

  static void goPageAndHideTextField(BuildContext context, Widget page){
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    currentFocus.requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    Future.delayed(const Duration(milliseconds: 300)).then((_){
      Get.to(() => page);

    });

  }

}