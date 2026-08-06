import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/Screens/AuthScreen/AuthController/auth_controller.dart';
import 'package:soperia_user/Screens/AuthScreen/account_created.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/Screens/AuthScreen/otp_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custome.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

import 'otp_screen_singup.dart';
import 'package:dio/dio.dart' as m;

class SignUpController extends GetxController {
  String? selectedGender;
  String? selectedMaritalStatus;
  String? selectLanguage;
  RxList<String> languages = [arbic, english].obs;
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
  Rx<TextEditingController> streetController = TextEditingController().obs;
  Rx<TextEditingController> buildingController = TextEditingController().obs;
  Rx<TextEditingController> companyController = TextEditingController().obs;
  Rx<TextEditingController> workNatureController = TextEditingController().obs;
  Rx<TextEditingController> companyStreetNameController = TextEditingController().obs;
  Rx<TextEditingController> companyBuildingNoController = TextEditingController().obs;
  Rx<TextEditingController> companyContactNoController = TextEditingController().obs;
  Rx<TextEditingController> agentNoController = TextEditingController().obs;

  bool check = false;
  bool check2 = false;
  bool isEng = true;

  RxBool buttonLoading = false.obs;

  final repo = getIt.get<ApiCall>();

  TextEditingController password = TextEditingController();
  TextEditingController conformPassword = TextEditingController();

  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());

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

  Rx<GetNationalityList> selectNationality = GetNationalityList().obs;
  RxList<GetNationalityList> nationalityList = <GetNationalityList>[].obs;
  Rx<GetCountryList> selectResidency = GetCountryList().obs;
  RxList<GetCountryList> residencyList = <GetCountryList>[].obs;

  Rx<OccuptionList> selectOccupation = OccuptionList().obs;
  RxList<OccuptionList> occupationList = <OccuptionList>[].obs;

  Rx<OccuptionList> selectPosition = OccuptionList().obs;
  RxList<OccuptionList> positionList = <OccuptionList>[].obs;

  File residenceCardFont = File("");
  File residenceCardBack = File("");
  File personalPicDoc = File("");

  void init(context) {
    getCountryMethod(context);
    //
    getNationality(context);
    //  getDistrictMethod(context);
    getOccupations(context);
    //  getProtectionSystemMethod(context);
//    setDataTextField();
  }

  getCityMethod(context) async {
    try {
      cityList.clear();
      cityListCompany.clear();
      await adminBasicAllApiController.getCityApi(context, city: check ? selectCountry.value.id.toString() : selectResidency.value.id.toString());
      cityList.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
      cityListCompany.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
    } on DioError catch (e) {
    } catch (f) {}
  }

  getDistrictMethod(context) async {
    try {
      districtList.clear();
      districtListCompany.clear();
      await adminBasicAllApiController.getDistrictApi(context, id: selectCity.value.id.toString());
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

  getOccupations(context) async {
    try {
      occupationList.clear();
      positionList.clear();
      await adminBasicAllApiController.getOccupationApi(context);
      occupationList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
      positionList.addAll(adminBasicAllApiController.getOccupationModelClass.data ?? []);
      print(occupationList);
      print("occupationList >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    } on DioError catch (e) {
    } catch (f) {}
  }

  postSignUp(context) async {
    buttonLoading.value = true;
    try {
      Map<String, String> header = await getHeader();
      var response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: userRegister, options: Options(), body: {
        'first_name': firstNameController.value.text ?? '',
        'father_name': secondNameController.value.text ?? '',
        'grandfather_name': thirdNameController.value.text ?? '',
        'surname': familyNameController.value.text ?? '',
        'language': selectLanguage == "Arabic" ? "ar" : "en",
        'nationality_id': selectNationality.value.id,
        'national_id_number': nationOrPassportNumberController.value.text ?? '',
        'residence_id_number': idOrResidenceNumberController.value.text ?? '',
        'birth_date': commonApiDateFormat(birthDateController.value.text),
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
        'street_name': streetController.value.text ?? '',
        'building_no': buildingController.value.text ?? '',
        'employment_type': selectEmp ?? '',
        'company_name': companyController.value.text ?? '',
        'occupation_id': selectOccupation.value.id ?? 1,
        "position": selectPosition.value.name ?? '',
        'work_nature': workNatureController.value.text ?? '',
        'company_city_id': selectCityCompany.value.id ?? 1,
        'company_district_id': selectDistrictCompany.value.id ?? 1,
        'company_street_name': companyStreetNameController.value.text ?? '',
        'company_building_no': companyBuildingNoController.value.text ?? '',
        'company_contact_no': companyContactNoController.value.text ?? '',
        'id_front': await m.MultipartFile.fromFile(residenceCardFont.path),
        'id_back': await m.MultipartFile.fromFile(residenceCardBack.path),
        'profile_pic': await m.MultipartFile.fromFile(personalPicDoc.path),
        'agent_id': agentNoController.value.text ?? '',
        'no_of_policies': '1',
        'password': password.value.text
      });

      if (response["status_code"] == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(tokenKey, response[tokenKey]);
        showToast(successfullyRegister, context);
        buttonLoading.value = false;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountCreated()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response['message'], txtColor: primaryWhite, size: 12)));
      }

      buttonLoading.value = false;
    } catch (e) {
      buttonLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.toString(), txtColor: primaryWhite, size: 12)));
    }
  }

  clearData() {
    selectedGender = '';
    selectedMaritalStatus = '';
    selectLanguage = '';
    languages.clear();
    firstNameController.value.clear();
    secondNameController.value.clear();
    thirdNameController.value.clear();
    familyNameController.value.clear();
    nationOrPassportNumberController.value.clear();
    idOrResidenceNumberController.value.clear();
    birthDateController.value.clear();
    emailController.value.clear();
    mobileController.value.clear();
    selectEmp = '';
    streetController.value.clear();
    buildingController.value.clear();
    companyController.value.clear();
    workNatureController.value.clear();
    companyStreetNameController.value.clear();
    companyBuildingNoController.value.clear();
    companyContactNoController.value.clear();
    agentNoController.value.clear();
    password.clear();
    conformPassword.clear();
    selectDistrict.value = DistrictList();
    selectDistrictCompany.value = DistrictList();
    selectCountry.value = GetCountryList();
    selectCity.value = CityListModel();
    selectCityCompany.value = CityListModel();
    selectNationality.value = GetNationalityList();
    selectResidency.value = GetCountryList();
    selectOccupation.value = OccuptionList();
    selectPosition.value = OccuptionList();
    residenceCardFont = File("");
    residenceCardBack = File("");
    personalPicDoc = File("");
  }
}
