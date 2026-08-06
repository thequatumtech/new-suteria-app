import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/login_screen.dart';
import 'package:soperia_user/Screens/AuthScreen/otp_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/forgot_otp_send_model.dart';

class AuthController extends GetxController {
  final repo = getIt.get<ApiCall>();

  Rx<TextEditingController> mobileNoController = TextEditingController().obs;
  Rx<ForgotOtpSendModel> forgotOtpSendModel = ForgotOtpSendModel().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> reEnterPasswordController = TextEditingController().obs;
  RxBool isLoadingSendOtp = false.obs;
  RxBool isLoadingForgotPassword = false.obs;

  forgotOtpSendPostApi({required BuildContext context, required bool isResend, required bool isFromSignup}) async {
    isLoadingSendOtp.value = true;
    Map<String, dynamic> data = {'phone': mobileNoController.value.text};

    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response =
          await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: isFromSignup ? registerOtpSend : forgotOtpSend, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        forgotOtpSendModel.value = ForgotOtpSendModel.fromJson(response);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingSendOtp.value = false;
    } on DioError catch (e) {
      isLoadingSendOtp.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      print(f);
      isLoadingSendOtp.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  forgotPasswordPostApi(context) async {
    isLoadingForgotPassword.value = true;
    Map<String, dynamic> data = {
      'id': forgotOtpSendModel.value.data!.id ?? 0,
      'otp': forgotOtpSendModel.value.data!.otp ?? 0,
      'password': reEnterPasswordController.value.text,
    };

    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: forgotPassword, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingForgotPassword.value = false;
    } on DioError catch (e) {
      isLoadingForgotPassword.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingForgotPassword.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }
}
