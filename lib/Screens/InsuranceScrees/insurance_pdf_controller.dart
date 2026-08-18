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
      );

      Map<String, dynamic> data = {
        'purchase_policy_id': purchasePolicyId ?? 0,
        'client_id': clientId ?? 0,
        'signature': multipartFile,
      };

      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(
        context: context,
        endpoint: saveSignatureUrl,
        body: data,
        options: Options(headers: header),
      );

      if (response[statusCode] == 200 || response[statusCode] == 201 || response['status'] == true) {
        final dataObj = response['data'];
        if (dataObj is Map && dataObj.containsKey('signature')) {
          signatureUrl.value = dataObj['signature'].toString();
        } else if (response.containsKey('signature')) {
          signatureUrl.value = response['signature'].toString();
        }
        signatureBytes.value = pngBytes;
        isSigned.value = true;
        isUploadingSignature.value = false;
        return true;
      } else {
        isUploadingSignature.value = false;
        String errMsg = response[messageKey]?.toString() ?? response['message']?.toString() ?? 'Failed to save signature';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AppText(text: errMsg, txtColor: primaryWhite, size: 12)),
        );
        return false;
      }
    } on DioException catch (e) {
      isUploadingSignature.value = false;
      String errMsg = e.response?.statusMessage ?? e.message ?? 'Network error while saving signature';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AppText(text: errMsg, txtColor: primaryWhite, size: 12)),
      );
      return false;
    } catch (f) {
      isUploadingSignature.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AppText(text: '$f', txtColor: primaryWhite, size: 12)),
      );
      return false;
    }
  }
}
