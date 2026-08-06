import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/dio_clients.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_insurance_period_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

import 'insurance_perioad_years_model.dart';

class LifeInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationalityController = TextEditingController().obs;
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
  Rx<TextEditingController> effectiveDateController = TextEditingController().obs;
  Rx<TextEditingController> beneficiaryFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> beneficiarySecondNameController = TextEditingController().obs;
  Rx<TextEditingController> beneficiaryThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> beneficiaryFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> previousOperationDetailsController = TextEditingController().obs;
  Rx<TextEditingController> companyDeclinedIssueController = TextEditingController().obs;
  Rx<TextEditingController> existingLifeInsuranceController = TextEditingController().obs;

  String? selectedgender;
  String? selectedMaritalStatus;

  Rx<GetCountryList> selectPlaceResidence = GetCountryList().obs;
  RxList<GetCountryList> placeResidenceList = <GetCountryList>[].obs;

  String selectAmericanNationality = '';
  String selectedOption1 = noTxt;
  String selectedAnyOperation = '';
  String selectedDescline = '';
  String selectedNowAnyPolicy = '';

  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;

  Rx<CityListModel> selectCompanyCity = CityListModel().obs;
  RxList<CityListModel> companyCityList = <CityListModel>[].obs;

  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;
  Rx<GetCountryList> selectCountry = GetCountryList().obs;
  RxList<GetCountryList> countryList = <GetCountryList>[].obs;

  Rx<DistrictList> selectCompanyDistrict = DistrictList().obs;
  RxList<DistrictList> companyDistrictList = <DistrictList>[].obs;
  RxList<GetChronicDiseasesList> getChronicDiseasesList = <GetChronicDiseasesList>[].obs;

