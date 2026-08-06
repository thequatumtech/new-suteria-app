import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
import 'package:soperia_user/model_class/get_insurance_period_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class DentalInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;

  String? selectedgender;
  String? selectedMaritalStatus;

  Rx<GetCountryList> selectResidence = GetCountryList().obs;
  RxList<GetCountryList> residenceList = <GetCountryList>[].obs;

  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;

  Rx<GetInsurancePeriod> selectInsurancePeriod = GetInsurancePeriod().obs;
  RxList<GetInsurancePeriod> insurancePeriodList = <GetInsurancePeriod>[].obs;

  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;

  Rx<CityListModel> selectCompanyCity = CityListModel().obs;
  RxList<CityListModel> companyCityList = <CityListModel>[].obs;

  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;

  Rx<DistrictList> selectCompanyDistrict = DistrictList().obs;
  RxList<DistrictList> companyDistrictList = <DistrictList>[].obs;

  Rx<TextEditingController> companyStreetNameController = TextEditingController().obs;
  Rx<TextEditingController> companyBuildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyContactNoController = TextEditingController().obs;
  Rx<TextEditingController> streetNameController = TextEditingController().obs;
  Rx<TextEditingController> buildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> positionController = TextEditingController().obs;
  Rx<TextEditingController> workNatureController = TextEditingController().obs;
  Rx<TextEditingController> effectiveDateController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;

  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

  RxBool isLoading = false.obs;
  List<String> genderList = [];
  List<String> maritalStatusList = [];

  Rx<GetNationalityList> selectNatonality = GetNationalityList().obs;
  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;

  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;
  Rx<PlanName> selectedInsurancePlan = PlanName().obs;
  RxList<PlanName> insurancePlanList = <PlanName>[].obs;
  final repo = getIt.get<ApiCall>();

  RxBool isLoadingPhotoDoc = false.obs;
  final picker = ImagePicker();
  RxList<String> photoDoc = <String>[].obs;

  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;
  String planDd = '';
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  void initCall(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await getNationality(context);
    await getOccupations(context);
    await getInsurancePeriodApiMethod(context);
    await getCityMethod(context);
    await getDistrictMethod(context);
    await getCountryMethod(context);
    await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 9);
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
    selectNatonality.value = GetNationalityList();
    selectResidence.value = GetCountryList();
    birthDateController.value.clear();
    selectedgender = null;
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
    selectedInsuranceLimit.value = InsuranceLimitListData();
    selectedInsurancePlan.value = PlanName();
    effectiveDateController.value.clear();
    expiryDateController.value.clear();
    photoDoc.clear();
    planDd = '';
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
    positionController.value.text = getProfileModelGlobal.data?.position ?? "";
    streetNameController.value.text = getProfileModelGlobal.data?.streetName ?? "";
    buildingNoController.value.text = getProfileModelGlobal.data?.buildingNo ?? "";
    companyNameController.value.text = getProfileModelGlobal.data?.companyName ?? "";
    // positionController.value.text = getProfileModelGlobal.data?.??"";
    workNatureController.value.text = getProfileModelGlobal.data?.workNature ?? "";
    companyStreetNameController.value.text = getProfileModelGlobal.data?.companyStreetName ?? "";
    companyBuildingNoController.value.text = getProfileModelGlobal.data?.companyBuildingNo ?? "";
    companyContactNoController.value.text = getProfileModelGlobal.data?.companyContactNo ?? "";

    try {
      occupationList.removeWhere((element) => element.id != getProfileModelGlobal.data?.occupationId);
      selectOccupation.value = occupationList[occupationList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.occupationId)];
    }  catch (e) {
      print(e);
    }

    try {
      nationalityList.isEmpty ? '' : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
      selectNatonality.value = nationalityList.first;
    }  catch (e) {
      print(e);
    }

    try {
      residenceList.contains((element) => element.id != getProfileModelGlobal.data?.residingCountryId);
      selectResidence.value = residenceList[residenceList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.residingCountryId)];
    }  catch (e) {
      print(e);
    }

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

    if (cityList.isNotEmpty) {
      try {
        cityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.cityId);
        selectCity.value = cityList.first;
      }  catch (e) {
        print(e);
      }
    }

    try {
      companyCityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyCityId);
      selectCompanyCity.value = companyCityList[companyCityList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.companyCityId)];
    } catch (e) {
      print(e);
    }

    if (districtList.isNotEmpty) {
      try {
        districtList.removeWhere((element) => element.id != getProfileModelGlobal.data?.districtId);
        selectDistrict.value = districtList.first;
      }  catch (e) {
        print(e);
      }
    }

    try {
      companyDistrictList.removeWhere((element) => element.id != getProfileModelGlobal.data?.companyDistrictId);
      selectCompanyDistrict.value = companyDistrictList[companyDistrictList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.companyDistrictId)];
    } catch (e) {
      print(e);
    }

    /*if (getInsuranceCurrentModel.value.data != null) {
      if (getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        initialDate.value = initialDate.value.add(const Duration(days: 1));
      } else {
        initialDate.value = DateTime.now();
      }
    } else {
      initialDate.value = DateTime.now();
    }*/
    initialDate.value = DateTime.now();
    effectiveDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
    expiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(initialDate.value)).add(Duration(days: selectedInsurancePlan.value.policyPeriod ?? 364)).toString())));
    isLoading.value = false;
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

  getOccupations(context) async {
    try {
      occupationList.clear();
      await adminBasicAllApiController.getOccupationApi(context);
      occupationList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getNationality(context) async {
    try {
      nationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  /*getGeoGraphicalArea(context) async {
    try {

      districtList.clear();
      await adminBasicAllApiController.getGeographicalAreaApi(context);
      districtList.addAll(adminBasicAllApiController.getGeographicalAreaModelClass.value.data ?? []);

    } on DioError catch (e) {

    } catch (f) {
       }
  }*/

  getInsurancePeriodApiMethod(context) async {
    try {
      insurancePeriodList.clear();
      await adminBasicAllApiController.getInsurancePeriodApi(context);
      insurancePeriodList.addAll(adminBasicAllApiController.getInsurancePeriodModelClass.value.data ?? []);
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
      residenceList.clear();
      await adminBasicAllApiController.getCountryApi(context);
      print(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      residenceList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getDentalInsurancePlanApi(context, String planName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getDentalInsurancePlan$planName", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        homeInsurancePlaneModel.value = HomeInsurancePlaneModel.fromJson(response);
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
}
