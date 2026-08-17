import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_geographical_area_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insuranceLimitPlanModel.dart';

class TravelInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> effectiveDateController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;
  Rx<TextEditingController> noOfDaysController = TextEditingController().obs;

  RxList<TextEditingController> memberFirstNameController = <TextEditingController>[TextEditingController()].obs;
  RxList<TextEditingController> memberSecondNameController = <TextEditingController>[TextEditingController()].obs;
  RxList<TextEditingController> memberThirdNameController = <TextEditingController>[TextEditingController()].obs;
  RxList<TextEditingController> memberFamilyNameController = <TextEditingController>[TextEditingController()].obs;
  RxList<TextEditingController> memberNationPassportNoController = <TextEditingController>[TextEditingController()].obs;
  RxList<TextEditingController> memberIdOrResidenceNoController = <TextEditingController>[TextEditingController()].obs;
  RxList<TextEditingController> memberBirthDateController = <TextEditingController>[TextEditingController()].obs;
  RxList<String> selectMemberGender = [male].obs;
  RxList<String> selectedRelation = [wife].obs;
  RxList<GetCountryList> memberSelectPlaceResidence = <GetCountryList>[GetCountryList()].obs;

  RxBool isSelfType = true.obs;

  // RxInt addDetails = 0.obs;
  String? selectedGender;
  String? selectedMaritalStatus;

  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

  // Rx<GetGeographicalAreaList> selectGeographicalArea = GetGeographicalAreaList().obs;
  // RxList<GetGeographicalAreaList> geoGraphicalAreaList = <GetGeographicalAreaList>[].obs;
  RxBool isLoading = false.obs;
  List<String> genderList = [];
  List<String> maritalStatusList = [];
  Rx<GetCountryList> selectPlaceResidence = GetCountryList().obs;
  RxList<GetCountryList> placeResidenceList = <GetCountryList>[].obs;

  RxBool isLoadingPassport = false.obs;
  RxBool isLoadingMembers = false.obs;
  final picker = ImagePicker();
  RxList<String> selectedPassport = <String>[].obs;
  RxList<List<String>> selectedMembers = <List<String>>[].obs;

  final repo = getIt.get<ApiCall>();
  Rx<InsuranceLimitPlanModel> insuranceLimitModel = InsuranceLimitPlanModel().obs;
  Rx<InsurancePlanName> selectedInsurancePlan = InsurancePlanName().obs;
  RxList<InsurancePlanName> insurancePlanList = <InsurancePlanName>[].obs;

  Rx<GetCountryList> selectDepartureFrom = GetCountryList().obs;
  RxList<GetCountryList> departureFromList = <GetCountryList>[].obs;

  Rx<GetCountryList> selectDestination = GetCountryList().obs;
  RxList<GetCountryList> destinationList = <GetCountryList>[].obs;

  Rx<GetCountryList> selectAdditionalDestination = GetCountryList().obs;
  RxList<GetCountryList> additionalDestinationList = <GetCountryList>[].obs;
  RxList<GetCountryList> selectedMultiDestinationList = <GetCountryList>[].obs;

  String planDd = '';
  String insuranceLimit = '';
  RxBool isLoadingInsuranceLimit = false.obs;
  RxBool isLoadingInsurancePlan = false.obs;
  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;

  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;
  Rx<GetNationalityList> selectNationality = GetNationalityList().obs;

  RxList<GetNationalityList> getNationalityList = <GetNationalityList>[].obs;
  RxList<GetNationalityList> selectNationalityMember = <GetNationalityList>[GetNationalityList()].obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  String? selectedDangerousActivity;
  String? selectedMultipleCountry;
  RxList<GetDangerousActivitiesList> getDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;
  RxList<GetDangerousActivitiesList> selectedDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;

  void init(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await Future.wait(<Future>[
      getCountryMethod(context),
      getDangerousActivities(context),
      getNationality(context),
    ]);
    isLoading.value = false;
    await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 10);
      getInsuranceCurrentModel.value = adminBasicAllApiController.getInsuranceCurrentModel.value;
    } on DioError catch (e) {
      print(e);
    } catch (f) {
      print(f);
    }
  }

  clearData() {
    // addDetails.value = 0;
    memberFirstNameController.clear();
    memberSecondNameController.clear();
    memberThirdNameController.clear();
    memberFamilyNameController.clear();
    selectedRelation.clear();
    selectNationalityMember.clear();
    memberNationPassportNoController.clear();
    memberIdOrResidenceNoController.clear();
    memberBirthDateController.clear();
    selectMemberGender.clear();
    memberSelectPlaceResidence.clear();
    selectedMembers.clear();
    selectedDangerousActivitiesList.value = [];
    selectedMultiDestinationList.value = [];
    isSelfType.value = true;
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
    selectPlaceResidence.value = GetCountryList();
    selectedPassport.clear();
    selectDepartureFrom.value = GetCountryList();
    selectDestination.value = GetCountryList();
    selectAdditionalDestination.value = GetCountryList();
    // selectGeographicalArea.value = GetGeographicalAreaList();
    effectiveDateController.value.clear();
    noOfDaysController.value.clear();
    expiryDateController.value.clear();
    planDd = '';
  }

  setTextData() {
    // addDetails.value = 0;
    policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";
    nationPassportNoController.value.text = getProfileModelGlobal.data?.nationalIdNumber.toString() ?? "";
    idOrResidenceNoController.value.text = getProfileModelGlobal.data?.residenceIdNumber.toString() ?? "";
    birthDateController.value.text = commonDateFormat(getProfileModelGlobal.data?.birthDate.toString() ?? "");

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

    // placeResidenceList.contains((element) => element.id != getProfileModelGlobal.data?.residingCountryId);
    int index = placeResidenceList.indexWhere(
      (p0) => p0.id == getProfileModelGlobal.data?.residingCountryId,
    );

    if (index != -1) {
      selectPlaceResidence.value = placeResidenceList[index];
    } else {
      // Optional: handle fallback case
      selectPlaceResidence.value = placeResidenceList.first; // or null, or skip assignment
    }

    /*  placeResidenceList.contains((element) => element.id != getProfileModelGlobal.data?.residingCountryId);*/
    try {
      selectPlaceResidence.value = placeResidenceList[placeResidenceList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.residingCountryId)];
    } catch (e) {
      if (kDebugMode) {
        print("eeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrooooooooooooooorrrrrrrrrrrrrrr >>>>> $e");
      }
    }
    try {
      nationalityList.isEmpty ? '' : nationalityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.nationalityId);
      selectNationality.value = nationalityList.first;
    } catch (e) {}

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

    effectiveDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
  }

  getGeographicalAreaApiMethod(context) async {
    try {
      // geoGraphicalAreaList.clear();
      // await adminBasicAllApiController.getGeographicalAreaApi(context);
      // geoGraphicalAreaList.addAll(adminBasicAllApiController.getGeographicalAreaModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getNationality(context) async {
    try {
      nationalityList.clear();
      getNationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      nationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
      getNationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getCountryMethod(context) async {
    try {
      placeResidenceList.clear();
      departureFromList.clear();
      destinationList.clear();
      additionalDestinationList.clear();
      // countryList.clear();
      await adminBasicAllApiController.getCountryApi(context);
      // countryList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      placeResidenceList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      departureFromList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      destinationList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      additionalDestinationList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getInsuranceLimit(context, String id, {int? destinationCountryId}) async {
    try {
      isLoadingInsuranceLimit.value = true;
      insurancePlanList.clear();
      selectedInsurancePlan.value = InsurancePlanName();

      String endpoint = "$insuranceLimitUrl$id";
      if (destinationCountryId != null && destinationCountryId != 0) {
        endpoint += "&destination_country_id=$destinationCountryId";
      }

      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: endpoint, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        insuranceLimitModel.value = InsuranceLimitPlanModel.fromJson(response);
        insurancePlanList.addAll(insuranceLimitModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response?.statusMessage ?? e.message ?? '', txtColor: primaryWhite, size: 12)));
    } catch (f) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    } finally {
      isLoadingInsuranceLimit.value = false;
    }
  }

  getHomeInsurancePlanApi(context, String planName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoadingInsurancePlan.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getTravelInsurancePlan$planName", options: Options(headers: header));
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
