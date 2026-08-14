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
import 'package:soperia_user/model_class/get_item_category_model.dart';
import 'package:soperia_user/model_class/get_item_subcategory_model.dart';
import 'package:soperia_user/model_class/get_type_cover_model.dart';
import 'package:soperia_user/model_class/home_Insurance_plan_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class MarineInsuranceController extends GetxController {
  Rx<TextEditingController> policyHolderFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> policyHolderFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationalityController = TextEditingController().obs;
  Rx<TextEditingController> nationPassportNoController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNoController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> companyRegisterNationalIdNoController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> companyRegisterNoController = TextEditingController().obs;
  Rx<TextEditingController> effectiveDateController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;
  Rx<TextEditingController> streetNameController = TextEditingController().obs;
  Rx<TextEditingController> buildingNoController = TextEditingController().obs;
  Rx<TextEditingController> officeNoController = TextEditingController().obs;
  Rx<TextEditingController> companyTelephoneNoController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerSecondNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerThirdNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerFamilyNameController = TextEditingController().obs;
  Rx<TextEditingController> companyOwnerTelephoneNoController = TextEditingController().obs;
  Rx<TextEditingController> billNoOrLadingNoController = TextEditingController().obs;
  Rx<TextEditingController> noOfInsuredItemController = TextEditingController().obs;
  Rx<TextEditingController> authorizedPositionController = TextEditingController().obs;
  Rx<TextEditingController> nameOfInsuranceCompanyAndExpiryController = TextEditingController().obs;
  Rx<TextEditingController> whyAnInsuranceCompanyDeclinedToIssueController = TextEditingController().obs;
  Rx<TextEditingController> writeInDetailsClaimAccidentController = TextEditingController().obs;
  RxBool individual = true.obs;

  String? selectedGender;
  String? selectTypeTransportation;
  String? selectedPartnerInTheCompanyOption;
  String? selectedAuthorizedToIssueInsurancePolicyOption;
  String? selectedCompanyRegistrationOption;
  String? selectedInsuranceCompanyDeclinedToIssueOption;
  String? selectedClaimsAccidentsInPastYearOption;
  String? selectedExistingInsurancePolicyOption;
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

  Rx<CityListModel> selectCompanyCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;

  Rx<DistrictList> selectCompanyDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;

  Rx<GetCountryList> selectCompanyCountry = GetCountryList().obs;
  RxList<GetCountryList> countryList = <GetCountryList>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingItemSubcategory = false.obs;
  List<String> genderList = [];

  RxBool isLoadingDocuments = false.obs;
  RxBool isLoadingBillOfLadingDocuments = false.obs;
  RxBool isLoadingCopyOfInvoice = false.obs;
  RxBool isLoadingInsuredsId = false.obs;
  RxBool isLoadingPolicyIssuerAuthorization = false.obs;
  RxBool isLoadingCompanyRegistrationOwnership = false.obs;
  RxBool isLoadingCareerMunicipalityLicense = false.obs;
  RxBool isLoadingCompanyTaxCertificate = false.obs;
  RxBool isLoadingPracticeCertificate = false.obs;

  final picker = ImagePicker();
  RxList<String> selectedDocuments = <String>[].obs;
  RxList<String> selectedBillOfLadingDocuments = <String>[].obs;
  RxList<String> selectedCopyOfInvoice = <String>[].obs;
  RxList<String> selectedInsuredsId = <String>[].obs;
  RxList<String> selectedPolicyIssuerAuthorization = <String>[].obs;
  RxList<String> selectedCompanyRegistrationOwnership = <String>[].obs;
  RxList<String> selectedCareerMunicipalityLicense = <String>[].obs;
  RxList<String> selectedCompanyTaxCertificate = <String>[].obs;
  RxList<String> selectedPracticeCertificate = <String>[].obs;

  Rx<GetCountryList> selectVoyage = GetCountryList().obs;
  RxList<GetCountryList> voyageList = <GetCountryList>[].obs;

  Rx<GetCountryList> selectThroughCountry = GetCountryList().obs;
  RxList<GetCountryList> throughCountryList = <GetCountryList>[].obs;

  String? selectedDangerousActivity;

 /* RxList<GetDangerousActivitiesList> getDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;
  RxList<GetDangerousActivitiesList> selectedDangerousActivitiesList = <GetDangerousActivitiesList>[].obs;*/
  Rx<TextEditingController> dangerousGoodsController = TextEditingController().obs;

  Rx<GetCountryList> selectFinalDestinationCountry = GetCountryList().obs;
  RxList<GetCountryList> finalDestinationCountryList = <GetCountryList>[].obs;

  Rx<InsuranceLimitListData> selectedInsuranceLimit = InsuranceLimitListData().obs;
  RxList<InsuranceLimitListData> insuranceLimitList = <InsuranceLimitListData>[].obs;
  Rx<InsuranceLimitModel> insuranceLimitModel = InsuranceLimitModel().obs;
  final repo = getIt.get<ApiCall>();

  String planDd = '';
  String insuranceLimit = '';
  Rx<HomeInsurancePlaneModel> homeInsurancePlaneModel = HomeInsurancePlaneModel().obs;
  RxBool isLoadingInsurancePlan = false.obs;

  String? selectedMultipleCountry;

  RxList<GetCountryList> additionalDestinationList = <GetCountryList>[].obs;
  RxList<GetCountryList> selectedMultiDestinationList = <GetCountryList>[].obs;

  Rx<ItemCategory> selectedItemCategory = ItemCategory().obs;
  RxList<ItemCategory> itemCategoryList = <ItemCategory>[].obs;
  Rx<GetItemCategoryModel> getItemCategoryModel = GetItemCategoryModel().obs;

  Rx<ItemSubcategory> selectedItemSubcategory = ItemSubcategory().obs;
  RxList<ItemSubcategory> itemSubcategoryList = <ItemSubcategory>[].obs;
  Rx<GetItemSubcategoryModel> getItemSubcategoryModel = GetItemSubcategoryModel().obs;

  Rx<TypeCover> selectedTypeCover = TypeCover().obs;
  RxList<TypeCover> typeCoverList = <TypeCover>[].obs;
  Rx<GetTypeCoverModel> getTypeCoverModel = GetTypeCoverModel().obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;

  void init(context) async {
    isLoading.value = true;
    await getInsuranceCurrent(context);
    await Future.wait(<Future>[
      getCountryMethod(context),
      getItemCategoryApi(context),
      getTypeCoverApi(context),
    ]);
    await setTextData();
    isLoading.value = false;
  }

  getInsuranceCurrent(context) async {
    try {
      await adminBasicAllApiController.getInsuranceCurrentApi(context, 11);
      getInsuranceCurrentModel.value = adminBasicAllApiController.getInsuranceCurrentModel.value;
    } on DioError catch (e) {
      print(e);
    } catch (f) {
      print(f);
    }
  }

  clearData() async {
    individual.value = true;
    policyHolderFirstNameController.value.clear();
    policyHolderSecondNameController.value.clear();
    policyHolderThirdNameController.value.clear();
    policyHolderFamilyNameController.value.clear();
    nationPassportNoController.value.clear();
    dangerousGoodsController.value.clear();
    idOrResidenceNoController.value.clear();
    birthDateController.value.clear();
    selectedGender = null;
    companyNameController.value.clear();
    companyRegisterNationalIdNoController.value.clear();
    companyRegisterNoController.value.clear();
    selectCompanyCountry.value = GetCountryList();
    selectCompanyCity.value = CityListModel();
    selectCompanyDistrict.value = DistrictList();
    streetNameController.value.clear();
    buildingNoController.value.clear();
    officeNoController.value.clear();
    companyTelephoneNoController.value.clear();
    companyOwnerFirstNameController.value.clear();
    companyOwnerSecondNameController.value.clear();
    companyOwnerThirdNameController.value.clear();
    companyOwnerFamilyNameController.value.clear();
    companyOwnerTelephoneNoController.value.clear();
    selectedPartnerInTheCompanyOption = null;
    selectedAuthorizedToIssueInsurancePolicyOption = null;
    authorizedPositionController.value.clear();
    selectedCompanyRegistrationOption = null;
    selectedDocuments.clear();
    selectVoyage.value = GetCountryList();
    selectThroughCountry.value = GetCountryList();
    selectFinalDestinationCountry.value = GetCountryList();
    selectedMultipleCountry = null;
    selectedMultiDestinationList.clear();
    selectTypeTransportation = null;
    selectedTypeCover.value = TypeCover();
    selectedItemCategory.value = ItemCategory();
    selectedItemSubcategory.value = ItemSubcategory();
    selectedInsuranceLimit.value = InsuranceLimitListData();
    billNoOrLadingNoController.value.clear();
    effectiveDateController.value.clear();
    expiryDateController.value.clear();
    noOfInsuredItemController.value.clear();
    selectedExistingInsurancePolicyOption = null;
    nameOfInsuranceCompanyAndExpiryController.value.clear();
    selectedInsuranceCompanyDeclinedToIssueOption = null;
    whyAnInsuranceCompanyDeclinedToIssueController.value.clear();
    selectedClaimsAccidentsInPastYearOption = null;
    writeInDetailsClaimAccidentController.value.clear();
    selectedBillOfLadingDocuments.clear();
    selectedCopyOfInvoice.clear();
    selectedInsuredsId.clear();
    selectedPolicyIssuerAuthorization.clear();
    selectedCompanyRegistrationOwnership.clear();
    selectedCareerMunicipalityLicense.clear();
    selectedCompanyTaxCertificate.clear();
    selectedPracticeCertificate.clear();
    planDd = '';
  }

  setTextData() {
    policyHolderFirstNameController.value.text = getProfileModelGlobal.data?.firstName ?? "";
    policyHolderSecondNameController.value.text = getProfileModelGlobal.data?.fatherName ?? "";
    policyHolderThirdNameController.value.text = getProfileModelGlobal.data?.grandfatherName ?? "";
    policyHolderFamilyNameController.value.text = getProfileModelGlobal.data?.surname ?? "";
    nationalityController.value.text = getProfileModelGlobal.data?.nationalityId.toString() ?? "";
    nationPassportNoController.value.text = getProfileModelGlobal.data?.nationalIdNumber.toString() ?? "";
    idOrResidenceNoController.value.text = getProfileModelGlobal.data?.residenceIdNumber.toString() ?? "";
    birthDateController.value.text = commonDateFormat(getProfileModelGlobal.data?.birthDate.toString() ?? "");

    genderList.clear();
    genderList.add(getProfileModelGlobal.data?.gender.toString() == "1" ? male : female ?? '');
    selectedGender = genderList.first;

    /*if (getInsuranceCurrentModel.value.data != null) {
      if (getInsuranceCurrentModel.value.data!.expiryDate != null) {
        initialDate.value = DateFormat('yyyy-MM-dd').parse(getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        initialDate.value = initialDate.value.add(const Duration(days: 1));
      } else {
        initialDate.value = DateTime.now();
      }
    } else {
      initialDate.value = DateTime.now();
    }*/
    effectiveDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(initialDate.value));
    updateExpiryDate();
  }

  void updateExpiryDate() {
    int days = 60;
    if (selectedInsuranceLimit.value.planName != null && selectedInsuranceLimit.value.planName!.isNotEmpty) {
      for (var plan in selectedInsuranceLimit.value.planName!) {
        if (plan.policyPeriod != null && plan.policyPeriod! > 0) {
          days = plan.policyPeriod!;
          break;
        }
      }
    }
    expiryDateController.value.text = commonDateFormat(
      DateFormat("yyyy-MM-dd").format(initialDate.value.add(Duration(days: days))),
    );
  }

  getCityMethod(context,String id) async {
    try {
      cityList.clear();
      await adminBasicAllApiController.getCityApi(context,city: id);
      cityList.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getDistrictMethod(context,String id) async {
    try {
      districtList.clear();
      await adminBasicAllApiController.getDistrictApi(context,id:id);
      districtList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getCountryMethod(context) async {
    try {
      countryList.clear();
      voyageList.clear();
      throughCountryList.clear();
      finalDestinationCountryList.clear();
      additionalDestinationList.clear();
      await adminBasicAllApiController.getCountryApi(context);
      countryList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      voyageList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      throughCountryList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      finalDestinationCountryList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
      additionalDestinationList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getInsuranceLimit(context, String id, int typeOfCover, int itemCategory, int itemSubcategory) async {
    try {
      isLoading.value = true;
      insuranceLimitList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$insuranceLimitUrl$id&type_of_cover=$typeOfCover&item_category=$itemCategory&item_subcategory=$itemSubcategory", options: Options(headers: header));
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

  getItemCategoryApi(context) async {
    try {
      itemCategoryList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getItemCategory, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getItemCategoryModel.value = GetItemCategoryModel.fromJson(response);
        itemCategoryList.addAll(getItemCategoryModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getItemSubcategoryApi(context, int id) async {
    try {
      isLoadingItemSubcategory.value = true;
      itemSubcategoryList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getItemSubcategory$id", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getItemSubcategoryModel.value = GetItemSubcategoryModel.fromJson(response);
        itemSubcategoryList.addAll(getItemSubcategoryModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingItemSubcategory.value = false;
    } on DioError catch (e) {
      isLoadingItemSubcategory.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingItemSubcategory.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  /*getDangerousActivities(context) async {
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
  }*/


  getTypeCoverApi(context) async {
    try {
      typeCoverList.clear();
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getTypeCover, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getTypeCoverModel.value = GetTypeCoverModel.fromJson(response);
        typeCoverList.addAll(getTypeCoverModel.value.data ?? []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  getMarineInsurancePlanApi(context, String planLimit) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      isLoadingInsurancePlan.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getMarineInsurancePlan$planLimit", options: Options(headers: header));
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
