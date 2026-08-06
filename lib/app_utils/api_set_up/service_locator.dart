import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/dio_clients.dart';
final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(ApiCall(dioClient: getIt<DioClient>()));
}
