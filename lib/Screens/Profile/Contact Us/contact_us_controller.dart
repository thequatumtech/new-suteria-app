import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/file_upload_gallary.dart';
import 'package:soperia_user/model_class/contact_us_list_model.dart';
import 'package:dio/dio.dart' as m;

class ContactUsController extends GetxController {
  final repo = getIt.get<ApiCall>();
  RxBool isLoadingSendClaimsMessage = false.obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;
  RxBool isLoadingChatsList = false.obs;
  Rx<ContactChatsListModel> contactChatsListModel = ContactChatsListModel().obs;
  RxList dateList = [].obs;
  File selectedFileDocuments = File("");
  Rx<ScrollController> listScrollController = ScrollController().obs;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  apiMethod(context) async {
    isLoadingChatsList.value = true;
    await getContactChatsListApi(context);
    isLoadingChatsList.value = false;
    await Future.delayed(const Duration(seconds: 1));
    scrollToBottom();
  }

  sendContactMessageApi(context) async {
    isLoadingSendClaimsMessage.value = true;
    Map<String, dynamic> data = {
      'message': messageController.value.text,
      'file': selectedFileDocuments.path.isNotEmpty ? await m.MultipartFile.fromFile(selectedFileDocuments.path) : '',
    };
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: sendContactMessage, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        messageController.value.clear();
        selectedFileDocuments = File("");
        getContactChatsListApi(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingSendClaimsMessage.value = false;
    } on DioError catch (e) {
      isLoadingSendClaimsMessage.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      print(f);
      isLoadingSendClaimsMessage.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getContactChatsListApi(context) async {
    try {
      dateList.clear();

      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: contactChatsList, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        contactChatsListModel.value = ContactChatsListModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
    } on DioError catch (e) {
      isLoadingChatsList.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingChatsList.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
    scrollToBottom();
  }

  showPicker(context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: SizedBox(
                  child: Wrap(children: <Widget>[
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: AppText(text: photoLibrary, size: 14, txtColor: primaryBlack),
                onTap: () async {
                  Navigator.of(context).pop();
                  selectedFileDocuments = (await selectImageFromGallery(context)) ?? selectedFileDocuments;
                  if (selectedFileDocuments.path.isNotEmpty) {
                    sendContactMessageApi(context);
                  }
                }),
            ListTile(
                leading: const Icon(Icons.photo_camera),
                title: AppText(text: camera, size: 14, txtColor: primaryBlack),
                onTap: () async {
                  Navigator.of(context).pop();
                  selectedFileDocuments = (await selectImageFromCamera(context)) ?? selectedFileDocuments;
                  if (selectedFileDocuments.path.isNotEmpty) {
                    sendContactMessageApi(context);
                  }
                })
          ])));
        });
  }

  scrollToBottom() {
    if (listScrollController.value.hasClients) {
      final position = listScrollController.value.position.maxScrollExtent;
      listScrollController.value.animateTo(
        position,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> refreshList(BuildContext context) async {
    getContactChatsListApi(context);
    await Future.delayed(const Duration(seconds: 2));
  }
}
