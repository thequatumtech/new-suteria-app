import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/Screens/HomeScreen/home_screen_bottom.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
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
      try {
        List<InternetAddress> addresses = await InternetAddress.lookup('kre8consultancy.com');
        if (addresses.isNotEmpty) {
          print("SERVER DOMAIN IP: ${addresses.first.address}");
        }
      } catch (e) {
        print("DOMAIN IP LOOKUP FAILED: $e");
      }

      Map<String, String> header = await getHeader();
      header['Accept'] = 'application/json';

      Map<String, dynamic> data = {
        emailKey: emailController.value.text,
        mobileNoKey: phoneno.value.text,
        passwordKey: passwordController.value.text,
      };
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(
        context: context,
        endpoint: loginURL,
        body: data,
        options: Options(headers: header),
      );
      print("LOGIN RESPONSE: $response");
      if ((response[statusCode] == 200 || response[statusCode] == 201) && response[tokenKey] != null && response[tokenKey].toString().isNotEmpty && response[tokenKey] != "null") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString(tokenKey, response[tokenKey].toString());
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePageBottomNav()), (route) => false);
      } else {
        isLoading.value = false;
        String msg = response[messageKey]?.toString() ?? response['message']?.toString() ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: msg, txtColor: primaryWhite, size: 12)));
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("LOGIN ERROR: $e");
      String errorMsg = somethingWentWrong;
      if (e is DioException && e.response != null) {
        print("LOGIN DIO RESPONSE: ${e.response?.data}");
        errorMsg = e.response?.data?[messageKey]?.toString() ?? e.response?.statusMessage ?? errorMsg;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: errorMsg,
        txtColor: primaryWhite,
        size: 12,
      )));
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
