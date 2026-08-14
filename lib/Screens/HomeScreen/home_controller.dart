import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/model_class/get_banner_model.dart';
import 'package:soperia_user/model_class/get_profile_model.dart';

import '../../app_utils/api_set_up/service_locator.dart';

class HomeController extends GetxController {
  final repo = getIt.get<ApiCall>();
  RxBool isLoading = false.obs;
  RxBool isBannerLoading = false.obs;
  Rx<GetBannerModel> getBannerModel = GetBannerModel().obs;
  Rx<GetProfileModel> rxGetProfileModel = GetProfileModel().obs;

  Future<void> getProfile(context, {bool showLoading = true}) async {
    if (rxGetProfileModel.value.data != null || getProfileModelGlobal.data != null) {
      showLoading = false;
    }
    if (showLoading) {
      isLoading.value = true;
    }
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getProfileURL, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getProfileModelGlobal = GetProfileModel.fromJson(response);
        rxGetProfileModel.value = getProfileModelGlobal;
      }
    } catch (e) {
      print(e);
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> getBanners(context, {bool showLoading = true}) async {
    if (getBannerModel.value.data != null && getBannerModel.value.data!.isNotEmpty) {
      showLoading = false;
    }
    if (showLoading) {
      isBannerLoading.value = true;
    }
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getBannerURL, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getBannerModel.value = GetBannerModel.fromJson(response);
      }
    } catch (e) {
      print(e);
    } finally {
      if (showLoading) {
        isBannerLoading.value = false;
      }
    }
  }

  Future<void> refreshHome(context) async {
    await Future.wait([
      getProfile(context, showLoading: false),
      getBanners(context, showLoading: false),
    ]);
  }
}


