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
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_engine_type_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/get_vehicle_brand_model.dart';
import 'package:soperia_user/model_class/get_vehicle_color_model.dart';
import 'package:soperia_user/model_class/get_vehicle_type_model.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/vehical_category_model.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/models/inspection_manifest.dart';

class MotorInsuranceController extends GetxController {
  Rx<InspectionManifest?> inspectionManifest = Rx<InspectionManifest?>(null);
  RxBool is360InspectionCompleted = false.obs;
  RxList<String> selectedInspection360Videos = <String>[].obs;

  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> positionController = TextEditingController().obs;
  Rx<TextEditingController> workOfNatureController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;
  Rx<TextEditingController> inceptionDateController = TextEditingController().obs;
  Rx<TextEditingController> streetNameController = TextEditingController().obs;
  Rx<TextEditingController> companyStreetNameController = TextEditingController().obs;
  Rx<TextEditingController> buildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyBuildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyContactNoController = TextEditingController().obs;
  Rx<TextEditingController> userMobileNoController = TextEditingController().obs;
  Rx<TextEditingController> noOfAccidentController = TextEditingController().obs;
  Rx<TextEditingController> noOfTicketsController = TextEditingController().obs;
  Rx<TextEditingController> noOfPointsController = TextEditingController().obs;
  Rx<TextEditingController> vehiclePlateNoController = TextEditingController().obs;
  Rx<TextEditingController> vehicleRegistrationNoController = TextEditingController().obs;
  Rx<TextEditingController> vehicleEngineNoController = TextEditingController().obs;
  Rx<TextEditingController> vehicleEngineCapacityController = TextEditingController().obs;
  Rx<TextEditingController> vehicleChassisNoController = TextEditingController().obs;
  Rx<TextEditingController> vehicleValueController = TextEditingController().obs;
  Rx<TextEditingController> vehicleManufactureDateController = TextEditingController().obs;

  Rx<TextEditingController> nationIdController = TextEditingController().obs;
  Rx<TextEditingController> residencyNumberController = TextEditingController().obs;
  String? selectedGender;
  String? selectedMaritalStatus;

  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;

  Rx<CityListModel> selectCompanyCity = CityListModel().obs;
  RxList<CityListModel> companyCityList = <CityListModel>[].obs;

  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;

  Rx<DistrictList> selectCompanyDistrict = DistrictList().obs;
  RxList<DistrictList> companyDistrictList = <DistrictList>[].obs;

  Rx<VehicleTypeList> selectVehicleType = VehicleTypeList().obs;
  RxList<VehicleTypeList> vehicleTypeList = <VehicleTypeList>[].obs;

  Rx<VehicleBrandList> selectVehicleBrand = VehicleBrandList().obs;
  RxList<VehicleBrandList> vehicleBrandList = <VehicleBrandList>[].obs;

  Rx<VehicleColorList> selectVehicleColor = VehicleColorList().obs;
  RxList<VehicleColorList> vehicleColorList = <VehicleColorList>[].obs;

  Rx<GetEngineTypeList> selectEngineType = GetEngineTypeList().obs;
  RxList<GetEngineTypeList> engineTypeList = <GetEngineTypeList>[].obs;

  // Rx<GetMotorPlaneList> selectMotorPlane = GetMotorPlaneList().obs;
  // RxList<GetMotorPlaneList> motorPlaneList = <GetMotorPlaneList>[].obs;
  String? selectInsuranceType;
  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;
  Rx<GetNationalityList> selectNatonality = GetNationalityList().obs;

  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingVehicleCategory = false.obs;

  List<String> genderList = [];
  List<String> maritalStatusList = [];

  final repo = getIt.get<ApiCall>();
  RxBool isLoadingResidenceIdFront = false.obs;
  RxBool isLoadingResidenceIdBack = false.obs;
  RxBool isLoadingLicenseFront = false.obs;
  RxBool isLoadingLicenseBack = false.obs;
  RxBool isLoadingPhotoFront = false.obs;
  RxBool isLoadingPhotoBack = false.obs;
  RxBool isLoadingPhotoRightSide = false.obs;
  RxBool isLoadingPhotoLeftSide = false.obs;
  RxBool isLoadingCarseer = false.obs;
  RxBool isLoadingAutoScore = false.obs;
  RxBool isLoadingCustomsDeclaration = false.obs;

