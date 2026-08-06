import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/get_complaint_list_model.dart';
import 'package:soperia_user/model_class/get_insurance_company_model.dart';
import 'package:soperia_user/model_class/get_insurance_type_model.dart';

class ComplaintController extends GetxController {
  final repo = getIt.get<ApiCall>();
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());
  RxBool isLoadingGetApi = false.obs;

  /// Complaint Screen
  Rx<GetComplaintListModel> getComplaintListModel = GetComplaintListModel().obs;

  getComplaintListApi(context) async {
    try {
      isLoadingGetApi.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getComplaintList, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getComplaintListModel.value = GetComplaintListModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: AppText(
          text: response[messageKey].toString(),
          txtColor: primaryWhite,
          size: 12,
        )));
      }
      isLoadingGetApi.value = false;
    } on DioError catch (e) {
      isLoadingGetApi.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: e.response!.statusMessage!,
        txtColor: primaryWhite,
        size: 12,
      )));
    } catch (f) {
      isLoadingGetApi.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: "$f",
        txtColor: primaryWhite,
        size: 12,
      )));
    }
  }

  /// Add Complaint Screen
  String? selectInsuranceCompany;
  RxBool isLoadingPostComplaint = false.obs;
  Rx<InsuranceTypes> selectedInsuranceType = InsuranceTypes().obs;
  RxList<InsuranceTypes> insuranceTypeList = <InsuranceTypes>[].obs;
  Rx<TextEditingController> complaintNoteController = TextEditingController().obs;
  RxBool isLoadingInsuranceCompany = false.obs;
  Rx<GetInsuranceCompanyModel> getInsuranceCompanyModel = GetInsuranceCompanyModel().obs;
  Rx<InsuranceCompany> selectedInsuranceCompany = InsuranceCompany().obs;
  RxList<InsuranceCompany> insuranceCompanyList = <InsuranceCompany>[].obs;

  apiMethod(context) async {
    await Future.delayed(const Duration(milliseconds: 100));
    isLoadingGetApi.value = true;
    await clearData();
    await getInsuranceType(context);
  }

  clearData()async{
    selectedInsuranceCompany.value =InsuranceCompany();
    complaintNoteController.value.clear();
    selectedInsuranceType.value= InsuranceTypes();
  }

  getInsuranceType(context) async {
    try {
      insuranceTypeList.clear();
      await adminBasicAllApiController.getInsuranceTypeApi(context);
      insuranceTypeList.addAll(adminBasicAllApiController.getInsuranceTypeModel.value.data ?? []);
      isLoadingGetApi.value = false;
    } on DioError catch (e) {
      isLoadingGetApi.value = false;
    } catch (f) {
      isLoadingGetApi.value = false;
    }
  }

  getInsuranceCompanyApi(context, int insuranceTypeId) async {
    try {
      isLoadingInsuranceCompany.value=true;
      insuranceCompanyList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: '$getInsuranceCompany$insuranceTypeId', options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getInsuranceCompanyModel.value = GetInsuranceCompanyModel.fromJson(response);
        insuranceCompanyList.addAll(getInsuranceCompanyModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingInsuranceCompany.value = false;
    } on DioError catch (e) {
      isLoadingInsuranceCompany.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingInsuranceCompany.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  addComplaintApi(context) async {
    isLoadingPostComplaint.value = true;
    Map<String, dynamic> data = {
      'insurance_company_id': selectedInsuranceCompany.value.insuranceCompanyId ?? 0,
      'complaint_message': complaintNoteController.value.text,
      'insurance_type': selectedInsuranceType.value.name ?? '',
      'purchase_id': selectedInsuranceCompany.value.id ?? 0,
    };

    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: addComplaint, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getComplaintListApi(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingPostComplaint.value = false;
    } on DioError catch (e) {
      isLoadingPostComplaint.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      print(f);
      isLoadingPostComplaint.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }
}
