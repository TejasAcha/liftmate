// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ride_sharing_user_app/helper/responsive_helper.dart';
// import 'package:ride_sharing_user_app/util/dimensions.dart';
// import 'package:ride_sharing_user_app/util/images.dart';
// import 'package:ride_sharing_user_app/util/styles.dart';
//
// void customPrint(String message) {
//   if(kDebugMode) {
//     print(message);
//   }
// }
//
// void showCustomSnackBar(String message, {bool isError = true, int seconds = 3,String? subMessage}) {
//   if (Get.isSnackbarOpen) {
//     Get.closeCurrentSnackbar();
//   }
//   Get.showSnackbar(GetSnackBar(
//     dismissDirection: DismissDirection.horizontal,
//     margin: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(
//       right: ResponsiveHelper.isDesktop ? Get.context!.width*0.7 : Dimensions.paddingSizeSmall,
//     ),
//     duration: Duration(seconds: seconds),
//     backgroundColor: Get.isDarkMode ? Colors.white : Theme.of(Get.context!).textTheme.titleMedium!.color!,
//     borderRadius: Dimensions.paddingSizeSmall,
//     messageText: Row(children: [
//       Image.asset(isError ? Images.errorMessageIcon : Images.successMessageIcon,height: 20,width: 20,),
//
//       const SizedBox(width: Dimensions.paddingSize,),
//       Expanded(child: SizedBox(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(message, style: textMedium.copyWith(color: Get.isDarkMode ? Theme.of(Get.context!).textTheme.titleMedium!.color : Colors.white)),
//         subMessage != null ?
//         Text(subMessage, style: textMedium.copyWith(color: Colors.white.withValues(alpha:0.75))) : const SizedBox(),
//
//       ]))),
//
//     ]),
//
//   ));
//
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/responsive_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

void customPrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}

void showCustomSnackBar(String message, {bool isError = true, int seconds = 3, String? subMessage}) {
  // Check if we're in a valid context
  if (Get.context == null) return;

  // Close any existing snackbar safely
  if (Get.isSnackbarOpen) {
    Get.back();
  }

  // Use a small delay to ensure UI is ready
  Future.delayed(const Duration(milliseconds: 50), () {
    try {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(
            right: ResponsiveHelper.isDesktop ? Get.context!.width * 0.7 : Dimensions.paddingSizeSmall,
          ),
          duration: Duration(seconds: seconds),
          backgroundColor: isError ? Colors.red : Colors.green,
          borderRadius: Dimensions.paddingSizeSmall,
          messageText: Row(
            children: [
              Image.asset(
                isError ? Images.errorMessageIcon : Images.successMessageIcon,
                height: 20,
                width: 20,
                color: Colors.white,
              ),
              const SizedBox(width: Dimensions.paddingSize),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: textMedium.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                    if (subMessage != null && subMessage.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subMessage,
                        style: textMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: Dimensions.fontSizeExtraSmall,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // Fallback to regular snackbar if GetX fails
      if (Get.context != null && Get.context!.mounted) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isError ? Colors.red : Colors.green,
            duration: Duration(seconds: seconds),
          ),
        );
      }
    }
  });
}