/*  Rx<GetChronicDiseasesList> selectChronicDiseases = GetChronicDiseasesList().obs;*/
  RxList<GetChronicDiseasesList> selectedChronicDiseasesList = <GetChronicDiseasesList>[].obs;
  String? selectedChronicDisease;

  /* InsurancePeriodModel insurancePeriodYear=InsurancePeriodModel();
  Rxn<InsurancePeriodModel> selectInsurancePeriod = Rxn<InsurancePeriodModel>();
  RxList<InsurancePeriodModel> insurancePeriodList = <InsurancePeriodModel>[].obs;*/
  var insurancePeriodList = <InsurancePeriodModel>[].obs;
  var selectInsurancePeriod = Rxn<InsurancePeriodModel>();

  Rx<GetNationalityList> selectNatonality = GetNationalityList().obs;
  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;

  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingGetLifeInsurance = false.obs;
  List<String> genderList = [];
  List<String> maritalStatusList = [];
  final repo = getIt.get<ApiCall>();
  RxBool isLoadingPhotoDoc = false.obs;
  RxBool isLoadingFamilyBookDoc = false.obs;
  RxBool isLoadingInsuredDoc = false.obs;

  RxList<String> photoDoc = <String>[].obs;
  RxList<String> familyBookDoc = <String>[].obs;
  RxList<String> insuredDoc = <String>[].obs;

  final picker = ImagePicker();
  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;
  RxInt planId = 0.obs;
  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;
  RxBool isShowHWValidationMsg = false.obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  Future<void> init(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await getNationality(context);
    await getOccupations(context);
    await getChronicDiseases(context);
    await getCityMethod(context);
    await getDistrictMethod(context);
    await getCountryMethod(context);
    getInsurancePeriodApiYear();
    /*await getInsurancePeriodApiMethod(context);*/
    await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 3);
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
    nationalityController.value.clear();
    nationPassportNoController.value.clear();
    idOrResidenceNoController.value.clear();
    birthDateController.value.clear();
    selectedgender = null;
    beneficiaryFirstNameController.value.clear();
    beneficiarySecondNameController.value.clear();
    beneficiaryThirdNameController.value.clear();
    selectedMaritalStatus = null;
    selectPlaceResidence.value = GetCountryList();
    selectOccupation.value = OccuptionList();
    selectAmericanNationality = '';
    selectCountry.value = GetCountryList();
    selectCity.value = CityListModel();
    selectDistrict.value = DistrictList();
    streetNameController.value.clear();
    buildingNoController.value.clear();
    selectedOption1 = noTxt;
    companyNameController.value.clear();
    positionController.value.clear();
    workNatureController.value.clear();
    selectCompanyCity.value = CityListModel();
    selectCompanyDistrict.value = DistrictList();
    companyStreetNameController.value.clear();
    companyBuildingNoController.value.clear();
    companyContactNoController.value.clear();
    heightController.value.clear();
    weightController.value.clear();
    selectedChronicDiseasesList.value = [];
    selectedAnyOperation = '';
    previousOperationDetailsController.value.clear();
    selectedDescline = '';
    companyDeclinedIssueController.value.clear();
    selectedNowAnyPolicy = '';
    existingLifeInsuranceController.value.clear();
    selectedInsuranceLimit.value = InsuranceLimitListData();
    effectiveDateController.value.clear();
    planId.value = 0;
    selectInsurancePeriod.value = InsurancePeriodModel();
    photoDoc.clear();
    familyBookDoc.clear();
    insuredDoc.clear();
  }

  getInsuranceLimit(context, String id) async {
    try {
      isLoading.value = true;
      insuranceLimitList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$insuranceLimitUrl$id", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        insuranceLimitModel.value = InsuranceLimitModel.fromJson(response);
        insuranceLimitList.addAll(insuranceLimitModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  setTextData() {
    isLoading.value = true;
    policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";

    beneficiaryFirstNameController.value.text = legalInheritors;
    beneficiarySecondNameController.value.text = legalInheritors;

/*    beneficiaryFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    beneficiarySecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    beneficiaryThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    beneficiaryFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";*/

    nationalityController.value.text = getProfileModelGlobal.data?.nationalityId.toString() ?? "";
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

    /*  if (getProfileModelGlobal.data?.residingCountrySame.toString() == "1") {
      */ /*  placeResidenceList.removeWhere((element) => element.id != selectCountry.value.id);*/ /*
      selectPlaceResidence.value = selectCountry.value;
    } else {*/
    try {
      placeResidenceList.contains((element) => element.id != getProfileModelGlobal.data?.residingCountryId);
      selectPlaceResidence.value = placeResidenceList[placeResidenceList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.residingCountryId)];
    } catch (e) {}
    // }

    try {
      occupationList.removeWhere((element) => element.id != getProfileModelGlobal.data?.occupationId);
      selectOccupation.value = occupationList[occupationList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.occupationId)];
    } catch (e) {}

    try {
      nationalityList.isEmpty ? '' : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
      selectNatonality.value = nationalityList.first;
    } catch (e) {}

    genderList.clear();
    genderList.add(getProfileModelGlobal.data?.gender.toString() == "1" ? male : female ?? '');
    selectedgender = genderList.first;

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
      countryList.removeWhere((element) => element.id != getProfileModelGlobal.data?.countryId);
      countryList.isNotEmpty ? selectCountry.value = countryList[countryList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.countryId)] : '';

      /* GetCountryList cdl = countryList.firstWhere((element) => element.id == getProfileModelGlobal.data?.countryId);
      selectCountry.value = cdl;*/
    } catch (e) {
      print(e);
    }
    try {
      cityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.cityId);
      selectCity.value = cityList.first;
    } catch (e) {
      print(e);
    }

    try {
      districtList.removeWhere((element) => element.id != getProfileModelGlobal.data?.districtId);
      selectDistrict.value = districtList.first;
    } catch (e) {
      print(e);
    }

    try {
      companyCityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyCityId);
      selectCompanyCity.value = companyCityList[companyCityList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.companyCityId)];
    } catch (e) {
      print(e);
    }

    try {
      companyDistrictList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyDistrictId);
      selectCompanyDistrict.value = companyDistrictList[companyDistrictList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.companyDistrictId)];
    } catch (e) {
      print(e);
    }

    /* if (getInsuranceCurrentModel.value.data != null) {
      if (getInsuranceCurrentModel.value.data!.expiryDate != null) {
        initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        initialDate.value = initialDate.value.add(const Duration(days: 1));
      } else {
        initialDate.value = DateTime.now();
      }
    } else {
      initialDate.value = DateTime.now();
    }*/
    effectiveDateController.value.text = commonDateFormat(DateFormat("dd/MM/yyyy").format(initialDate.value));

    if (getProfileModelGlobal.data?.employmentType != null) {
      if (getProfileModelGlobal.data?.employmentType == employed) {
        selectedOption1 = yesTxt;
      }
    }
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

  getOccupations(context) async {
    try {
      occupationList.clear();
      await adminBasicAllApiController.getOccupationApi(context);
      occupationList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
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
      companyDistrictList.clear();
      await adminBasicAllApiController.getDistrictApi(context);
      districtList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
      companyDistrictList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
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

  /* getInsurancePeriodApiMethod(context) async {
    try {
      insurancePeriodList.clear();
      await adminBasicAllApiController.getInsurancePeriodApi(context);

    } on DioError catch (e) {
    } catch (f) {}
  }*/

  /// Fetches the insurance period years from the API and updates [insurancePeriodList].
  /// Shows a SnackBar on error or unexpected response.
/*  Future<void> getInsurancePeriodApiYear(BuildContext context) async {
    try {
      // Clear the existing list before fetching new data
      insurancePeriodList.clear();

      // Get headers for the API request
      final Map<String, String> header = await getHeader();

      // Make the API GET request
      var response = await ApiCall(dioClient: repo.dioClient).getRequestList(
        context: context,
        endpoint: getInsurancePeriodYears,
        options: Options(headers: header),
      );
      print(response);

      insurancePeriodYear=InsurancePeriodModel.fromJson(response);
      print(insurancePeriodYear);




    } on DioError catch (e) {
      final String errorMessage = e.response?.statusMessage ?? 'Network error occurred.';
      _showSnackBar(context, errorMessage);
    } catch (e) {
      _showSnackBar(context, "Error: $e");
    }
  }*/

  void getInsurancePeriodApiYear() async {
    try {
      final dio = Dio();
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        logPrint: logPrintFull,
      ));

      final Map<String, String> header = await getHeader();

      // Make GET request
      final response = await dio.get(
        'https://kre8consultancy.com/api/get-life-insurance-period',
        options: Options(headers: header),
      );

      if (response.statusCode == 200) {
        // Convert to List<Map<String, dynamic>>
        final List data = response.data;
        insurancePeriodList.value = data.map((e) => InsurancePeriodModel.fromJson(e)).toList();
        /*  final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(response.data);*/
        print("Insurance List: $insurancePeriodList");
        // Optional: print the JSON
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Utility method to show a SnackBar with custom text
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          text: message,
          txtColor: primaryWhite,
          size: 12,
        ),
      ),
    );
  }

  /* getInsurancePeriodApiYear(context) async {
    try {
      insurancePeriodList.clear();
      //isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getInsurancePeriodYears, options: Options(headers: header));


      */ /* if (response[statusCode] == 200 || response[statusCode] == 201) {*/ /*
      */ /*  insurancePeriodYear = InsurancePeriodYear.fromJson(response);*/ /*
      */ /*insurancePeriodList = InsurancePeriodModel
          .map((item) => InsurancePeriodModel.fromJson(item))
          .toList();*/ /*
      print(response.runtimeType);  // Helps confirm if it's Map or List
      print(response);
      insurancePeriodList.value = response
          .map((item) => InsurancePeriodModel.fromJson(item))
          .toList();

     */ /* } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }*/ /*
    //  isLoading.value = false;
    } on DioError catch (e) {
    //  isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
    //  isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }*/

  getNationality(context) async {
    try {
      nationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getLifeInsurancePlanApi(context, String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      isLoadingGetLifeInsurance.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response =
          await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getLifeInsurancePlan${id.toString().replaceAll('.0', '')}", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        homeInsurancePlaneModel.value = HomeInsurancePlaneModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingGetLifeInsurance.value = false;
    } on DioError catch (e) {
      isLoadingGetLifeInsurance.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingGetLifeInsurance.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }
}
