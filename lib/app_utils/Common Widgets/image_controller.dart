import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:dio/dio.dart' as dio;
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class ImageController extends GetxController {
  final repo = getIt.get<ApiCall>();

  Future<List<String>> uploadMultiImageApi(BuildContext context, List<String> images, int insuranceType) async {
    List<String> imgUrl = [];
    for (var element in images) {
      String data = await uploadImageApi(context, element, insuranceType);
      if (data.isNotEmpty) {
        imgUrl.add(data);
      }
    }
    return imgUrl;
  }

  Future<String> uploadImageApi(BuildContext context, String images, int insuranceType) async {
    while (true) {
      try {
        Map<String, String> header = await getHeader();
        Map<String, dynamic> data = {
          'document': [
            await dio.MultipartFile.fromFile(images),
          ],
          'insurance_type': insuranceType,
        };

        Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).formDataRequest(
          context: context,
          endpoint: uploadDocument,
          body: data,
          options: Options(headers: header),
        );

        if (response[statusCode] == 200 || response[statusCode] == 201) {
          String data = response["data"]?["document"] ?? "";
          print("image url <<<< $data");
          if (data.isNotEmpty) {
            return data;
          }
        }
      } catch (e) {
        print("Document upload error: $e");
      }

      // If upload failed, show retry dialog
      if (!context.mounted) return "";
      bool shouldRetry = await _showRetryDialog(context) ?? false;
      if (!shouldRetry) {
        return "";
      }
    }
  }

  Future<bool?> _showRetryDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: redshad500, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(
                  text: uploadFailedTitle,
                  size: 16,
                  fontWeight: FontWeight.bold,
                  txtColor: deepBluedark,
                ),
              ),
            ],
          ),
          content: AppText(
            text: uploadFailedMessage,
            size: 13,
            txtColor: primaryBlack,
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: AppText(
                text: cancelTxt,
                txtColor: grayshad400,
                fontWeight: FontWeight.w600,
                size: 14,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: deepBluedark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: AppText(
                text: retryTxt,
                txtColor: primaryWhite,
                fontWeight: FontWeight.bold,
                size: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> removeUploadDocumentApi(BuildContext context, String documentUrl) async {
    if (documentUrl.isEmpty) {
      return 200;
    }
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
        context: context,
        endpoint: "$removeUploadDocument$documentUrl",
        options: Options(headers: header),
      );
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        return response[statusCode];
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)),
          );
        }
      }
    } on DioError catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AppText(text: e.response?.statusMessage ?? "Error removing document", txtColor: primaryWhite, size: 12)),
        );
      }
    } catch (f) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)),
        );
      }
    }
  }
}
