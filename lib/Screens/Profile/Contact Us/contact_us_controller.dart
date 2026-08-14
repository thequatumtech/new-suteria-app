import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Services/chat_realtime_service.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/file_upload_gallary.dart';
import 'package:soperia_user/model_class/chat_model.dart';
import 'package:soperia_user/model_class/contact_us_list_model.dart';
import 'package:dio/dio.dart' as m;

class ContactUsController extends GetxController {
  final repo = getIt.get<ApiCall>();
  RxBool isLoadingSendClaimsMessage = false.obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;
  RxBool isLoadingChatsList = false.obs;

  RxnInt activeChatId = RxnInt();
  RxList<ChatMessageItem> chatMessagesList = <ChatMessageItem>[].obs;
  final Set<int> seenMessageIds = {};
  final ChatRealtimeService _realtimeService = ChatRealtimeService();

  Rx<ContactChatsListModel> contactChatsListModel = ContactChatsListModel().obs;
  RxList dateList = [].obs;
  File selectedFileDocuments = File("");
  Rx<ScrollController> listScrollController = ScrollController().obs;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void onClose() {
    _realtimeService.dispose();
    super.onClose();
  }

  apiMethod(context) async {
    isLoadingChatsList.value = true;
    await startAndLoadChat(context);
    isLoadingChatsList.value = false;
    await Future.delayed(const Duration(milliseconds: 300));
    scrollToBottom();
  }

  Future<void> startAndLoadChat(context) async {
    try {
      await startChatApi(context);
      if (activeChatId.value != null) {
        await getChatMessagesApi(context);
        await markChatAsReadApi(context);
      } else {
        await getContactChatsListApi(context);
      }
    } catch (e) {
      await getContactChatsListApi(context);
    }
  }

