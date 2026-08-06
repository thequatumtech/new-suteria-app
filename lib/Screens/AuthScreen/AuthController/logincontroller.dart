import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/Screens/HomeScreen/home_screen_bottom.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/utils.dart';

class LoginController extends GetxController {
  TextEditingController phoneno = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool check = false.obs;
  RxBool isLoading = false.obs;
  final repo = getIt.get<ApiCall>();
  RxBool isLoadingButton = false.obs;
  RxBool isLogOut = false.obs;

  loginApi(BuildContext context) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {
        emailKey: emailController.value.text,
        mobileNoKey: phoneno.value.text,
        passwordKey: passwordController.value.text,
      };
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequest(context: context, endpoint: loginURL, body: data);
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(tokenKey, response[tokenKey]);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePageBottomNav()), (route) => false);
      } else {
        isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
        // customSnackBar(context,response[messageKey].toString(),AnimatedSnackBarType.error);
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
      // customSnackBar(context,e.response!.statusMessage!,AnimatedSnackBarType.error);
    }
  }

/*  checkLogin(BuildContext context) {
    isLoading.value = true;
    if (emailController.value.text.isEmpty && passwordController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
            text: "Please Enter Username and Password",
            txtColor: primaryWhite,
            size: 12,
          )));
      // customSnackBar(context,"Please Enter Username and Password",AnimatedSnackBarType.error);

      isLoading.value = false;
    } else {
      if (emailController.value.text.isEmpty) {
        customSnackBar(context,"Please Enter Username",AnimatedSnackBarType.error);
        isLoading.value = false;
      } else if (passwordController.value.text.isEmpty) {
        customSnackBar(context,"Please Enter Password",AnimatedSnackBarType.error);
        isLoading.value = false;
      } else {
        loginApi(context);
        return true;
      }
    }
  }*/
  loginValidation(BuildContext context) {
    isLoading.value = true;
    if (emailController.text.trim().isEmpty && phoneno.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterYourEmailID, txtColor: primaryWhite, size: 12)));
      isLoading.value = false;
    } else if (emailController.text.isNotEmpty && !Utils.isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterValidEmailId, txtColor: primaryWhite, size: 12)));
      isLoading.value = false;
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPassword, txtColor: primaryWhite, size: 12)));
      isLoading.value = false;
    } else if (check.value == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseAcceptTermsConditions, txtColor: primaryWhite, size: 12)));
      isLoading.value = false;
    } else {
      loginApi(context);
      return true;
    }
  }
}
