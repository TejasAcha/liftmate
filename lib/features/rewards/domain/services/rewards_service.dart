import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/rewards/domain/repositories/rewards_repository_interface.dart';
import 'package:ride_sharing_user_app/features/rewards/domain/services/rewards_service_interface.dart';

class RewardsService implements RewardsServiceInterface {
  final RewardsRepositoryInterface rewardsRepositoryInterface;

  RewardsService({required this.rewardsRepositoryInterface});

  @override
  Future<Response> getSpinnerConfig() async {
    return await rewardsRepositoryInterface.getSpinnerConfig();
  }

  @override
  Future<Response> spinWheel() async {
    return await rewardsRepositoryInterface.spinWheel();
  }
}
