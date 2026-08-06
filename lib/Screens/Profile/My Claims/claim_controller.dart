import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/get_policy_details_model.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/claims_chats_model.dart';
import 'package:soperia_user/model_class/get_claims_list_model.dart';
import 'package:dio/dio.dart' as m;

class ClaimController extends GetxController {
  final repo = getIt.get<ApiCall>();

  /// Review My Claim Status Screen
  RxBool isLoadingClaimsList = false.obs;
  Rx<GetClaimsListModel> getClaimsListModel = GetClaimsListModel().obs;

  getClaimsListApi(context) async {
    try {
      isLoadingClaimsList.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getClaimsList, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getClaimsListModel.value = GetClaimsListModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: AppText(
          text: response[messageKey].toString(),
          txtColor: primaryWhite,
          size: 12,
        )));
      }
      isLoadingClaimsList.value = false;
    } on DioError catch (e) {
      isLoadingClaimsList.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: e.response!.statusMessage!,
        txtColor: primaryWhite,
        size: 12,
      )));
    } catch (f) {
      isLoadingClaimsList.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: "$f",
        txtColor: primaryWhite,
        size: 12,
      )));
    }
  }

  /// My Claims Screen
  RxBool isLoadingPolicyDetails = false.obs;
  Rx<GetPolicyDetailsModel> getPolicyDetailsModel = GetPolicyDetailsModel().obs;

  getPolicyDetailsApi(context) async {
    try {
      isLoadingPolicyDetails.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getPolicyDetails, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getPolicyDetailsModel.value = GetPolicyDetailsModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingPolicyDetails.value = false;
    } on DioError catch (e) {
      isLoadingPolicyDetails.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingPolicyDetails.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  /// Add New Claim Screen And Edit Screen
  RxInt maxLength = 300.obs;
  Rx<TextEditingController> claimNoteController = TextEditingController().obs;
  final picker = ImagePicker();
  List<File> selectedPropertyContract = [];
  List selectedDocumentsList = [];
  RxBool isLoadingAddClaim = false.obs;

  clearData(bool isEdit, ClaimsListData? editData) async {
    selectedPropertyContract.clear();
    claimNoteController.value.clear();

    if (isEdit) {
      setData(editData!);
    }
  }

  setData(ClaimsListData editData) async {
    claimNoteController.value.text = editData.claimNote ?? '';
  }

  addClaimsApi(context, PolicyData policyData) async {
    isLoadingAddClaim.value = true;
    selectedDocumentsList.clear();
    for (int i = 0; i < selectedPropertyContract.length; i++) {
      selectedDocumentsList.add(await m.MultipartFile.fromFile(selectedPropertyContract[i].path));
    }

    Map<String, dynamic> data = {
      'policy_id': policyData.policyId ?? 0,
      'insurance_company_id': policyData.insuranceCompanyId ?? 0,
      'policy_type_name': policyData.policyType ?? '',
      'policy_type': policyData.policyTypeNo ?? 0,
      'effective_date': policyData.inceptionDate ?? '',
      'expiry_date': policyData.expiryDate ?? '',
      'claim_note': claimNoteController.value.text,
      'attachments': [selectedDocumentsList],
    };

    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: addClaims, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getClaimsListApi(context);
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingAddClaim.value = false;
    } on DioError catch (e) {
      isLoadingAddClaim.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      print(f);
      isLoadingAddClaim.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  editClaimsApi(context, ClaimsListData editPolicyData) async {
    isLoadingAddClaim.value = true;
    selectedDocumentsList.clear();
    for (int i = 0; i < selectedPropertyContract.length; i++) {
      selectedDocumentsList.add(await m.MultipartFile.fromFile(selectedPropertyContract[i].path));
    }

    Map<String, dynamic> data = {
      'policy_id': editPolicyData.policyId ?? 0,
      'insurance_company_id': editPolicyData.insuranceCompanyId ?? 0,
      'policy_type_name': editPolicyData.policyType ?? '',
      'policy_type': editPolicyData.claimNo ?? 0,
      'effective_date': editPolicyData.effectiveDate ?? '',
      'expiry_date': editPolicyData.expiryDate ?? '',
      'claim_note': claimNoteController.value.text,
      'attachments': [selectedDocumentsList],
      'id': editPolicyData.id ?? 0,
    };

    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: editClaims, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getClaimsListApi(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingAddClaim.value = false;
    } on DioError catch (e) {
      isLoadingAddClaim.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      print(f);
      isLoadingAddClaim.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  /// Message Screen
  RxBool isLoadingSendClaimsMessage = false.obs;
  Rx<TextEditingController> claimMessageController = TextEditingController().obs;
  RxBool isLoadingClaimsChatsList = false.obs;
  Rx<ClaimsChatSModel> claimsChatSModel = ClaimsChatSModel().obs;
  RxList dateList = [].obs;
  Rx<ScrollController> listScrollController = ScrollController().obs;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  apiCallMethod(context, int claimId) async {
    isLoadingClaimsChatsList.value = true;
    await getClaimsChatsListApi(context, claimId);
    isLoadingClaimsChatsList.value = false;
    await Future.delayed(const Duration(seconds: 1));
    scrollToBottom();
  }

  sendClaimsMessageApi(context, ClaimsListData claimsData) async {
    isLoadingSendClaimsMessage.value = true;
    Map<String, dynamic> data = {
      'claim_id': claimsData.id ?? 0,
      'message': claimMessageController.value.text,
    };

    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: sendClaimsMessage, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        claimMessageController.value.clear();
        getClaimsChatsListApi(context, claimsData.id ?? 0);
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

  getClaimsChatsListApi(context, int claimId) async {
    try {
      dateList.clear();
      // isLoadingClaimsChatsList.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: '$claimsChatsList$claimId', options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        claimsChatSModel.value = ClaimsChatSModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      // isLoadingClaimsChatsList.value = false;
    } on DioError catch (e) {
      // isLoadingClaimsChatsList.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      // isLoadingClaimsChatsList.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
    scrollToBottom();
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

  Future<void> refreshList(BuildContext context, int claimId) async {
    getClaimsChatsListApi(context, claimId);
    await Future.delayed(const Duration(seconds: 2));
  }
}
