import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' as g;
import 'package:get/get_core/src/get_main.dart';
import 'package:soperia_user/Screens/AuthScreen/select_language.dart';
import 'package:soperia_user/app_utils/api_set_up/dio_clients.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/network_util.dart';

class ApiCall {
  final DioClient dioClient;

  ApiCall({required this.dioClient});

  Future<Map<String, dynamic>> postRequest({required BuildContext context, required String endpoint, Map<String, dynamic>? body, Options? options}) async {
    try {
      bool isConnect = await NetworkUtil().isConnected(context, () {});
      if (!isConnect) {
        // customSnackBar(context, networkError, AnimatedSnackBarType.error);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: AppText(text: networkError,size: 14,txtColor: primaryWhite)));

      } else {
        // allApiCall(context,options);
        Response response = await dioClient.post(endpoint, data: body, options: options);

        Map<String, dynamic> data = response.data;

        /* if (data['status'] == true) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: AppText(text: response.statusMessage!,size: 14,txtColor: ColorConstraint.primarywhite)));
               }*/

        /* if (data['status_code'] == 401) {
           logout(context);
        }*/

        return data;
      }
      return {};
    } catch (e) {
      print(e);
      rethrow;
    }
  }
Future<Map<String, dynamic>> postRequestFormData({required BuildContext context, required String endpoint, Map<String, dynamic>? body, Options? options}) async {
    try {
      bool isConnect = await NetworkUtil().isConnected(context, () {});
      if (!isConnect) {
        // customSnackBar(context, networkError, AnimatedSnackBarType.error);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: AppText(text: networkError,size: 14,txtColor: primaryWhite)));

      } else {
        // allApiCall(context,options);
        Response response = await dioClient.post(endpoint, data: FormData.fromMap(body??{}), options: options);

        Map<String, dynamic> data = response.data;

        /* if (data['status'] == true) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: AppText(text: response.statusMessage!,size: 14,txtColor: ColorConstraint.primarywhite)));
               }*/

        /* if (data['status_code'] == 401) {
           logout(context);
        }*/

        return data;
      }
      return {};
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> formDataRequest({required BuildContext context, required String endpoint, Map<String, dynamic>? body, Options? options}) async {
    try {
      bool isConnect = await NetworkUtil().isConnected(context, () {});
      if (!isConnect) {
        // customSnackBar(context, networkError, AnimatedSnackBarType.error);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: AppText(text: networkError,size: 14,txtColor: primaryWhite)));

      } else {
        // allApiCall(context,options);
        Response response = await dioClient.post(endpoint, data: FormData.fromMap(body ?? {}), options: options);

        Map<String, dynamic> data = response.data;

        /* if (data['status'] == true) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: AppText(text: response.statusMessage!,size: 14,txtColor: ColorConstraint.primarywhite)));
               }*/

        /* if (data['status_code'] == 401) {
           logout(context);
        }*/

        return data;
      }
      return {};
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getRequest({required BuildContext context, required String endpoint, Options? options}) async {
    try {
      bool isConnect = await NetworkUtil().isConnected(context, () {});
      if (!isConnect) {
        // customSnackBar(context, networkError, AnimatedSnackBarType.error);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: AppText(text: networkError,size: 14,txtColor: primaryWhite)));

      } else {
        // allApiCall(context,options);
        final Response response = await dioClient.get(endpoint, options: options);
        Map<String, dynamic> data = response.data;

        /* if (data['status'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: AppText(text: response.statusMessage!,size: 14,txtColor: ColorConstraint.primarywhite)));
      }*/
        /*  if (data['status_code'] == 401) {
          logout(context);
        }*/

        return data;
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }

  getRequestList({required BuildContext context, required String endpoint, Options? options}) async {
    try {
      bool isConnect = await NetworkUtil().isConnected(context, () {});
      if (!isConnect) {
        // customSnackBar(context, networkError, AnimatedSnackBarType.error);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: AppText(text: networkError,size: 14,txtColor: primaryWhite)));

      } else {
        // allApiCall(context,options);
        var response = await dioClient.get(endpoint, options: options);
        var data = response;

        /* if (data['status'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: AppText(text: response.statusMessage!,size: 14,txtColor: ColorConstraint.primarywhite)));
      }*/
        /*  if (data['status_code'] == 401) {
          logout(context);
        }*/

        return data;
      }
      return {};
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


  void logout(BuildContext context) {
    SharedPreferences _pref = Get.find();
    _pref.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectLanguage()));
  }
}
