import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class ImageController extends GetxController {
  final repo = getIt.get<ApiCall>();

  Future<List<String>> uploadMultiImageApi(BuildContext context, List<String> images, int insuranceType) async {
    List<String> imgUrl = [];
    for (var element in images) {
      String data = await uploadImageApi(context, element, insuranceType);
      imgUrl.add(data);
    }
    return imgUrl;
  }

  Future<String> uploadImageApi(BuildContext context, String images, int insuranceType) async {
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> data = {
        'document': [
          await dio.MultipartFile.fromFile(images),
        ],
        'insurance_type': insuranceType,
      };
     /* data.addAll({
        'document': [
          await dio.MultipartFile.fromFile(images),
        ],
      });*/

      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).formDataRequest(context: context, endpoint: uploadDocument, body: data, options: Options(headers: header));

      if (response[statusCode] == 200 || response[statusCode] == 201) {
        String data = response["data"]["document"];
        print("image url <<<< $data");
        return data;
      } else {
        return "";
      }
    } on DioError catch (e) {
      return "";
    }
  }

  removeUploadDocumentApi(context, String documentUrl) async {
    try {
      // isLoadingPetsInsurancePlan.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$removeUploadDocument$documentUrl", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        return response[statusCode];
        // homeInsurancePlaneModel.value = HomeInsurancePlaneModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      // isLoadingPetsInsurancePlan.value = false;
    } on DioError catch (e) {
      // isLoadingPetsInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      // isLoadingPetsInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

}
