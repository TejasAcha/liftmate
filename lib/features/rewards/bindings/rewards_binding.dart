import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import '../controllers/rewards_controller.dart';
import '../domain/services/rewards_service.dart';
import '../domain/services/rewards_service_interface.dart';
import '../domain/repositories/rewards_repository.dart';
import '../domain/repositories/rewards_repository_interface.dart';

class RewardsBinding extends Bindings {
  @override
  void dependencies() {
    /// Repository
    Get.lazyPut<RewardsRepositoryInterface>(
      () => RewardsRepository(
        apiClient: Get.find<ApiClient>(),
      ),
    );

    /// Service
    Get.lazyPut<RewardsServiceInterface>(
      () => RewardsService(
        rewardsRepositoryInterface: Get.find(),
      ),
    );

    /// Controller
    Get.lazyPut<RewardsController>(
      () => RewardsController(
        rewardsServiceInterface: Get.find(),
      ),
    );
  }
}