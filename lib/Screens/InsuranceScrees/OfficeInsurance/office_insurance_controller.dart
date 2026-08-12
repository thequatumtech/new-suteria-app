import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_protection_system_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';
import 'package:soperia_user/model_class/office_insurance_plan_model.dart';

import '../../../model_class/get_country_model.dart';

class OfficeInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> companyRegisterNationalIdNoController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> companyRegisterNoController = TextEditingController().obs;
  Rx<TextEditingController> officeSizeController = TextEditingController().obs;
  Rx<TextEditingController> blockNoController = TextEditingController().obs;
  Rx<TextEditingController> plateNoController = TextEditingController().obs;
  Rx<TextEditingController> plotNoController = TextEditingController().obs;
  Rx<TextEditingController> effectiveDateController = TextEditingController().obs;
  Rx<TextEditingController> effectiveExpiryDateController = TextEditingController().obs;
  Rx<TextEditingController> inceptionDateController = TextEditingController().obs;
  Rx<TextEditingController> inceptionExpiryDate1Controller = TextEditingController().obs;
  Rx<TextEditingController> streetNameController = TextEditingController().obs;
  Rx<TextEditingController> buildingNoController = TextEditingController().obs;
  Rx<TextEditingController> officeNoController = TextEditingController().obs;
  Rx<TextEditingController> companyTelephoneNoController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerTelephoneNoController = TextEditingController().obs;
  Rx<TextEditingController> authorizedPositionController = TextEditingController().obs;
  Rx<TextEditingController> previousInsurancePolicyController = TextEditingController().obs;
  Rx<TextEditingController> companyDeclinedIssueController = TextEditingController().obs;
  Rx<TextEditingController> claimsAndAccidentsController = TextEditingController().obs;
  String? selectedgender;
  String? selectofficetype;
  String? selectNoOfFloor;
  String? selectedroomsItem;
  String? selectAgeOfBuilding;
  String? selectedOfficeCategory;
  String? selectNoOfEmployee;
  String selectedPartnerInTheCompany = noTxt;
  String selectedAuthorizedToIssue = noTxt;
  String selectedAuthorizedIsStated = noTxt;
  String selectedPreviousInsurancePolicy = noTxt;
  String selectedOfficeInsurancePolicyBefore = noTxt;
  String selectedClaimsAndAccidentsYears = noTxt;
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());
  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;
  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;
  Rx<GetCountryList> selectCountry = GetCountryList().obs;
  RxList<GetCountryList> countryList = <GetCountryList>[].obs;
  Rx<ProtectionSystemList> selectProtectionSystem = ProtectionSystemList().obs;
  RxList<ProtectionSystemList> protectionSystemList = <ProtectionSystemList>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingOfficeInsurancePlan = false.obs;
  RxBool isLoadingInsuranceLimit = false.obs;
  List<String> genderList = [];
  Rx<GetCountryList> selectPlaceResidence = GetCountryList().obs;
  RxList<GetCountryList> placeResidenceList = <GetCountryList>[].obs;

  RxBool isLoadingSelectedDocument = false.obs;
  RxBool isLoadingRentDocument = false.obs;
  RxBool isLoadingPropertyDocument = false.obs;
  RxBool isLoadingContentsDocument = false.obs;
  RxBool isLoadingAuthorizationDocument = false.obs;
  RxBool isLoadingRegistrationDocument = false.obs;
  RxBool isLoadingLicenseDocument = false.obs;
  RxBool isLoadingOwnersIdDocument = false.obs;
  RxBool isLoadingPracticeCertificateDocument = false.obs;
  RxBool isLoadingCompanyTaxCertificateDocument = false.obs;
  final picker = ImagePicker();
  RxList<String> selectedDocument = <String>[].obs;
  RxList<String> selectedRentDocument = <String>[].obs;
  RxList<String> selectedPropertyDocument = <String>[].obs;
  RxList<String> selectedContentsDocument = <String>[].obs;
  RxList<String> selectedAuthorizationDocument = <String>[].obs;
  RxList<String> selectedRegistrationDocument = <String>[].obs;
  RxList<String> selectedLicenseDocument = <String>[].obs;
  RxList<String> selectedOwnersIdDocument = <String>[].obs;
  RxList<String> selectedPracticeCertificateDocument = <String>[].obs;
  RxList<String> selectedCompanyTaxCertificateDocument = <String>[].obs;

  List<DropdownItem<int>> selectProtectionSystemList = [];
  List<DropdownItem<int>> protectionSystemListDrop = [];
  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;
  final repo = getIt.get<ApiCall>();
  Rx<OfficeInsurancePlanModel> officeInsurancePlanModel = OfficeInsurancePlanModel().obs;
  Rx<PlanName> selectedInsurancePlan = PlanName().obs;
  RxList<PlanName> insurancePlanList = <PlanName>[].obs;
  String planDd = '';
  String insuranceLimit = '';
  RxList<String> employeeNumber = [''].obs;
  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;
  Rx<GetNationalityList> selectNationality = GetNationalityList().obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  void init(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    /*await getDistrictMethod(context);
    await getCityMethod(context);*/
    await getNationality(context);
    await getCountryMethod(context);
    await getProtectionSystemMethod(context);
    await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 2);
      getInsuranceCurrentModel.value = adminBasicAllApiController.getInsuranceCurrentModel.value;
    } on DioError catch (e) {
      print(e);
    } catch (f) {
      print(f);
    }
  }

  clearData() async {
    policyHolderFirstNameController.value.clear();
    policyHolderSecondNameController.value.clear();
    policyHolderThirdNameController.value.clear();
    policyHolderFamilyNameController.value.clear();
    nationPassportNoController.value.clear();
    idOrResidenceNoController.value.clear();
    companyOwnerSecondNameController.value.clear();
    companyOwnerThirdNameController.value.clear();
    companyOwnerFamilyNameController.value.clear();
    birthDateController.value.clear();
    selectedgender = null;
    selectPlaceResidence.value = GetCountryList();
    selectNationality.value = GetNationalityList();
    companyNameController.value.clear();
    companyRegisterNationalIdNoController.value.clear();
    companyRegisterNoController.value.clear();
    selectofficetype = null;
    selectNoOfFloor = null;
    selectedroomsItem = null;
    officeSizeController.value.clear();
    selectAgeOfBuilding = null;
    idOrResidenceNoController.value.clear();
    selectedOfficeCategory = null;
    blockNoController.value.clear();
    plateNoController.value.clear();
    plotNoController.value.clear();
    effectiveDateController.value.clear();
    effectiveExpiryDateController.value.clear();
    selectNoOfEmployee = null;
    selectCountry.value = GetCountryList();
    selectCity.value = CityListModel();
    selectDistrict.value = DistrictList();
    streetNameController.value.clear();
    buildingNoController.value.clear();
    officeNoController.value.clear();
    companyTelephoneNoController.value.clear();
    companyOwnerFirstNameController.value.clear();
    companyOwnerTelephoneNoController.value.clear();
    selectedPartnerInTheCompany = noTxt;
    selectedAuthorizedToIssue = noTxt;
    selectedPreviousInsurancePolicy = noTxt;
    selectedAuthorizedIsStated = noTxt;
    selectedOfficeInsurancePolicyBefore = noTxt;
    selectedClaimsAndAccidentsYears = noTxt;
    selectProtectionSystemList.clear();
    selectedInsuranceLimit.value = InsuranceLimitListData();
    selectedInsurancePlan.value = PlanName();
    inceptionDateController.value.clear();
    inceptionExpiryDate1Controller.value.clear();
    planDd = '';
    selectedRentDocument.clear();
    selectedPropertyDocument.clear();
    selectedContentsDocument.clear();
    selectedAuthorizationDocument.clear();
    selectedRegistrationDocument.clear();
    selectedLicenseDocument.clear();
    selectedOwnersIdDocument.clear();
    selectedPracticeCertificateDocument.clear();
    selectedCompanyTaxCertificateDocument.clear();
    selectedDocument.clear();
  }

  setTextData() {
    employeeNumber.clear();
    for (int i = 1; i <= 100; i++) {
      employeeNumber.add(i.toString());
    }

    policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";
    nationPassportNoController.value.text = getProfileModelGlobal.data?.nationalIdNumber.toString() ?? "";
    idOrResidenceNoController.value.text = getProfileModelGlobal.data?.residenceIdNumber.toString() ?? "";
    birthDateController.value.text = commonDateFormat(getProfileModelGlobal.data?.birthDate.toString() ?? "");
    // positionController.value.text = getProfileModelGlobal.data?.??"";

    genderList.clear();
    genderList.add(getProfileModelGlobal.data?.gender.toString() == "1" ? male : female ?? '');
    selectedgender = genderList.first;

    try {
      CityListModel city = cityList.firstWhere((element) => element.id == getProfileModelGlobal.data?.cityId);
      // selectCity.value = city;
    } catch (e) {
      print(e);
    }

    try {
      DistrictList district = districtList.firstWhere((element) => element.id == getProfileModelGlobal.data?.districtId);
      // selectDistrict.value = district;
    } catch (e) {
      print(e);
    }
    try {
      placeResidenceList.contains((element) => element.id != getProfileModelGlobal.data?.residingCountryId);
      selectPlaceResidence.value = placeResidenceList[placeResidenceList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.residingCountryId)];
    } catch (e) {
      print(e);
    }

    try {
      nationalityList.isEmpty ? '' : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
      selectNationality.value = nationalityList.first;
    } catch (e) {}

   /* if (getInsuranceCurrentModel.value.data != null) {
      if (getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        initialDate.value = initialDate.value.add(const Duration(days: 1));
      } else {
        initialDate.value = DateTime.now();
      }
    } else {
      initialDate.value = DateTime.now();
    }*/

    /// Effective Date
    effectiveDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
    effectiveExpiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(initialDate.value)).add(const Duration(days: 364)).toString())));

    /// Inception Date

    inceptionDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
    inceptionExpiryDate1Controller.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(initialDate.value)).add(const Duration(days: 364)).toString())));
  }

  getInsuranceLimit(context, String id) async {
    try {
      isLoadingInsuranceLimit.value = true;
      insuranceLimitList.clear();
      selectedInsuranceLimit = InsuranceLimitListData().obs;


      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$insuranceLimitUrl$id", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        insuranceLimitModel.value = InsuranceLimitModel.fromJson(response);
        insuranceLimitList.addAll(insuranceLimitModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingInsuranceLimit.value = false;
    } on DioError catch (e) {
      isLoadingInsuranceLimit.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingInsuranceLimit.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getCityMethod(context,String cityID) async {
    try {
      cityList.clear();
      await adminBasicAllApiController.getCityApi(context,city:cityID );
      cityList.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getNationality(context) async {
    try {
      nationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getDistrictMethod(context,String id) async {
    try {
      districtList.clear();
      await adminBasicAllApiController.getDistrictApi(context,id: id);
      districtList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getCountryMethod(context) async {
    try {
      placeResidenceList.clear();
      countryList.clear();
      await adminBasicAllApiController.getCountryApi(context);
      countryList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      placeResidenceList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getProtectionSystemMethod(context) async {
    try {
      protectionSystemList.clear();
      await adminBasicAllApiController.getProtectionSystemApi(context);
      protectionSystemList.addAll(adminBasicAllApiController.getProtectionSystemModelClass.value.data ?? []);

      for (int i = 0; i < protectionSystemList.length; i++) {
        protectionSystemListDrop.add(DropdownItem(label: protectionSystemList[i].name ?? '', value: protectionSystemList[i].id ?? 0));
      }
    } on DioError catch (e) {
    } catch (f) {}
  }

  getHomeInsurancePlanApi(context, String planName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoadingOfficeInsurancePlan.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getOfficeInsurancePlan$planName", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        officeInsurancePlanModel.value = OfficeInsurancePlanModel.fromJson(response);
        if (officeInsurancePlanModel.value.data == null || officeInsurancePlanModel.value.data!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: noInsurancePlanFound, txtColor: primaryWhite, size: 12)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingOfficeInsurancePlan.value = false;
    } on DioError catch (e) {
      isLoadingOfficeInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingOfficeInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }
}
