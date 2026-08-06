import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/custome.dart';

class ChangePasswordController extends GetxController {

  final repo = getIt.get<ApiCall>();

  Rx<TextEditingController> oldPassController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> reEnterPasswordController = TextEditingController().obs;
  RxBool isLoadingChangePassword = false.obs;

  Future<void> changePasswordApi(BuildContext context) async {
    isLoadingChangePassword.value = true;

    // Request body matching your raw data requirements
    Map<String, dynamic> data = {
      "old_password": oldPassController.value.text,
      "password": passwordController.value.text,
      "password_confirmation": reEnterPasswordController.value.text
    };

    try {
      // getHeader() should include your 'Authorization': 'Bearer <token>'
      Map<String, String> header = await getHeader();

      // Update endpoint to "change-password"
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequest(
          context: context,
          endpoint: "change-password", // New endpoint
          body: data,
          options: Options(headers: header)
      );

      if (response[statusCode] == 200 || response[statusCode] == 201) {
        showToast(response[messageKey].toString(), context);
        reEnterPasswordController.value.clear();
        passwordController.value.clear();
        oldPassController.value.clear();
        Get.back(); // Or navigate to profile/settings
      } else {
        showToast(response[messageKey].toString(), context);
      }
    } catch (e) {
      showToast("Error: $e", context);
    } finally {
      isLoadingChangePassword.value = false;


    }
  }
}