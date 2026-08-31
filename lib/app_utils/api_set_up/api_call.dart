import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' as g;
import 'package:get/get_core/src/get_main.dart';
import 'package:soperia_user/Screens/AuthScreen/select_language.dart';
import 'package:soperia_user/Screens/SingupScreen/sign_up_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/dio_clients.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/network_util.dart';
import 'package:soperia_user/language/language_constants.dart';

class ApiCall {
  final DioClient dioClient;

  ApiCall({required this.dioClient});

  Future<Map<String, dynamic>> postRequest({required BuildContext context, required String endpoint, Map<String, dynamic>? body, Options? options}) async {
    try {
      Response response = await dioClient.post(endpoint, data: body, options: options);
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {};
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout || e.error is SocketException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: networkError, size: 14, txtColor: primaryWhite)));
      }
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postRequestFormData({required BuildContext context, required String endpoint, Map<String, dynamic>? body, Options? options}) async {
    try {
      Response response = await dioClient.post(endpoint, data: FormData.fromMap(body ?? {}), options: options);
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {};
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout || e.error is SocketException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: networkError, size: 14, txtColor: primaryWhite)));
      }
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> formDataRequest({required BuildContext context, required String endpoint, Map<String, dynamic>? body, Options? options}) async {
    try {
      Response response = await dioClient.post(endpoint, data: FormData.fromMap(body ?? {}), options: options);
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {};
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout || e.error is SocketException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: networkError, size: 14, txtColor: primaryWhite)));
      }
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getRequest({required BuildContext context, required String endpoint, Options? options}) async {
    try {
      final Response response = await dioClient.get(endpoint, options: options);
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {};
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout || e.error is SocketException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: networkError, size: 14, txtColor: primaryWhite)));
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  getRequestList({required BuildContext context, required String endpoint, Options? options}) async {
    try {
      var response = await dioClient.get(endpoint, options: options);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout || e.error is SocketException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: networkError, size: 14, txtColor: primaryWhite)));
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
 /* allApiCall(BuildContext context,Options? options) {
    if (options != null){
      AddOfflineData addOfflineData = Get.put(AddOfflineData());
      SettingsApiController settingsApiController = Get.put(SettingsApiController());

      settingsApiController.allSettingsApi(context);
      addOfflineData.addOfflineDataApi(context);
    }

  }*/


  void logout(BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String currentLang = _pref.getString('selected_language') ?? _pref.getString(LAGUAGE_CODE) ?? 'en';
    await _pref.clear();
    await _pref.setString('selected_language', currentLang);
    await _pref.setString(LAGUAGE_CODE, currentLang);
    if (g.Get.isRegistered<SignUpController>()) {
      g.Get.find<SignUpController>().clearData();
      g.Get.delete<SignUpController>(force: true);
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SelectLanguage()), (route) => false);
  }
}
