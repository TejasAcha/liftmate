import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {

    /// SharedPreferences
    Get.lazyPut<SharedPreferences>(() => throw UnimplementedError());

    /// ApiClient
    Get.lazyPut<ApiClient>(() => ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ));
  }
}
