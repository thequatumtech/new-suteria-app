import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_in_patient_deductible_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_number_of_visit_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/get_out_patient_deductible_model.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class IndividualMedicalInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> streetNameController = TextEditingController().obs;
  Rx<TextEditingController> buildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> companyStreetNameController = TextEditingController().obs;
  Rx<TextEditingController> companyBuildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyContactNoController = TextEditingController().obs;
  Rx<TextEditingController> positionController = TextEditingController().obs;
  Rx<TextEditingController> heightController = TextEditingController().obs;
  Rx<TextEditingController> weightController = TextEditingController().obs;
  Rx<TextEditingController> workNatureController = TextEditingController().obs;
  Rx<TextEditingController> existingMedicalInsurancePolicyExpiryDateController = TextEditingController().obs;
  Rx<TextEditingController> inceptionDateController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;
  Rx<TextEditingController> insuranceCompanyNameController = TextEditingController().obs;
  Rx<TextEditingController> detailsAboutPreviousOperationsController = TextEditingController().obs;

  String? selectedGender;
  String? selectclass;
  String? insurancetypes;
  String? selectedMaritalStatus;
  String? selectedExistingMedicalInsurancePolicyOption;
  String? selectedChronicDisease;
  String? selectedPreviousOperationsOption;
  String? selectedPregnantOption;
  String? selectDangerousActivity;
  String? selectmonth;

  RxList<GetChronicDiseasesList> getChronicDiseasesList = <GetChronicDiseasesList>[].obs;

  /*Rx<GetChronicDiseasesList> selectChronicDiseases = GetChronicDiseasesList().obs;//remove this*/
  RxList<GetChronicDiseasesList> selectedChronicDiseasesList = <GetChronicDiseasesList>[].obs;

  /// add thiss

  RxList<GetDangerousActivitiesList> getDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;

  /* Rx<GetDangerousActivitiesList> selectDangerousActivitiesList = GetDangerousActivitiesList().obs;*/
  RxList<GetDangerousActivitiesList> selectDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;

  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());
  RxList<GetInPatientList> getInPatientList = <GetInPatientList>[].obs;
  Rx<GetInPatientList> selectInPatient = GetInPatientList().obs;
  RxList<GetOutPatientList> getOutPatientList = <GetOutPatientList>[].obs;
  Rx<GetOutPatientList> selectOutPatient = GetOutPatientList().obs;
  RxList<GetNoOfVisitsList> getNoOfVisitsList = <GetNoOfVisitsList>[].obs;
  Rx<GetNoOfVisitsList> selectNoOfVisits = GetNoOfVisitsList().obs;

  List<String> genderList = [];
  List<String> maritalStatusList = [];

  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;

  Rx<CityListModel> selectCompanyCity = CityListModel().obs;
  RxList<CityListModel> companyCityList = <CityListModel>[].obs;

  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;

  Rx<DistrictList> selectCompanyDistrict = DistrictList().obs;
  RxList<DistrictList> companyDistrictList = <DistrictList>[].obs;
  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;

  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;
  Rx<GetNationalityList> selectNationality = GetNationalityList().obs;

  RxBool isLoadingMedicalCard = false.obs;
  RxBool isLoadingIdFrontSide = false.obs;
  RxBool isLoadingIdBackSide = false.obs;
  RxBool isLoadingFamilyBook = false.obs;
  RxBool isLoadingPersonalPic = false.obs;
  RxBool isLoadingOtherMembers = false.obs;

  final picker = ImagePicker();
  RxList<String> selectedMedicalCard = <String>[].obs;
  RxList<String> selectedIdFrontSide = <String>[].obs;
  RxList<String> selectedIdBackSide = <String>[].obs;
  RxList<String> selectedFamilyBook = <String>[].obs;
  RxList<String> selectedPersonalPic = <String>[].obs;
  RxList<String> selectedOtherMembers = <String>[].obs;

  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingInsuranceLimit = false.obs;
  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;
  RxBool isLoadingInsurancePlan = false.obs;
  String? planDd;
  String insuranceLimit = '';
  final repo = getIt.get<ApiCall>();
  RxBool isShowHWValidationMsg = false.obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  init(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await getCityMethod(context);
    await getDistrictMethod(context);
    await getOccupations(context);
    await getChronicDiseases(context);
    await getDangerousActivities(context);
    await getNationality(context);
    await getInPatientDeductible(context);
    await getOutPatientDeductible(context);
    await getNoOfVisits(context);
    await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 6);
      getInsuranceCurrentModel.value = adminBasicAllApiController.getInsuranceCurrentModel.value;
    } on DioError catch (e) {
      print(e);
    } catch (f) {
      print(f);
    }
  }

  clearData() {
    policyHolderFirstNameController.value.clear();
    policyHolderSecondNameController.value.clear();
    policyHolderThirdNameController.value.clear();
    policyHolderFamilyNameController.value.clear();
    selectNationality.value = GetNationalityList();
    nationPassportNoController.value.clear();
    idOrResidenceNoController.value.clear();
    birthDateController.value.clear();
    selectedGender = null;
    selectedMaritalStatus = null;
    selectOccupation.value = OccuptionList();
    selectCity.value = CityListModel();
    selectDistrict.value = DistrictList();
    streetNameController.value.clear();
    buildingNoController.value.clear();
    companyNameController.value.clear();
    positionController.value.clear();
    workNatureController.value.clear();
    selectCompanyCity.value = CityListModel();
    selectCompanyDistrict.value = DistrictList();
    companyStreetNameController.value.clear();
    companyBuildingNoController.value.clear();
    companyContactNoController.value.clear();
    selectedExistingMedicalInsurancePolicyOption = null;
    insuranceCompanyNameController.value.clear();
    existingMedicalInsurancePolicyExpiryDateController.value.clear();
    selectedMedicalCard.clear();
    heightController.value.clear();
    weightController.value.clear();
    selectedChronicDiseasesList.value = [];
    selectedPreviousOperationsOption = null;
    detailsAboutPreviousOperationsController.value.clear();
    selectedPregnantOption = null;
    selectmonth = null;
    selectDangerousActivity = null;
    selectDangerousActivitiesList.value = [];
    selectedIdFrontSide.clear();
    selectedIdBackSide.clear();
    selectedFamilyBook.clear();
    selectedPersonalPic.clear();
    selectedOtherMembers.clear();
    inceptionDateController.value.clear();
    expiryDateController.value.clear();
    insurancetypes = null;
    selectclass = null;
    selectInPatient.value = GetInPatientList();
    selectOutPatient.value = GetOutPatientList();
    selectNoOfVisits.value = GetNoOfVisitsList();
    selectedInsuranceLimit.value = InsuranceLimitListData();
    planDd = null;
  }

  setTextData() {
    policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";
    nationPassportNoController.value.text = getProfileModelGlobal.data?.nationalIdNumber.toString() ?? "";
    idOrResidenceNoController.value.text = getProfileModelGlobal.data?.residenceIdNumber.toString() ?? "";
    birthDateController.value.text = commonDateFormat(getProfileModelGlobal.data?.birthDate.toString() ?? "");
    streetNameController.value.text = getProfileModelGlobal.data?.streetName ?? "";
    buildingNoController.value.text = getProfileModelGlobal.data?.buildingNo ?? "";
    companyNameController.value.text = getProfileModelGlobal.data?.companyName ?? "";
    positionController.value.text = getProfileModelGlobal.data?.position ?? "";
    workNatureController.value.text = getProfileModelGlobal.data?.workNature ?? "";
    companyStreetNameController.value.text = getProfileModelGlobal.data?.companyStreetName ?? "";
    companyBuildingNoController.value.text = getProfileModelGlobal.data?.companyBuildingNo ?? "";
    companyContactNoController.value.text = getProfileModelGlobal.data?.companyContactNo ?? "";

    genderList.clear();
    genderList.add(getProfileModelGlobal.data?.gender.toString() == "1" ? male : female ?? '');
    selectedGender = genderList.first;

    maritalStatusList.clear();
    selectedMaritalStatus = getProfileModelGlobal.data?.maritalStatus.toString() == "1"
        ? single
        : getProfileModelGlobal.data?.maritalStatus.toString() == "2"
            ? married
            : getProfileModelGlobal.data?.maritalStatus.toString() == "3"
                ? divorced
                : widowed;
    maritalStatusList.add(getProfileModelGlobal.data?.maritalStatus.toString() == "1"
        ? single
        : getProfileModelGlobal.data?.maritalStatus.toString() == "2"
            ? married
            : getProfileModelGlobal.data?.maritalStatus.toString() == "3"
                ? divorced
                : widowed);

    try {
      occupationList.removeWhere((element) => element.id != getProfileModelGlobal.data?.occupationId);
      selectOccupation.value = occupationList[occupationList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.occupationId)];
    } catch (e) {}

    if (cityList.isNotEmpty) {
      try {
        cityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.cityId);
        selectCity.value = cityList.first;
      } catch (e) {
        print(e);
      }
    }

    if (companyCityList.isNotEmpty) {
      try {
        companyCityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyCityId);
        selectCompanyCity.value = companyCityList.first;
      } catch (e) {
        print(e);
      }
    }

    if (districtList.isNotEmpty) {
      try {
        districtList.removeWhere((element) => element.id != getProfileModelGlobal.data?.districtId);
        selectDistrict.value = districtList.first;
      } catch (e) {
        print(e);
      }
    }
    if (companyDistrictList.isNotEmpty) {
      try {
        companyDistrictList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyDistrictId);
        selectCompanyDistrict.value = companyDistrictList.first;
      } catch (e) {
        print(e);
      }
      /* try {
      CityListModel city = cityList.firstWhere((element) => element.id == getProfileModelGlobal.data?.cityId);
      selectCity.value = city;
    } catch (e) {
      print(e);
    }

    try {
      DistrictList district = districtList.firstWhere((element) => element.id == getProfileModelGlobal.data?.districtId);
      selectDistrict.value = district;
    } catch (e) {
      print(e);
    }

    }*/

      try {
        nationalityList.isEmpty ? '' : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
        selectNationality.value = nationalityList.first;
      } catch (e) {}
    }

    /*  if (getInsuranceCurrentModel.value.data != null) {
      if (getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        existingMedicalInsurancePolicyExpiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
        initialDate.value = initialDate.value.add(const Duration(days: 1));
      } else {
        initialDate.value = DateTime.now();
      }
    } else {
      initialDate.value = DateTime.now();
    }*/

    inceptionDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
    expiryDateController.value.text =
        commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(initialDate.value)).add(const Duration(days: 364)).toString())));
  }

  getOccupations(context) async {
    try {
      occupationList.clear();
      await adminBasicAllApiController.getOccupationApi(context);
      occupationList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getChronicDiseases(context) async {
    try {
      getChronicDiseasesList.clear();
      await adminBasicAllApiController.getChronicDiseaseApi(context);
      getChronicDiseasesList.addAll(adminBasicAllApiController.getChronicDiseaseModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getDangerousActivities(context) async {
    try {
      getDangerousActivitiesList.clear();
      await adminBasicAllApiController.getDangerousActivitiesApi(context);
      getDangerousActivitiesList.addAll(adminBasicAllApiController.getDangerousActivitiesModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getNationality(context) async {
    try {
      nationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
    } catch (f) {
      isLoading.value = false;
    }
  }

  getInPatientDeductible(context) async {
    try {
      getInPatientList.clear();
      await adminBasicAllApiController.getInPatientDeductibleApi(context);
      getInPatientList.addAll(adminBasicAllApiController.getInPatientDeductibleModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getOutPatientDeductible(context) async {
    try {
      getOutPatientList.clear();
      await adminBasicAllApiController.getOutPatientDeducibleApi(context);
      getOutPatientList.addAll(adminBasicAllApiController.getOutPatientDeductibleModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getNoOfVisits(context) async {
    try {
      getNoOfVisitsList.clear();
      await adminBasicAllApiController.getNumberOfVisitApi(context);
      getNoOfVisitsList.addAll(adminBasicAllApiController.getNumberOfVisitModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getCityMethod(context) async {
    try {
      cityList.clear();
      companyCityList.clear();
      await adminBasicAllApiController.getCityApi(context);
      cityList.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
      companyCityList.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getDistrictMethod(context) async {
    try {
      districtList.clear();
      companyDistrictList.clear();
      await adminBasicAllApiController.getDistrictApi(context);
      districtList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
      companyDistrictList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getInsuranceLimit(context, String id) async {
    try {
      isLoadingInsuranceLimit.value = true;
      insuranceLimitList.clear();
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

  getIndividualInsuranceApi(context, String insuranceType, String apiUrl) {
    if (insuranceType == inPatientOnly) {
      getInsurancePlanApi(context, getInPatientInsurancePlan + apiUrl.toString());
    } else if (insuranceType == inOutPatientOnly) {
      getInsurancePlanApi(context, getOutPatientInsurancePlan + apiUrl.toString());
    }
  }

  getInsurancePlanApi(context, String apiUrl) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoadingInsurancePlan.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: apiUrl, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        homeInsurancePlaneModel.value = HomeInsurancePlaneModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingInsurancePlan.value = false;
    } on DioError catch (e) {
      isLoadingInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingInsurancePlan.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }
}