  final picker = ImagePicker();
  RxList<String> selectedResidenceIdFront = <String>[].obs;
  RxList<String> selectedResidenceIdBack = <String>[].obs;
  RxList<String> selectedLicenseFront = <String>[].obs;
  RxList<String> selectedLicenseBack = <String>[].obs;
  RxList<String> selectedPhotoFront = <String>[].obs;
  RxList<String> selectedPhotoBack = <String>[].obs;
  RxList<String> selectedPhotoRightSide = <String>[].obs;
  RxList<String> selectedPhotoLeftSide = <String>[].obs;
  RxList<String> selectedCarseer = <String>[].obs;
  RxList<String> selectedAutoScore = <String>[].obs;
  RxList<String> selectedCustomsDeclaration = <String>[].obs;

  String planDd = '';
  String insuranceLimit = '';
  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;
  RxBool isLoadingInsurancePlan = false.obs;

  Rx<GetVehicleCategoryModel> getVehicleCategoryModel = GetVehicleCategoryModel().obs;
  Rx<VehicleCategoryList> selectVehicleTypeCategory = VehicleCategoryList().obs;
  RxList<VehicleCategoryList> vehicleTypeListCategory = <VehicleCategoryList>[].obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  initMethodCall(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await getCityMethod(context);
    await getDistrictMethod(context);
    await getVehicleTypeMethod(context);
    await getNationality(context);
    await getVehicleBrandMethod(context);
    await getOccupations(context);
    await getVehicleColorMethod(context);
    await getEngineTypeMethod(context);
    // await getMotorPlaneMethod(context);
   await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 12);
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
    userMobileNoController.value.clear();
    companyNameController.value.clear();
    positionController.value.clear();
    workOfNatureController.value.clear();
    companyContactNoController.value.clear();
    inceptionDateController.value.clear();
    expiryDateController.value.clear();
    noOfAccidentController.value.clear();
    residencyNumberController.value.clear();//Add commentMore actions
    nationIdController.value.clear();
    noOfTicketsController.value.clear();
    noOfPointsController.value.clear();
    vehiclePlateNoController.value.clear();
    selectVehicleType.value = VehicleTypeList();
    selectVehicleBrand.value = VehicleBrandList();
    selectVehicleTypeCategory.value = VehicleCategoryList();
    selectVehicleColor.value = VehicleColorList();
    vehicleRegistrationNoController.value.clear();
    vehicleEngineNoController.value.clear();
    vehicleChassisNoController.value.clear();
    selectEngineType.value = GetEngineTypeList();
    vehicleEngineCapacityController.value.clear();
    vehicleManufactureDateController.value.clear();
    vehicleValueController.value.clear();
    selectInsuranceType = null;
    planDd = '';
    selectedResidenceIdFront.clear();
    selectedResidenceIdBack.clear();
    selectedLicenseFront.clear();
    selectedLicenseBack.clear();
    selectedPhotoFront.clear();
    selectedPhotoBack.clear();
    selectedPhotoRightSide.clear();
    selectedPhotoLeftSide.clear();
    selectedCarseer.clear();
    selectedAutoScore.clear();
    selectedCustomsDeclaration.clear();
    inspectionManifest.value = null;
    is360InspectionCompleted.value = false;
    selectedInspection360Videos.clear();
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
    streetNameController.value.text = getProfileModelGlobal.data?.streetName ?? "";
    buildingNoController.value.text = getProfileModelGlobal.data?.buildingNo ?? "";
    userMobileNoController.value.text = getProfileModelGlobal.data?.mobileNo ?? "";
    companyNameController.value.text = getProfileModelGlobal.data?.companyName ?? "";
    positionController.value.text = getProfileModelGlobal.data?.position ?? "";
    workOfNatureController.value.text = getProfileModelGlobal.data?.workNature ?? "";
    companyStreetNameController.value.text = getProfileModelGlobal.data?.companyStreetName ?? "";
    companyBuildingNoController.value.text = getProfileModelGlobal.data?.companyBuildingNo ?? "";
    companyContactNoController.value.text = getProfileModelGlobal.data?.companyContactNo ?? "";

    genderList.clear();
    genderList.add(getProfileModelGlobal.data?.gender.toString() == "1" ? male : female ?? '');
    selectedGender = genderList.first;

    try {
      nationalityList.isEmpty ? '' : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
      selectNatonality.value = nationalityList.first;
    } catch (e) {}

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

