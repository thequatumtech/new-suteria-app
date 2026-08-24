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
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_insurance_period_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/get_personal_accident_plan_model.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';
import 'package:soperia_user/model_class/personal_accident_insurance_model.dart';

class PersonalInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> positionController = TextEditingController().obs;
  Rx<TextEditingController> workNatureController = TextEditingController().obs;
  Rx<TextEditingController> inceptionDateController = TextEditingController().obs;
  Rx<TextEditingController> streetNameController = TextEditingController().obs;
  Rx<TextEditingController> buildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyTelephoneNoController = TextEditingController().obs;
  Rx<TextEditingController> occupancyController = TextEditingController().obs;

  String? selectedGender;
  String? selectedMaritalStatus;
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;

  Rx<GetCountryList> selectPlaceResidence = GetCountryList().obs;
  RxList<GetCountryList> placeResidenceList = <GetCountryList>[].obs;

  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;

  Rx<GetInsurancePeriod> selectInsurancePeriod = GetInsurancePeriod().obs;
  RxList<GetInsurancePeriod> insurancePeriodList = <GetInsurancePeriod>[].obs;

  List<String> genderList = [];
  List<String> maritalStatusList = [];
  RxBool isLoading = false.obs;

  String selectedOption1 = noTxt;

  final repo = getIt.get<ApiCall>();
  GetPersonalAccidentPlanModel getPersonalAccidentPlanModel = GetPersonalAccidentPlanModel();
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;
  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxBool isLoadingDocuments1 = false.obs;
  RxBool isLoadingDocuments2 = false.obs;
  RxBool isLoadingDocuments3 = false.obs;
  RxBool isLoadingDocuments4 = false.obs;
  String? selectedDangerousActivity;

  RxList<String> documents1 = <String>[].obs;
  RxList<String> documents2 = <String>[].obs;
  RxList<String> documents3 = <String>[].obs;
  RxList<String> documents4 = <String>[].obs;

  Rx<CityListModel> selectCompanyCity = CityListModel().obs;
  RxList<CityListModel> companyCityList = <CityListModel>[].obs;
  Rx<GetPersonalAccidentInsuranceModel> personalAccidentInsuranceModel = GetPersonalAccidentInsuranceModel().obs;
  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;
  RxInt planId = 0.obs;
  final picker1 = ImagePicker();

  /*Rx<GetDangerousActivitiesList> selectDangerousActivitiesList = GetDangerousActivitiesList().obs;*/
  RxList<GetDangerousActivitiesList> selectedDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;
  RxList<GetDangerousActivitiesList> getDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;

  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;
  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;
  Rx<GetNationalityList> selectNationality = GetNationalityList().obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  void init(context) async {
    await getInsuranceCurrent(context);
    await Future.wait(<Future>[
      getInsuranceLimit(context, '5'),
      getCityMethod(context),
      getDistrictMethod(context),
      getInsurancePeriodApiMethod(context),
      getCountryMethod(context),
      getNationality(context),
      getOccupations(context),
      getDangerousActivities(context),
    ]);
    await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 5);
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
    nationPassportNoController.value.clear();
    idOrResidenceNoController.value.clear();
    birthDateController.value.clear();
    selectedGender = null;
    selectedMaritalStatus = null;
    selectPlaceResidence.value = GetCountryList();
    selectNationality.value = GetNationalityList();
    companyNameController.value.clear();
    positionController.value.clear();
    workNatureController.value.clear();
    selectCity.value = CityListModel();
    selectDistrict.value = DistrictList();
    streetNameController.value.clear();
    buildingNoController.value.clear();
    companyTelephoneNoController.value.clear();
    selectCompanyCity.value = CityListModel();
    inceptionDateController.value.clear();
    selectInsurancePeriod.value = GetInsurancePeriod();
    occupancyController.value.clear();
    documents1.clear();
    documents2.clear();
    documents3.clear();
    planId.value = 0;
  }

  getInsuranceLimit(context, String id) async {
    try {
      isLoading.value = true;
      insuranceLimitList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient)
          .getRequest(context: context, endpoint: "$insuranceLimitUrl$id", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        insuranceLimitModel.value = InsuranceLimitModel.fromJson(response);
        insuranceLimitList.addAll(insuranceLimitModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  setTextData() {
    isLoading.value = true;
    policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";
    nationPassportNoController.value.text = getProfileModelGlobal.data?.nationalIdNumber.toString() ?? "";
    idOrResidenceNoController.value.text = getProfileModelGlobal.data?.residenceIdNumber.toString() ?? "";
    birthDateController.value.text = commonDateFormat(getProfileModelGlobal.data?.birthDate.toString() ?? "");
    // streetNameController.value.text = getProfileModelGlobal.data?.streetName ?? "";
    // buildingNoController.value.text = getProfileModelGlobal.data?.buildingNo ?? "";
    companyNameController.value.text = getProfileModelGlobal.data?.companyName ?? "";
    positionController.value.text = getProfileModelGlobal.data?.position ?? "";
    workNatureController.value.text = getProfileModelGlobal.data?.workNature ?? "";
    streetNameController.value.text = getProfileModelGlobal.data?.companyStreetName ?? "";
    buildingNoController.value.text = getProfileModelGlobal.data?.companyBuildingNo ?? "";
    companyTelephoneNoController.value.text = getProfileModelGlobal.data?.companyContactNo ?? "";

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

    if (cityList.isNotEmpty) {
      try {
        cityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyCityId);
        selectCity.value = cityList.first;
      } catch (e) {
        print(e);
      }
    }
    if (districtList.isNotEmpty) {
      try {
        districtList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyDistrictId);
        selectDistrict.value = districtList.first;
      } catch (e) {
        print(e);
      }
    }
    if (placeResidenceList.isNotEmpty) {
      try {
        placeResidenceList.contains((element) => element.id != getProfileModelGlobal.data?.residingCountryId);
        selectPlaceResidence.value = placeResidenceList[
            placeResidenceList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.residingCountryId)];
      } catch (e) {
        print(e);
      }
    }

    try {
      occupationList.removeWhere((element) => element.id != getProfileModelGlobal.data?.occupationId);
      selectOccupation.value =
          occupationList[occupationList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.occupationId)];
      occupancyController.value.text = selectOccupation.value.name ?? '';
    } catch (e) {
      print(e);
    }

    if (companyCityList.isNotEmpty) {
      try {
        companyCityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyCityId);
        selectCompanyCity.value = companyCityList.first;
      } catch (e) {
        print(e);
      }
    }

    try {
      nationalityList.isEmpty
          ? ''
          : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
      selectNationality.value = nationalityList.first;
    } catch (e) {}

