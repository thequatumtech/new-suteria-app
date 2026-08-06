import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/model_class/get_profile_model.dart';

import '../../app_utils/api_set_up/service_locator.dart';

class HomeController extends GetxController {
  final repo = getIt.get<ApiCall>();
  RxBool isLoading = false.obs;

  getProfile(context) async {
    await Future.delayed(const Duration(milliseconds: 200));
    isLoading.value = true;
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getProfileURL, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getProfileModelGlobal = GetProfileModel.fromJson(response);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }
}