    print(getProfileModelGlobal.data?.occupationId);
    try {
      occupationList.removeWhere((element) => element.id != getProfileModelGlobal.data?.occupationId);
      selectOccupation.value = occupationList[occupationList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.occupationId)];
    } catch (e) {}

    try {
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

    try {
      CityListModel companyCity = companyCityList.firstWhere((element) => element.id == getProfileModelGlobal.data?.companyCityId);
      selectCompanyCity.value = companyCity;
    } catch (e) {
      print(e);
    }

    try {
      DistrictList companyDistrict = companyDistrictList.firstWhere((element) => element.id == getProfileModelGlobal.data?.companyDistrictId);
      selectCompanyDistrict.value = companyDistrict;
    } catch (e) {
      print(e);
    }

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
    inceptionDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
    expiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(initialDate.value)).add(const Duration(days: 364)).toString())));

    isLoading.value = false;
  }

  getCityMethod(context) async {
    try {
      cityList.clear();
      companyCityList.clear();
      await adminBasicAllApiController.getCityApi(context/*,city: getProfileModelGlobal.data?.nationalityId.toString()??'0'*/);
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

  getVehicleTypeMethod(context) async {
    try {
      vehicleTypeList.clear();
      await adminBasicAllApiController.getVehicleTypeApi(context);
      vehicleTypeList.addAll(adminBasicAllApiController.getVehicleTypeModelClass.value.data ?? []);
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

  getVehicleBrandMethod(context) async {
    try {
      vehicleBrandList.clear();

      await adminBasicAllApiController.getVehicleBrandApi(context);
      vehicleBrandList.addAll(adminBasicAllApiController.getVehicleBrandModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getVehicleCategoryApi(context, String id) async {
    try {
      isLoadingVehicleCategory.value = true;
      vehicleTypeListCategory.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getVehicleCategory$id", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getVehicleCategoryModel.value = GetVehicleCategoryModel.fromJson(response);
        vehicleTypeListCategory.addAll(getVehicleCategoryModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: AppText(
          text: response[messageKey].toString(),
          txtColor: primaryWhite,
          size: 12,
        )));
      }
      isLoadingVehicleCategory.value = false;
    } on DioError catch (e) {
      isLoadingVehicleCategory.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: e.response!.statusMessage!,
        txtColor: primaryWhite,
        size: 12,
      )));
    } catch (f) {
      isLoadingVehicleCategory.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: "$f",
        txtColor: primaryWhite,
        size: 12,
      )));
    }
  }

  getVehicleColorMethod(context) async {
    try {
      vehicleColorList.clear();

      await adminBasicAllApiController.getVehicleColorApi(context);
      vehicleColorList.addAll(adminBasicAllApiController.getVehicleColorModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getEngineTypeMethod(context) async {
    try {
      engineTypeList.clear();

      await adminBasicAllApiController.getEngineTypeApi(context);
      engineTypeList.addAll(adminBasicAllApiController.getEngineTypeModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  /* getMotorPlaneMethod(context) async {
    try {
      motorPlaneList.clear();

      await adminBasicAllApiController.getMotorPlanApi(context);
      motorPlaneList.addAll(adminBasicAllApiController.getMotorPlanModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }*/

  getNationality(context) async {
    try {
      nationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getMotorInsuranceApis(context, String planName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    isLoadingInsurancePlan.value = true;
    if (planName.isNotEmpty) {
      if (planName == comprehensivePlan) {
        await getMotorCommonPlanApi(context, getComprehensivePlan);
      } else if (planName == compulsory3MonthsPlan) {
        await getMotorCommonPlanApi(context, getCompulsory3MonthsPlan);
      } else if (planName == compulsory6MonthsPlan) {
        await getMotorCommonPlanApi(context, getCompulsory6MonthsPlan);
      } else if (planName == compulsory9MonthsPlan) {
        await getMotorCommonPlanApi(context, getCompulsory9MonthsPlan);
      } else if (planName == compulsory12MonthsPlan) {
        await getMotorCommonPlanApi(context, getCompulsory12MonthsPlan);
      } else if (planName == totalLossPlan) {
        await getMotorCommonPlanApi(context, getTotalLossPlan);
      }
    }
    isLoadingInsurancePlan.value = false;
  }

  getMotorCommonPlanApi(context, String apiUrl) async {
    try {
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
