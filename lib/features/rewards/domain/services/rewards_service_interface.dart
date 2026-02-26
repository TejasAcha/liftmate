import 'package:get/get.dart';

abstract class RewardsServiceInterface {
  Future<Response> getSpinnerConfig();
  Future<Response> spinWheel();
}
