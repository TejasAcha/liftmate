import 'package:get/get.dart';

abstract class RewardsRepositoryInterface {
  Future<Response> getSpinnerConfig();
  Future<Response> spinWheel();
}
