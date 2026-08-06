import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/get_policy_details_model.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class MyPoliciesController extends GetxController {
  RxBool isPoliciesActive = true.obs;
  RxBool isLoading = false.obs;
  final repo = getIt.get<ApiCall>();
  Rx<GetPolicyDetailsModel> getPolicyDetailsModel = GetPolicyDetailsModel().obs;

  clearData(BuildContext context) async {
    isPoliciesActive.value = true;

    getPolicyDetailsApi(context);
  }

  getPolicyDetailsApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getPolicyDetails, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getPolicyDetailsModel.value = GetPolicyDetailsModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: AppText(
          text: response[messageKey].toString(),
          txtColor: primaryWhite,
          size: 12,
        )));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: e.response!.statusMessage!,
        txtColor: primaryWhite,
        size: 12,
      )));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: "$f",
        txtColor: primaryWhite,
        size: 12,
      )));
    }
  }
}