/*    if (getInsuranceCurrentModel.value.data != null) {
      if (getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        initialDate.value = initialDate.value.add(const Duration(days: 1));
      } else {
        initialDate.value = DateTime.now();
      }
    } else {
      initialDate.value = DateTime.now();
    }*/
    inceptionDateController.value.text = commonDateFormat(DateFormat('yyyy-MM-dd').format(initialDate.value));

    isLoading.value = false;
  }

  getOccupations(context) async {
    try {
      occupationList.clear();
      await adminBasicAllApiController.getOccupationApi(context);
      occupationList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getDangerousActivities(context) async {
    try {
      getDangerousActivitiesList.clear();

      await adminBasicAllApiController.getDangerousActivitiesApi(context);
      getDangerousActivitiesList.addAll(adminBasicAllApiController.getDangerousActivitiesModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getNationality(context) async {
    try {
      nationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getCountryMethod(context) async {
    try {
      placeResidenceList.clear();
      await adminBasicAllApiController.getCountryApi(context);
      placeResidenceList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
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
      await adminBasicAllApiController.getDistrictApi(context);
      districtList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getInsurancePeriodApiMethod(context) async {
    try {
      insurancePeriodList.clear();
      await adminBasicAllApiController.getInsurancePeriodApi(context);
      insurancePeriodList.addAll(adminBasicAllApiController.getInsurancePeriodModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getPersonalAccidentInsurancePlanApi(context, String id) async {
    ///TOO-DO
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      String periodValue = RegExp(r'\d+').stringMatch(selectInsurancePeriod.value.name ?? '') ??
          (selectInsurancePeriod.value.name ?? selectInsurancePeriod.value.id?.toString() ?? '');
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
          context: context,
          endpoint:
              "$getPersonalAccidentPlanInsurancePlan${id.toString().replaceAll('.0', '')}&insurance_period=$periodValue",
          options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        personalAccidentInsuranceModel.value = GetPersonalAccidentInsuranceModel.fromJson(response);
        homeInsurancePlaneModel.value = HomeInsurancePlaneModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getPersonalAccidentPlane(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient)
          .getRequest(context: context, endpoint: getPersonalAccidentInsurance, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getPersonalAccidentPlanModel = GetPersonalAccidentPlanModel.fromJson(response);
        print(response);
        print("response>>>>>>>>>>>");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: AppText(
          text: response[messageKey].toString(),
          txtColor: primaryWhite,
          size: 12,
        )));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: e.response!.statusMessage!,
        txtColor: primaryWhite,
        size: 12,
      )));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: "$f",
        txtColor: primaryWhite,
        size: 12,
      )));
    }
  }
}
