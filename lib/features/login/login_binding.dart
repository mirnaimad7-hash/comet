import 'package:get/get.dart';
import 'package:comet/core/api/dio_consumer.dart';
import 'package:comet/core/api/api_consumer.dart';
import 'package:comet/data/auth_repository.dart';
import 'package:comet/core/networking/api_client.dart';
import 'loginController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    final dio = ApiClient.dio;

    final ApiConsumer apiConsumer = DioConsumer(dio);

    Get.lazyPut<AuthRepository>(() => AuthRepository(apiConsumer));

    Get.lazyPut(() => LoginController(Get.find<AuthRepository>()));
  }
}
