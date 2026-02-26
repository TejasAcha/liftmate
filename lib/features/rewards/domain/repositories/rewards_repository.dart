import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/rewards/domain/repositories/rewards_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class RewardsRepository implements RewardsRepositoryInterface {
  final ApiClient apiClient;

  RewardsRepository({required this.apiClient});

  @override
  Future<Response> getSpinnerConfig() async {
    return await apiClient.getData(AppConstants.GET_SPINNER_REWARDS);
  }

  @override
  Future<Response> spinWheel() async {
    return await apiClient.postData(AppConstants.SPIN_WHEEL, {});
  }
}
