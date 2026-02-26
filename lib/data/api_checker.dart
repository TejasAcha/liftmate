// import 'package:get/get.dart';
// import 'package:ride_sharing_user_app/features/auth/domain/models/error_response.dart';
// import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
// import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
// import 'package:ride_sharing_user_app/helper/display_helper.dart';
//
// class ApiChecker {
//   static void checkApi(Response response) {
//     if(response.statusCode == 401) {
//       Get.find<ConfigController>().removeSharedData();
//       Get.offAll(()=> const SignInScreen());
//
//     }else if(response.statusCode == 403) {
//       ErrorResponse errorResponse;
//       errorResponse = ErrorResponse.fromJson(response.body);
//       if(errorResponse.errors != null && errorResponse.errors!.isNotEmpty){
//         showCustomSnackBar(errorResponse.errors![0].message!);
//       }else{
//         showCustomSnackBar(response.body['message']);
//       }
//
//     }else if(response.statusCode == 422) {
//       ErrorResponse errorResponse;
//       errorResponse = ErrorResponse.fromJson(response.body);
//       if(errorResponse.errors != null && errorResponse.errors!.isNotEmpty){
//         showCustomSnackBar(errorResponse.errors![0].message!);
//       }else{
//         showCustomSnackBar(response.body['message']);
//       }
//
//     }else if(response.statusCode == 500){
//       showCustomSnackBar(response.statusText!);
//     }else {
//       showCustomSnackBar(response.statusText!);
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Future.microtask(() {
        if (Get.isRegistered<ConfigController>()) {
          Get.find<ConfigController>().removeSharedData();
        }
        Get.offAll(() => const SignInScreen());
      });
    } else if (response.statusCode == 403 || response.statusCode == 422) {
      String errorMessage = 'An error occurred';
      try {
        if (response.body != null && response.body is Map) {
          if (response.body['errors'] != null && response.body['errors'].isNotEmpty) {
            errorMessage = response.body['errors'][0]['message'] ??
                response.body['message'] ??
                errorMessage;
          } else if (response.body['message'] != null) {
            errorMessage = response.body['message'];
          }
        }
      } catch (e) {
        errorMessage = response.statusText ?? 'Error ${response.statusCode}';
      }

      Future.microtask(() {
        showCustomSnackBar(errorMessage);
      });
    } else if (response.statusCode == 500) {
      Future.microtask(() {
        showCustomSnackBar('Server error occurred');
      });
    } else if (response.statusText != null && response.statusText!.isNotEmpty) {
      Future.microtask(() {
        showCustomSnackBar(response.statusText!);
      });
    }
  }
}