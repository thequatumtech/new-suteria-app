import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class PetInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> ownerBirthDateController = TextEditingController().obs;

  Rx<TextEditingController> petNameController = TextEditingController().obs;
  Rx<TextEditingController> petBirthDateController = TextEditingController().obs;
  Rx<TextEditingController> petBreedNameController = TextEditingController().obs;
  Rx<TextEditingController> inceptionDateController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;
  Rx<TextEditingController> preExistingController = TextEditingController().obs;
  String? selectGender;
  String? selectBreed;

  String selectedPreExistingConditions = noTxt;
  RxBool isLoading = false.obs;
  RxBool isLoadingPetsInsurancePlan = false.obs;
  RxBool isDog = true.obs;

  RxBool isLoadingVaccineDocuments = false.obs;
  RxBool isLoadingPetsImgDocuments = false.obs;
  RxBool isLoadingPetsPassportDocuments = false.obs;
  RxBool isLoadingPetsPermitDocuments = false.obs;

  final picker = ImagePicker();

  RxList<String> selectedVaccineDocuments = <String>[].obs;
  RxList<String> selectedPetsImgDocuments = <String>[].obs;
  RxList<String> selectedPetsPassportDocuments = <String>[].obs;
  RxList<String> selectedPetsPermitDocuments = <String>[].obs;

  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;
  final repo = getIt.get<ApiCall>();
  String planDd = '';
  String insuranceLimit = '';
  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  RxList<PlanName> insurancePlanList = <PlanName>[].obs;

  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;
  Rx<PlanName> selectedInsurancePlan = PlanName().obs;

  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;
  setTextData() {
    isLoading.value = true;
    policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";
    nationPassportNoController.value.text = getProfileModelGlobal.data?.nationalIdNumber.toString() ?? "";
    idOrResidenceNoController.value.text = getProfileModelGlobal.data?.residenceIdNumber.toString() ?? "";
    ownerBirthDateController.value.text = commonDateFormat(getProfileModelGlobal.data?.birthDate.toString() ?? "");
    isLoading.value = false;
  }

  clearData() async {
    isDog.value = true;
    policyHolderFirstNameController.value.clear();
    policyHolderSecondNameController.value.clear();
    policyHolderThirdNameController.value.clear();
    policyHolderFamilyNameController.value.clear();
    nationPassportNoController.value.clear();
    idOrResidenceNoController.value.clear();
    ownerBirthDateController.value.clear();
    petNameController.value.clear();
    petBirthDateController.value.clear();
    selectGender = null;
    selectBreed = null;
    petBreedNameController.value.clear();
    selectedPreExistingConditions = noTxt;
    preExistingController.value.clear();
    selectedInsuranceLimit.value = InsuranceLimitListData();
    inceptionDateController.value.clear();
    expiryDateController.value.clear();
    planDd = '';
    selectedVaccineDocuments.clear();
    selectedPetsImgDocuments.clear();
    selectedPetsPassportDocuments.clear();
    selectedPetsPermitDocuments.clear();
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
  }

  apiMethod(BuildContext context)async{
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await getInsuranceLimit(context, '8');
    isLoading.value = false;

  }

  getInsuranceLimit(context, String id) async {
    try {
/*      if (getInsuranceCurrentModel.value.data != null) {
        if (getInsuranceCurrentModel.value.data!.expiryDate != null ) {
          initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
          initialDate.value = initialDate.value.add(const Duration(days: 1));
        } else {
          initialDate.value = DateTime.now();
        }
      } else {
        initialDate.value = DateTime.now();
      }*/
      inceptionDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
      updateExpireDate(initialDate.value);

      insuranceLimitList.clear();
      insurancePlanList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$insuranceLimitUrl$id", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        insuranceLimitModel.value = InsuranceLimitModel.fromJson(response);
        insuranceLimitList.addAll(insuranceLimitModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getPetsInsurancePlanApi(context, String planName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoadingPetsInsurancePlan.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getPetsInsurancePlan$planName", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        homeInsurancePlaneModel.value = HomeInsurancePlaneModel.fromJson(response);
        if (homeInsurancePlaneModel.value.data == null || homeInsurancePlaneModel.value.data!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: noInsurancePlanFound, txtColor: primaryWhite, size: 12)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingPetsInsurancePlan.value = false;
    } on DioError catch (e) {
      isLoadingPetsInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingPetsInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 8);
      getInsuranceCurrentModel.value = adminBasicAllApiController.getInsuranceCurrentModel.value;
    } on DioError catch (e) {
      print(e);
    } catch (f) {
      print(f);
    }
  }

  void updateExpireDate([DateTime? customInceptionDate]) {
    int days = selectedInsurancePlan.value.policyPeriod ?? 364;
    DateTime baseDate = customInceptionDate ?? initialDate.value;
    if (customInceptionDate == null && inceptionDateController.value.text.isNotEmpty) {
      try {
        baseDate = DateFormat("yyyy-MM-dd").parse(commonApiDateFormat(inceptionDateController.value.text));
      } catch (_) {}
    }
    expiryDateController.value.text = commonDateFormat(
      DateFormat("yyyy-MM-dd").format(baseDate.add(Duration(days: days))),
    );
  }
}
