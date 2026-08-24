import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class InsurancePdfController extends GetxController {
  final repo = getIt.get<ApiCall>();
  RxBool isTermConditions = false.obs;
  RxBool isTermConditionsDraf = false.obs;
  RxBool isPaymentSuccess = false.obs;
  Rx<Uint8List?> signatureBytes = Rx<Uint8List?>(null);
  RxBool isSigned = false.obs;
  RxString signatureUrl = ''.obs;
  RxBool isUploadingSignature = false.obs;

  void resetTerms() {
    isTermConditions.value = false;
    isTermConditionsDraf.value = false;
    signatureBytes.value = null;
    isSigned.value = false;
    signatureUrl.value = '';
    isUploadingSignature.value = false;
  }

  Future<bool> uploadSignatureApi({
    required BuildContext context,
    required Uint8List pngBytes,
    required dynamic purchasePolicyId,
    required dynamic clientId,
  }) async {
    isUploadingSignature.value = true;
    try {
      final multipartFile = MultipartFile.fromBytes(
        pngBytes,
        filename: 'signature_${DateTime.now().millisecondsSinceEpoch}.png',
        contentType: DioMediaType('image', 'png'),
      );

      final validPurchaseId = (purchasePolicyId != null && purchasePolicyId != 0)
          ? purchasePolicyId
          : 0;

      Map<String, dynamic> data = {
        'purchase_policy_id': validPurchaseId,
        'client_id': clientId ?? 0,
        'signature': multipartFile,
      };

      print("UPLOADING SIGNATURE DATA: purchase_policy_id=$validPurchaseId, client_id=$clientId");

      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(
        context: context,
        endpoint: saveSignatureUrl,
        body: data,
        options: Options(headers: header),
      );

      print("SAVE SIGNATURE RESPONSE: $response");

      if (response[statusCode] == 200 || response[statusCode] == 201 || response['status'] == true) {
        final dataObj = response['data'];
        if (dataObj is Map && dataObj.containsKey('signature')) {
          signatureUrl.value = dataObj['signature'].toString();
        } else if (response.containsKey('signature')) {
          signatureUrl.value = response['signature'].toString();
        } else if (dataObj is String) {
          signatureUrl.value = dataObj;
        }
        signatureBytes.value = pngBytes;
        isSigned.value = true;
        isUploadingSignature.value = false;
        return true;
      } else {
        isUploadingSignature.value = false;
        String errMsg = response[messageKey]?.toString() ?? response['message']?.toString() ?? 'Failed to save signature';
        print("SAVE SIGNATURE FAILED: $errMsg");
        return false;
      }
    } on DioException catch (e) {
      isUploadingSignature.value = false;
      String errMsg = e.response?.data?['message']?.toString() ?? e.response?.statusMessage ?? e.message ?? 'Network error while saving signature';
      print("SAVE SIGNATURE DIO EXCEPTION: $errMsg | response: ${e.response?.data}");
      return false;
    } catch (f) {
      isUploadingSignature.value = false;
      print("SAVE SIGNATURE EXCEPTION: $f");
      return false;
    }
  }
}
