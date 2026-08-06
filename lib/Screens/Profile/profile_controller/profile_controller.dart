import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/Screens/Profile/Coupons/my_coupons_screen.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/review_my_claim_status_screen.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/my_policies_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_discount_coupons_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/get_profile_model.dart';
import '../../AuthScreen/select_language.dart';
import 'package:dio/dio.dart' as m;

class ProfileController extends GetxController {
/*  ProfileController profileController = Get.put(ProfileController());*/
  String? selectedNation;
  String? selectedGender;
  String? selectedMaritalStatus;
  String? selectLanguage;
  RxList<String> languages = ['English', 'Arbic'].obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> secondNameController = TextEditingController().obs;
  Rx<TextEditingController> thirdNameController = TextEditingController().obs;
  Rx<TextEditingController> familyNameController = TextEditingController().obs;
  Rx<TextEditingController> nationOrPassportNumberController = TextEditingController().obs;
  Rx<TextEditingController> idOrResidenceNumberController = TextEditingController().obs;
  Rx<TextEditingController> birthDateController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> mobileController = TextEditingController().obs;

  String? selectEmp;

  ///>>>>>>>>>>  Remove it

  Rx<TextEditingController> streetController = TextEditingController().obs;
  Rx<TextEditingController> buildingController = TextEditingController().obs;
  Rx<TextEditingController> companyController = TextEditingController().obs;

  // Rx<TextEditingController> positionController = TextEditingController().obs;
  Rx<TextEditingController> workNatureController = TextEditingController().obs;
  Rx<TextEditingController> companyStreetNameController = TextEditingController().obs;
  Rx<TextEditingController> companyBuildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyContactNoController = TextEditingController().obs;
  Rx<TextEditingController> agentNoController = TextEditingController().obs;

  bool check = false;
  RxBool isLoading = true.obs;
  RxBool isLoadingPost = false.obs;
  RxBool isNationLoading = false.obs;
  final repo = getIt.get<ApiCall>();
  Rx<GetProfileModel> getProfileModel = GetProfileModel().obs;
  RxList<GetNationalityList> getNationalityList = <GetNationalityList>[].obs;
  Rx<GetNationalityList> selectNationality = GetNationalityList().obs;
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

  RxBool isLogout = false.obs;
  RxList<String> menu = [
    mypolicies,
    myCoupons,
    myclaims,
    contactus,
    addcomplaints,
    changePass,
    socialPages,
    termsConditions,
    privacyPolicyTxt,
    logout,
  ].obs;

  RxList<dynamic> menuscreen = [
    const MyPolicies(),
    // const MyRewardsScreen(title: "My Rewards"),
     MyCouponsScreen(isApplyCoupon: false, insuranceType: ''),
    const ReviewMyClaimStatusScreen(),
  ].obs;

  RxList<String> icos = [
    mypoliceicon,
    rewardicon,
    myclaimsicon,
    contactUs,
    addComplints,
    changePassword,
    ourWebsite,
    privacyPolicy,
    termAndCondition,
    logouticon,
    logouticon,
  ].obs;

  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;
  Rx<DistrictList> selectDistrictCompany = DistrictList().obs;
  RxList<DistrictList> districtListCompany = <DistrictList>[].obs;

  Rx<GetCountryList> selectCountry = GetCountryList().obs;
  RxList<GetCountryList> countryList = <GetCountryList>[].obs;

  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;

  Rx<CityListModel> selectCityCompany = CityListModel().obs;
  RxList<CityListModel> cityListCompany = <CityListModel>[].obs;

  Rx<GetCountryList> selectResidency = GetCountryList().obs;
  RxList<GetCountryList> residencyList = <GetCountryList>[].obs;

  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;

  Rx<OccuptionList> selectPosition = OccuptionList().obs;
  RxList<OccuptionList> positionList = <OccuptionList>[].obs;

  RxBool isLoadingEdit = true.obs;
  File residenceCardFont = File("");
  File residenceCardBack = File("");
  File personalPicDoc = File("");

  RxString lang = "en".obs;
  RxString english = "en".obs;
  RxString arbic = "dr".obs;

  /* void changeLanguage(String lang,BuildContext context) async {
    languageCode = lang;
    await loadLangs();
    Locale locale = await setLocale(lang);
    MyApp.setLocale(context, locale);

  }*/

