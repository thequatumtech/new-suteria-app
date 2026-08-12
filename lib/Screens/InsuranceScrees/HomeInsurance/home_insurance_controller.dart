import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
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
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/get_protection_system_model.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class HomeInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;

  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> occupancyController = TextEditingController().obs;
  Rx<TextEditingController> streetNameController = TextEditingController().obs;
  Rx<TextEditingController> buildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> positionController = TextEditingController().obs;
  Rx<TextEditingController> workNatureController = TextEditingController().obs;
  Rx<TextEditingController> blockNoController = TextEditingController().obs;
  Rx<TextEditingController> plateNoController = TextEditingController().obs;
  Rx<TextEditingController> plotNoController = TextEditingController().obs;
  Rx<TextEditingController> sizeOfApartmentController = TextEditingController().obs;
  Rx<TextEditingController> effectiveDateController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;
  Rx<TextEditingController> previousPolicyExplain = TextEditingController().obs;
  Rx<TextEditingController> whyDeclineController = TextEditingController().obs;
  Rx<TextEditingController> claimIn5yearController = TextEditingController().obs;

  String? selectedgender;
  List<String> genderList = [];
  String? selectedMaritalStatus;
  List<String> selectedMaritalStatusList = [];
  String? selecthomeType;
  String? selectNoOfFloors;
  String? selectedroomsItem;
  String? selectedAgeItem;
  //String? noOfResidence;
  TextEditingController noOfResidence1=TextEditingController();
  String? selectedOwnership;
  String selectedOption1 = noTxt;
  String selectedOption2 = noTxt;
  String selectedOption3 = noTxt;
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());
  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;
  Rx<CityListModel> selectCompanyCity = CityListModel().obs;
  RxList<CityListModel> companyCityList = <CityListModel>[].obs;
  RxList<ProtectionSystemList> protectionSystemList = <ProtectionSystemList>[].obs;
  RxList<DropdownItem<int>> selectProtectionSystemList = <DropdownItem<int>>[].obs;
  RxList<DropdownItem<int>> protectionSystemListDrop = <DropdownItem<int>>[].obs;
  final controller = MultiSelectController<int>();
  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;
  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;
  Rx<GetCountryList> selectCountry = GetCountryList().obs;
  RxList<GetCountryList> countryList = <GetCountryList>[].obs;

  Rx<GetCountryList> selectPlaceResidence = GetCountryList().obs;
  RxList<GetCountryList> placeResidenceList = <GetCountryList>[].obs;

  Rx<GetNationalityList> selectNatonality = GetNationalityList().obs;
  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;
  RxBool isLoadingRentContractDoc = false.obs;
  RxBool isLoadingPropertyDoc = false.obs;
  RxBool isLoadingContentsDoc = false.obs;

  RxList<String> rentContractDoc = <String>[].obs;
  RxList<String> propertyDoc = <String>[].obs;
  RxList<String> contentsDoc = <String>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingInsurancePlan = false.obs;

  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;

  String planDd = '';
  String insuranceLimit = '';

  final picker = ImagePicker();
  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;

  Rx<PlanName> selectedInsurancePlan = PlanName().obs;
  RxList<PlanName> insurancePlanList = <PlanName>[].obs;
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  Future<void> init(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await getCityMethod(context);
    await getCountryMethod(context);
    await getNationality(context);
    await getDistrictMethod(context);
    await getProtectionSystemMethod(context);
    await getOccupations(context);
    await setDataTextField();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 1);
      getInsuranceCurrentModel.value = adminBasicAllApiController.getInsuranceCurrentModel.value;
    } on DioError catch (e) {
      print(e);
    } catch (f) {
      print(f);
    }
  }

  clearDataMethod() {
    selectedgender = '';
    genderList.clear();
    selectedMaritalStatus = '';
    selectedMaritalStatusList.clear();
    policyHolderFirstNameController.value.clear();
    policyHolderSecondNameController.value.clear();
    policyHolderThirdNameController.value.clear();
    policyHolderFamilyNameController.value.clear();
    contentsDoc.clear();
    propertyDoc.clear();
    rentContractDoc.clear();
    blockNoController.value.clear();
    plateNoController.value.clear();
    plotNoController.value.clear();
    selectProtectionSystemList.clear();
    sizeOfApartmentController.value.clear();
    previousPolicyExplain.value.clear();
    whyDeclineController.value.clear();
    claimIn5yearController.value.clear();
    selectedInsuranceLimit.value = InsuranceLimitListData();
    selectedInsurancePlan.value = PlanName();
    selecthomeType = null;
    selectNoOfFloors = null;
    selectedroomsItem = null;
    selectedroomsItem = null;
    selectedAgeItem = null;
    selectedAgeItem = null;
    noOfResidence1.clear();
    selectedOwnership = null;
    selectNatonality.value = GetNationalityList();
    nationPassportNoController.value.clear();
    idOrResidenceNoController.value.clear();
    birthDateController.value.clear();
    selectPlaceResidence.value = GetCountryList();
    occupancyController.value.clear();
    selectCountry.value = GetCountryList();
    selectCity.value = CityListModel();
    selectDistrict.value = DistrictList();
    streetNameController.value.clear();
    buildingNoController.value.clear();
    companyNameController.value.clear();
    selectCompanyCity.value = CityListModel();
    positionController.value.clear();
    workNatureController.value.clear();
    insuranceLimit = '';
    planDd = '';
    effectiveDateController.value.clear();
    expiryDateController.value.clear();
    controller.clearAll();
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
  }

   setDataTextField() {
    try {
      genderList.clear();

      genderList.add(getProfileModelGlobal.data?.gender.toString() == "1" ? male : female ?? '');
      selectedgender = genderList.first;

      selectedMaritalStatus = getProfileModelGlobal.data?.maritalStatus.toString() == "1"
          ? single
          : getProfileModelGlobal.data?.maritalStatus.toString() == "2"
              ? married
              : getProfileModelGlobal.data?.maritalStatus.toString() == "3"
                  ? divorced
                  : widowed;

      selectedMaritalStatusList.clear();
      selectedMaritalStatusList.add(getProfileModelGlobal.data?.maritalStatus.toString() == "1"
          ? single
          : getProfileModelGlobal.data?.maritalStatus.toString() == "2"
              ? married
              : getProfileModelGlobal.data?.maritalStatus.toString() == "3"
                  ? divorced
                  : widowed);

      policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? '';
      policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? '';
      policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? '';
      policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? '';

      try {
        nationalityList.isEmpty ? '' : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
        selectNatonality.value = nationalityList.first;
      }  catch (e) {
              }

      nationPassportNoController.value.text = getProfileModelGlobal.data?.nationalIdNumber.toString() ?? '';

      idOrResidenceNoController.value.text = getProfileModelGlobal.data?.residenceIdNumber.toString() ?? '';
      birthDateController.value.text = commonDateFormat(getProfileModelGlobal.data?.birthDate.toString() ?? '');
      occupancyController.value.text = getProfileModelGlobal.data?.occupationId.toString() ?? '';

      if (countryList.isNotEmpty) {
        countryList.removeWhere((element) => element.id != getProfileModelGlobal.data?.countryId);
        countryList.isNotEmpty ? selectCountry.value = countryList[countryList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.countryId)] : '';
      }

      /* if (getProfileModelGlobal.data?.residingCountrySame.toString() == "1") {
        selectPlaceResidence.value = selectCountry.value;
      } else {*/
      try {
        placeResidenceList.contains((element) => element.id != getProfileModelGlobal.data?.residingCountryId);
        selectPlaceResidence.value = placeResidenceList[placeResidenceList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.residingCountryId)];
      }  catch (e) {

      }
      // }

      try {
        occupationList.removeWhere((element) => element.id != getProfileModelGlobal.data?.occupationId);
        selectOccupation.value = occupationList[occupationList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.occupationId)];
      }  catch (e) {
              }

      try {
        if (cityList.isNotEmpty) {
          cityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.cityId);
          selectCity.value = cityList.first;
        }
      }  catch (e) {
              }

      try {
        if (companyCityList.isNotEmpty) {
          companyCityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyCityId);
          selectCompanyCity.value = companyCityList.first;
        }
      }  catch (e) {

      }

      try {
        if (districtList.isNotEmpty) {
          districtList.removeWhere((element) => element.id != getProfileModelGlobal.data?.districtId);
          selectDistrict.value = districtList.first;
        }
      }  catch (e) {

      }

      streetNameController.value.text = getProfileModelGlobal.data?.streetName.toString() ?? '';
      buildingNoController.value.text = getProfileModelGlobal.data?.buildingNo.toString() ?? '';
      companyNameController.value.text = getProfileModelGlobal.data?.companyName.toString() ?? '';
      positionController.value.text = getProfileModelGlobal.data?.position.toString() ?? '';
      workNatureController.value.text = getProfileModelGlobal.data?.workNature.toString() ?? '';

     /* if (getInsuranceCurrentModel.value.data != null) {
        if (getInsuranceCurrentModel.value.data!.expiryDate != null ) {
         *//* initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
          initialDate.value = initialDate.value.add(const Duration(days: 1));*//*
        } else {
          initialDate.value = DateTime.now();
        }
      } else {
        initialDate.value = DateTime.now();
      }*/
      effectiveDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
      expiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(initialDate.value)).add(const Duration(days: 364)).toString())));
    } on Exception catch (e) {
      isLoading.value = false;
    }

    isLoading.value = false;
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

  getNationality(context) async {
    try {
      nationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: e.response!.statusMessage!,
        txtColor: primaryWhite,
        size: 12,
      )));
    } catch (f) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: "$f",
        txtColor: primaryWhite,
        size: 12,
      )));
    }
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

  getOccupations(context) async {
    try {
      occupationList.clear();
      await adminBasicAllApiController.getOccupationApi(context);
      occupationList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  final repo = getIt.get<ApiCall>();

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

  getHomeInsurancePlanApi(context, String planName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoadingInsurancePlan.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getHomeInsurancePlan$planName", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        homeInsurancePlaneModel.value = HomeInsurancePlaneModel.fromJson(response);
        if (homeInsurancePlaneModel.value.data == null || homeInsurancePlaneModel.value.data!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: noInsurancePlanFound, txtColor: primaryWhite, size: 12)));
        }
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