  Future<void> startChatApi(context, {int receiverId = 4, String receiverType = 'admin'}) async {
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequest(
        context: context,
        endpoint: chatStartURL,
        body: {'receiver_id': receiverId, 'receiver_type': receiverType},
        options: Options(headers: header),
      );
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        final chatData = response['chat'] ?? response['data'];
        if (chatData != null && chatData['id'] != null) {
          activeChatId.value = chatData['id'] is int ? chatData['id'] : int.tryParse(chatData['id'].toString());
        }
      }
    } catch (e) {
      print('startChatApi error: $e');
    }
  }

  Future<void> markChatAsReadApi(context) async {
    if (activeChatId.value == null) return;
    try {
      Map<String, String> header = await getHeader();
      await ApiCall(dioClient: repo.dioClient).postRequest(
        context: context,
        endpoint: markChatReadURL(activeChatId.value!),
        options: Options(headers: header),
      );
    } catch (e) {
      print('markChatAsReadApi error: $e');
    }
  }

  Future<void> getChatMessagesApi(context) async {
    if (activeChatId.value == null) {
      await getContactChatsListApi(context);
      return;
    }
    try {
      dateList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
        context: context,
        endpoint: getChatMessagesURL(activeChatId.value!),
        options: Options(headers: header),
      );
      if (response[statusCode] == 200 || response[statusCode] == 201 || response['data'] != null) {
        final List listData = response['data'] ?? [];
        final items = listData.map((e) => ChatMessageItem.fromJson(e)).toList();

        seenMessageIds.clear();
        for (var item in items) {
          seenMessageIds.add(item.id);
        }
        chatMessagesList.value = items;

        _realtimeService.init(activeChatId.value!);
        _realtimeService.seedExistingIds(seenMessageIds.toList());
        _realtimeService.listenForNewMessages((newMsg) {
          if (!seenMessageIds.contains(newMsg.id)) {
            seenMessageIds.add(newMsg.id);
            chatMessagesList.add(newMsg);
            scrollToBottom();
          }
        });
      } else {
        await getContactChatsListApi(context);
      }
    } catch (e) {
      print('getChatMessagesApi error: $e');
      await getContactChatsListApi(context);
    }
    scrollToBottom();
  }

  sendContactMessageApi(context) async {
    String textMsg = messageController.value.text.trim();
    bool hasFile = selectedFileDocuments.path.isNotEmpty;

    if (textMsg.isEmpty && !hasFile) return;

    isLoadingSendClaimsMessage.value = true;

    try {
      if (activeChatId.value == null) {
        await startChatApi(context);
      }

      Map<String, String> header = await getHeader();

      if (activeChatId.value != null) {
        Map<String, dynamic> bodyData = {
          'chat_id': activeChatId.value,
        };
        if (textMsg.isNotEmpty) {
          bodyData['message'] = textMsg;
        }
        if (hasFile) {
          bodyData['file'] = await m.MultipartFile.fromFile(selectedFileDocuments.path);
        }

        Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(
          context: context,
          endpoint: chatSendURL,
          body: bodyData,
          options: Options(headers: header),
        );

        if (response[statusCode] == 200 || response[statusCode] == 201 || response['status'] == true) {
          messageController.value.clear();
          selectedFileDocuments = File("");

          if (response['data'] != null) {
            final newMsg = ChatMessageItem.fromJson(response['data']);
            if (!seenMessageIds.contains(newMsg.id)) {
              seenMessageIds.add(newMsg.id);
              chatMessagesList.add(newMsg);
            }
          } else {
            await getChatMessagesApi(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey]?.toString() ?? 'Failed to send message', txtColor: primaryWhite, size: 12)));
        }
      } else {
        Map<String, dynamic> data = {
          'message': textMsg,
          'file': hasFile ? await m.MultipartFile.fromFile(selectedFileDocuments.path) : '',
        };
        Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: sendContactMessage, body: data, options: Options(headers: header));
        if (response[statusCode] == 200 || response[statusCode] == 201) {
          messageController.value.clear();
          selectedFileDocuments = File("");
          getContactChatsListApi(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
        }
      }
      isLoadingSendClaimsMessage.value = false;
    } on DioException catch (e) {
      isLoadingSendClaimsMessage.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response?.statusMessage ?? e.message ?? 'Error', txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingSendClaimsMessage.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
    scrollToBottom();
  }

  getContactChatsListApi(context) async {
    try {
      dateList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: contactChatsList, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        contactChatsListModel.value = ContactChatsListModel.fromJson(response);
      }
    } catch (f) {
      isLoadingChatsList.value = false;
    }
    scrollToBottom();
  }

  showPicker(context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: AppText(text: camera, size: 14, txtColor: primaryBlack),
              onTap: () async {
                Navigator.of(context).pop();
                selectedFileDocuments = (await selectImageFromCamera(context)) ?? selectedFileDocuments;
                if (selectedFileDocuments.path.isNotEmpty) {
                  sendContactMessageApi(context);
                }
              },
            )
          ]),
        );
      },
    );
  }

  scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listScrollController.value.hasClients) {
        final position = listScrollController.value.position.maxScrollExtent;
        listScrollController.value.animateTo(
          position,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> refreshList(BuildContext context) async {
    await startAndLoadChat(context);
  }

  // Section 7 WhatsApp-style Date & Time Formatters
  String formatDateLabel(String createdAt) {
    if (createdAt.isEmpty) return '';
    try {
      final msgDate = DateTime.parse(createdAt.replaceFirst(' ', 'T'));
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      bool isSameDay(DateTime a, DateTime b) =>
          a.year == b.year && a.month == b.month && a.day == b.day;

      if (isSameDay(msgDate, now)) return 'Today';
      if (isSameDay(msgDate, yesterday)) return 'Yesterday';

      return '${msgDate.day.toString().padLeft(2, '0')}/'
          '${msgDate.month.toString().padLeft(2, '0')}/'
          '${msgDate.year}';
    } catch (e) {
      return createdAt;
    }
  }

  String formatTimeLabel(String createdAt) {
    if (createdAt.isEmpty) return '';
    try {
      final d = DateTime.parse(createdAt.replaceFirst(' ', 'T'));
      final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final minute = d.minute.toString().padLeft(2, '0');
      final ampm = d.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $ampm';
    } catch (e) {
      return createdAt;
    }
  }
}
