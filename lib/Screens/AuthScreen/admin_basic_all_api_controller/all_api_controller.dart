import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/get_ages_model.dart';
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_claim_deductible_model.dart';
import 'package:soperia_user/model_class/get_complaint_status_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_currency_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_engine_capacity_model.dart';
import 'package:soperia_user/model_class/get_engine_type_model.dart';
import 'package:soperia_user/model_class/get_geographical_area_model.dart';
import 'package:soperia_user/model_class/get_in_patient_deductible_model.dart';
import 'package:soperia_user/model_class/get_insurance_current_model.dart';
import 'package:soperia_user/model_class/get_insurance_period_model.dart';
import 'package:soperia_user/model_class/get_insurance_type_model.dart';
import 'package:soperia_user/model_class/get_medical_network_model.dart';
import 'package:soperia_user/model_class/get_motor_plan_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_number_of_visit_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';
import 'package:soperia_user/model_class/get_out_patient_deductible_model.dart';
import 'package:soperia_user/model_class/get_protection_system_model.dart';
import 'package:soperia_user/model_class/get_vehicle_brand_model.dart';
import 'package:soperia_user/model_class/get_vehicle_color_model.dart';
import 'package:soperia_user/model_class/get_vehicle_type_model.dart';
import '../../../app_utils/api_set_up/header_file.dart';

class AdminBasicAllApiController extends GetxController {
  RxBool isLoading = false.obs;
  final repo = getIt.get<ApiCall>();

  Rx<GetAgesModelClass> getAgesModelClass = GetAgesModelClass().obs;
  Rx<GetChronicDiseaseModelClass> getChronicDiseaseModelClass = GetChronicDiseaseModelClass().obs;
  Rx<GetComplaintStatusModelClass> getComplaintStatusModelClass = GetComplaintStatusModelClass().obs;
  Rx<GetDangerousActivitiesModelClass> getDangerousActivitiesModelClass = GetDangerousActivitiesModelClass().obs;
  Rx<GetEngineCapacityModelClass> getEngineCapacityModelClass = GetEngineCapacityModelClass().obs;
  Rx<GetEngineTypeModelClass> getEngineTypeModelClass = GetEngineTypeModelClass().obs;
  Rx<GetInsurancePeriodModelClass> getInsurancePeriodModelClass = GetInsurancePeriodModelClass().obs;
  Rx<GetMedicalNetworkModelClass> getMedicalNetworkModelClass = GetMedicalNetworkModelClass().obs;
  Rx<GetMotorPlanModelClass> getMotorPlanModelClass = GetMotorPlanModelClass().obs;
  Rx<GetProtectionSystemModelClass> getProtectionSystemModelClass = GetProtectionSystemModelClass().obs;
  GetOccupationModelClass getOccupationModelClass = GetOccupationModelClass();
  Rx<GetInPatientDeductibleModelClass> getInPatientDeductibleModelClass = GetInPatientDeductibleModelClass().obs;
  Rx<GetOutPatientDeductibleModelClass> getOutPatientDeductibleModelClass = GetOutPatientDeductibleModelClass().obs;
  Rx<GetNumberOfVisitModelClass> getNumberOfVisitModelClass = GetNumberOfVisitModelClass().obs;
  Rx<GetClaimDeductibleModelClass> getClaimDeductibleModelClass = GetClaimDeductibleModelClass().obs;
  Rx<GetNationalityModelClass> getNationalityModelClass = GetNationalityModelClass().obs;
  Rx<GetCurrencyModelClass> getCurrencyModelClass = GetCurrencyModelClass().obs;
  // Rx<GetGeographicalAreaModelClass> getGeographicalAreaModelClass = GetGeographicalAreaModelClass().obs;
  Rx<GetVehicleBrandModelClass> getVehicleBrandModelClass = GetVehicleBrandModelClass().obs;
  Rx<GetVehicleColorModelClass> getVehicleColorModelClass = GetVehicleColorModelClass().obs;
  Rx<GetVehicleTypeModelClass> getVehicleTypeModelClass = GetVehicleTypeModelClass().obs;
  Rx<GetCityModelClass> getCityModelClass = GetCityModelClass().obs;
  Rx<GetDistrictModelClass> getDistrictModelClass = GetDistrictModelClass().obs;
  Rx<GetCountryModelClass> getCountryModelClass = GetCountryModelClass().obs;
  Rx<GetInsuranceTypeModel> getInsuranceTypeModel = GetInsuranceTypeModel().obs;
  Rx<GetInsuranceCurrentModel> getInsuranceCurrentModel = GetInsuranceCurrentModel().obs;

  getAgesApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getAges, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getAgesModelClass.value = GetAgesModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getChronicDiseaseApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getChronicDisease, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getChronicDiseaseModelClass.value = GetChronicDiseaseModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getComplaintStatusApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getComplaintStatus, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getComplaintStatusModelClass.value = GetComplaintStatusModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getDangerousActivitiesApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getDangerousActivities, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getDangerousActivitiesModelClass.value = GetDangerousActivitiesModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getEngineCapacityApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getEngineCapacity, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getEngineCapacityModelClass.value = GetEngineCapacityModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getEngineTypeApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getEngineType, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getEngineTypeModelClass.value = GetEngineTypeModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getInsurancePeriodApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getInsurancePeriod, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getInsurancePeriodModelClass.value = GetInsurancePeriodModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getMedicalNetworkApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getMedicalNetwork, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getMedicalNetworkModelClass.value = GetMedicalNetworkModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getMotorPlanApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getMotorPlan, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getMotorPlanModelClass.value = GetMotorPlanModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getProtectionSystemApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getProtectionSystem, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getProtectionSystemModelClass.value = GetProtectionSystemModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getOccupationApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getOccupation, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getOccupationModelClass = GetOccupationModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getInPatientDeductibleApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getInPatientDeductible, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getInPatientDeductibleModelClass.value = GetInPatientDeductibleModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getOutPatientDeducibleApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getOutPatientDeductible, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getOutPatientDeductibleModelClass.value = GetOutPatientDeductibleModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getNumberOfVisitApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getNumberOfVisit, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getNumberOfVisitModelClass.value = GetNumberOfVisitModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getClaimDeducibleApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getClaimDeductible, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getClaimDeductibleModelClass.value = GetClaimDeductibleModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getNationalityApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getNationality, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getNationalityModelClass.value = GetNationalityModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getCurrencyApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getCurrency, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getCurrencyModelClass.value = GetCurrencyModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

 /* getGeographicalAreaApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getGeographicalArea, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getGeographicalAreaModelClass.value = GetGeographicalAreaModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }*/

  getVehicleBrandApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getVehicleBrand, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getVehicleBrandModelClass.value = GetVehicleBrandModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getVehicleColorApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getVehicleColor, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getVehicleColorModelClass.value = GetVehicleColorModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getVehicleTypeApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getVehicleType, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getVehicleTypeModelClass.value = GetVehicleTypeModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getCityApi(context,{String? city=''}) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "${getCity}?country_id=$city", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getCityModelClass.value = GetCityModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getInsuranceCurrentApi(context,int type) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: '$insuranceCurrent$type', options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getInsuranceCurrentModel.value = GetInsuranceCurrentModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getInsuranceTypeApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getInsuranceType, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getInsuranceTypeModel.value = GetInsuranceTypeModel.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

  getDistrictApi(context, {String? id=''}) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: "$getDistrict?city_id=$id", options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getDistrictModelClass.value = GetDistrictModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }


  getCountryApi(context) async {
    try {
      isLoading.value = true;
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(context: context, endpoint: getCountry, options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getCountryModelClass.value = GetCountryModelClass.fromJson(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:response[messageKey].toString(), txtColor: primaryWhite, size: 12,)));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12,)));
    } catch (f) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12,)));
    }
  }

}