  init(context) async {
    isLoadingEdit.value = true;
    await clearData();
    /*await getCityMethod(context);*/
    await getCountryMethod(context);
    // getNationality(context);
   /* await getDistrictMethod(context);*/
    await getOccupations(context);
    await getNationality(context);
    await setProfileData(context);
    isLoadingEdit.value = false;
  }

  getProfile(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getProfileURL, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getProfileModel.value = GetProfileModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: AppText(
          text: response[messageKey].toString(),
          txtColor: primaryWhite,
          size: 12,
        )));
      }
      isLoading.value = false;
    } on DioException catch (e) {
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

  updateProfileApi(context) async {
    isLoadingPost.value = true;
    DateTime formate = DateFormat('dd/MM/yyyy').parse(birthDateController.value.text);
    String birthDate = DateFormat('yyyy-MM-dd').format(formate);
    try {
      Map<String, dynamic> data = {
        'id': getProfileModel.value.data!.id,
        'first_name': firstNameController.value.text,
        'father_name': secondNameController.value.text,
        'grandfather_name': thirdNameController.value.text,
        'surname': familyNameController.value.text,
        'language': selectLanguage == "Arabic" ? "ab" : "en",
        'nationality_id': selectNationality.value.id,
        'national_id_number': nationOrPassportNumberController.value.text ?? '',
        'residence_id_number': idOrResidenceNumberController.value.text ?? '',
        'birth_date': birthDate,
        'gender': selectedGender == male ? 1 : 2,
        'marital_status': selectedMaritalStatus == single
            ? 1
            : selectedMaritalStatus == married
                ? 2
                : selectedMaritalStatus == divorced
                    ? 3
                    : 4,
        'email_id': emailController.value.text ?? '',
        'mobile_no': int.parse(mobileController.value.text),
        'country_id': selectCountry.value.id,
        'residing_country_same': check == false ? 1 : 2,
        'residing_country_id': check ? selectCountry.value.id : selectResidency.value.id,
        'city_id': selectCity.value.id,
        'district_id': selectDistrict.value.id,
        'street_name': streetController.value.text,
        'building_no': buildingController.value.text,
        'employment_type': selectEmp ?? '',
        'company_name': companyController.value.text,
        'occupation_id': selectOccupation.value.id ?? 1,
        "position": selectPosition.value.name ?? '',
        'work_nature': workNatureController.value.text ?? '',
        'company_city_id': selectCityCompany.value.id ?? 0,
        'company_district_id': selectDistrictCompany.value.id ?? 0,
        'company_street_name': companyStreetNameController.value.text,
        'company_building_no': companyBuildingNoController.value.text,
        'company_contact_no': companyContactNoController.value.text,
        'agent_id': agentNoController.value.text ?? '',
        'no_of_policies': '1',
        // 'password': password.value.text
      };

      if (residenceCardFont.path.isNotEmpty) {
        data.addAll({'id_front': await m.MultipartFile.fromFile(residenceCardFont.path)});
      }
      if (residenceCardBack.path.isNotEmpty) {
        data.addAll({'id_back': await m.MultipartFile.fromFile(residenceCardBack.path)});
      }
      if (personalPicDoc.path.isNotEmpty) {
        data.addAll({'profile_pic': await m.MultipartFile.fromFile(personalPicDoc.path)});
      }

      Map<String, String> header = await getHeader();
      var response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: updateProfile, body: data, options: Options(headers: header));
      if (response["status_code"] == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response['message'], txtColor: primaryWhite, size: 12)));
        getProfile(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response['message'], txtColor: primaryWhite, size: 12)));
      }
      isLoadingPost.value = false;
    } catch (e) {
      isLoadingPost.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.toString(), txtColor: primaryWhite, size: 12)));
      print(e);
    }
  }

  setProfileData(context) async {
    try {
      isLoading.value = true;
      selectLanguage = getProfileModel.value.data?.language == 'en' ? "English" : "Arabic";
      firstNameController.value.text = getProfileModel.value.data?.firstName ?? "";
      secondNameController.value.text = getProfileModel.value.data?.fatherName ?? "";
      thirdNameController.value.text = getProfileModel.value.data?.grandfatherName ?? "";
      familyNameController.value.text = getProfileModel.value.data?.surname ?? "";
      // selectedNation = getProfileModel.value.data?.nationalityId;
      selectedGender = getProfileModel.value.data?.gender.toString() == "1" ? male : female ?? '';
      selectedMaritalStatus = getProfileModel.value.data?.maritalStatus.toString() == "1"
          ? single
          : getProfileModel.value.data?.maritalStatus.toString() == "2"
              ? married
              : getProfileModel.value.data?.maritalStatus.toString() == "3"
                  ? divorced
                  : widowed;

     /* selectNationality.value=profileController.getNationalityList.firstWhere((element) => element.id == getProfileModel.value.data?.nationalityId??'');*/
      nationOrPassportNumberController.value.text = getProfileModel.value.data?.nationalIdNumber ?? "";
      selectEmp = getProfileModel.value.data?.employmentType;
      idOrResidenceNumberController.value.text = getProfileModel.value.data?.residenceIdNumber ?? '';
      try {
        DateTime formate = DateFormat('yyyy-MM-dd').parse(getProfileModel.value.data?.birthDate ?? "");
        String birthDate = DateFormat('dd/MM/yyyy').format(formate);
        birthDateController.value.text = birthDate;
      } catch (e) {}

      emailController.value.text = getProfileModel.value.data?.emailId ?? "";
      mobileController.value.text = getProfileModel.value.data?.mobileNo ?? "";
      countryList.isNotEmpty ? selectCountry.value = countryList[countryList.indexWhere((p0) => p0.id == getProfileModel.value.data?.countryId)] : '';
      selectResidency.value = residencyList[residencyList.indexWhere((p0) => p0.id == getProfileModel.value.data?.residingCountryId)];

      await getCityMethod(context);

      try {
        selectCity.value = cityList[cityList.indexWhere((p0) => p0.id == getProfileModel.value.data?.cityId)];
      }
      catch(e){
        print(e);
      }
      await getDistrictMethod(context);

      selectDistrict.value = districtList[districtList.indexWhere((p0) => p0.id == getProfileModel.value.data?.districtId)];


      streetController.value.text = getProfileModel.value.data?.streetName ?? '';
      buildingController.value.text = getProfileModel.value.data?.buildingNo ?? '';
      companyController.value.text = getProfileModel.value.data?.companyName ?? '';
      workNatureController.value.text = getProfileModel.value.data?.workNature ?? '';
      companyStreetNameController.value.text = getProfileModel.value.data?.companyStreetName ?? '';
      companyBuildingNoController.value.text = getProfileModel.value.data?.companyBuildingNo ?? '';
      companyContactNoController.value.text = getProfileModel.value.data?.companyContactNo ?? '';
      agentNoController.value.text = (getProfileModel.value.data?.agentId != null ? getProfileModel.value.data?.agentId.toString() : '')!;

      try {
        GetNationalityList cdl = getNationalityList.firstWhere((element) => element.id == getProfileModel.value.data?.nationalityId);
        selectNationality.value = cdl;
      } catch (e) {
        print(e);
        isLoading.value = false;
      }
      try {
        OccuptionList cdl = occupationList.firstWhere((element) => element.id == getProfileModel.value.data?.occupationId);
        selectOccupation.value = cdl;
      } catch (e) {
        print(e);
        isLoading.value = false;
      }

      try {
        OccuptionList cdl = positionList.firstWhere((element) => element.name == getProfileModel.value.data?.position);
        selectPosition.value = cdl;
      } catch (e) {
        print(e);
        isLoading.value = false;
      }


      selectCityCompany.value = cityListCompany[cityListCompany.indexWhere((p0) => p0.id == getProfileModel.value.data?.companyCityId)];

      selectDistrictCompany.value = districtListCompany[districtListCompany.indexWhere((p0) => p0.id == getProfileModel.value.data?.companyDistrictId)];

    } catch (e) {
      print(e);
      isLoading.value = false;
    }

    isLoading.value = false;
  }

  clearData() {
    selectLanguage = '';
    firstNameController.value.clear();
    secondNameController.value.clear();
    thirdNameController.value.clear();
    familyNameController.value.clear();
    selectedGender = '';
    selectedMaritalStatus = '';
    nationOrPassportNumberController.value.clear();
    selectEmp = "";
    idOrResidenceNumberController.value.clear();
    birthDateController.value.clear();
    emailController.value.clear();
    mobileController.value.clear();
    selectCountry.value = GetCountryList();
    selectResidency.value = GetCountryList();
    selectCity.value = CityListModel();
    selectDistrict.value = DistrictList();
    selectCityCompany.value = CityListModel();
    selectDistrictCompany.value = DistrictList();
    streetController.value.clear();
    buildingController.value.clear();
    companyController.value.clear();
    workNatureController.value.clear();
    companyStreetNameController.value.clear();
    companyBuildingNoController.value.clear();
    companyContactNoController.value.clear();
    agentNoController.value.clear();
    selectNationality.value = GetNationalityList();
    selectOccupation.value = OccuptionList();
    selectPosition.value = OccuptionList();
    residenceCardFont = File("");
    residenceCardBack = File("");
    personalPicDoc = File("");
  }

  getNationality(context) async {
    try {
      getNationalityList.clear();
      await adminBasicAllApiController.getNationalityApi(context);
      getNationalityList.addAll(adminBasicAllApiController.getNationalityModelClass.value.data ?? []);
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

  getCityMethod(context) async {
    try {
      cityList.clear();
      cityListCompany.clear();
      await adminBasicAllApiController.getCityApi(context,city: check ? selectCountry.value.id.toString() : selectResidency.value.id.toString());
      cityList.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
      cityListCompany.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getDistrictMethod(context) async {
    try {
      districtList.clear();
      districtListCompany.clear();
      await adminBasicAllApiController.getDistrictApi(context,id: selectCity.value.id.toString());
      districtList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
      districtListCompany.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getCountryMethod(context) async {
    try {
      residencyList.clear();

      countryList.clear();
      await adminBasicAllApiController.getCountryApi(context);
      countryList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);

      residencyList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getOccupations(context) async {
    try {
      occupationList.clear();
      positionList.clear();
      await adminBasicAllApiController.getOccupationApi(context);
      occupationList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
      positionList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  logOutDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              backgroundColor: primarywhiteShade1,
              title: AppText(text: logout, txtColor: deepBlue, size: 20),
              content: AppText(text: areYouSureYouWantToLogout, txtColor: primaryBlack, size: 18),
              actions: [
                TextButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: AppText(text: noTxt, txtColor: deepBlue, size: 16),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: isLogout.value ? const CircularProgressIndicator() : AppText(text: yesTxt, txtColor: deepBlue, size: 16),
                    onPressed: () {
                      logoutApi(context);
                    }),
              ]);
        });
  }

  logoutApi(context) async {
    try {
      isLogout.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: logOutURL, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        SharedPreferences pre = await SharedPreferences.getInstance();
        print("token<<<<<<<$pre");
        pre.clear();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SelectLanguage()), (route) => false);
        isLogout.value = false;
      } else {
        isLogout.value = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: AppText(
          text: response[messageKey].toString(),
          txtColor: primaryWhite,
          size: 12,
        )));
        // customSnackBar(context, response[messageKey].toString(), AnimatedSnackBarType.error);
      }
      isLogout.value = false;
    } on DioError catch (e) {
      isLogout.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: e.response!.statusMessage!,
        txtColor: primaryWhite,
        size: 12,
      )));
      // customSnackBar(context, e.response!.statusMessage!, AnimatedSnackBarType.error);
    } catch (f) {
      isLogout.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AppText(
        text: "$f",
        txtColor: primaryWhite,
        size: 12,
      )));
      // customSnackBar(context, "$f", AnimatedSnackBarType.error);
    }
  }

  /// My Coupons Screen
  RxBool isLoadingDiscountCoupons = true.obs;
  Rx<GetDiscountCouponsModel> getDiscountCouponsModel = GetDiscountCouponsModel().obs;

  getDiscountCouponsApi(context) async {
    try {
      isLoadingDiscountCoupons.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getDiscountCoupons, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getDiscountCouponsModel.value = GetDiscountCouponsModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingDiscountCoupons.value = false;
    } on DioException catch (e) {
      isLoadingDiscountCoupons.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingDiscountCoupons.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }
}
