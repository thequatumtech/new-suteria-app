import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/admin_basic_all_api_controller/all_api_controller.dart';
import 'package:soperia_user/Screens/HomeScreen/policy_pdf.dart';
import 'package:soperia_user/Screens/InsuranceScrees/insurance_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_discount_amount_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

class DraftPdfController extends GetxController {
  RxBool isButtonLoading = false.obs;
  RxBool isLoadingStoreTransaction = false.obs;
  final repo = getIt.get<ApiCall>();
  Rx<PostInsuranceModel> postInsuranceModel = PostInsuranceModel().obs;
  Rx<GetCountryList> selectCountry = GetCountryList().obs;
  RxList<GetCountryList> countryList = <GetCountryList>[].obs;
  AdminBasicAllApiController adminBasicAllApiController = Get.put(AdminBasicAllApiController());
  Rx<CityListModel> selectCity = CityListModel().obs;
  RxList<CityListModel> cityList = <CityListModel>[].obs;
  Rx<DistrictList> selectDistrict = DistrictList().obs;
  RxList<DistrictList> districtList = <DistrictList>[].obs;



  RxString statusCodeapp=''.obs;
  RxString statusMsg=''.obs;

  apiMethod(context) async {
    couponCodeController.value.clear();
    isApplyCoupon.value = false;
    getDiscountAmountModel.value = GetDiscountAmountModel();
    getCountryMethod(context);
    getCityMethod(context);
    getDistrictMethod(context);
  }

  getDistrictMethod(context) async {
    try {
      districtList.clear();
      await adminBasicAllApiController.getDistrictApi(context);
      districtList.addAll(adminBasicAllApiController.getDistrictModelClass.value.data ?? []);
      if (districtList.isNotEmpty) {
        districtList.removeWhere((element) => element.id != getProfileModelGlobal.data?.districtId);
        selectDistrict.value = districtList.first;
      }
    } on DioError catch (e) {
    } catch (f) {}
  }

  getCountryMethod(context) async {
    try {
      countryList.clear();
      await adminBasicAllApiController.getCountryApi(context);
      countryList.addAll(adminBasicAllApiController.getCountryModelClass.value.data ?? []);

      if (countryList.isNotEmpty) {
        countryList.removeWhere((element) => element.id != getProfileModelGlobal.data?.countryId);
        countryList.isNotEmpty ? selectCountry.value = countryList[countryList.indexWhere((p0) => p0.id == getProfileModelGlobal.data?.countryId)] : '';
      }
    } on DioError catch (e) {
    } catch (f) {}
  }

  getCityMethod(context) async {
    try {
      cityList.clear();
      await adminBasicAllApiController.getCityApi(context);
      cityList.addAll(adminBasicAllApiController.getCityModelClass.value.data ?? []);
      if (cityList.isNotEmpty) {
        cityList.removeWhere((element) => element.id != getProfileModelGlobal.data?.cityId);
        selectCity.value = cityList.first;
      }
    } on DioError catch (e) {
    } catch (f) {}
  }

  postInsuranceApi(context, Map<String, dynamic> data, String apiUrl) async {
    isButtonLoading.value = true;
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: apiUrl, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        postInsuranceModel.value = PostInsuranceModel.fromJson(response);
        statusCodeapp.value=postInsuranceModel.value.statusCode.toString();
        statusMsg.value=postInsuranceModel.value.message.toString();
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      } else {
        statusCodeapp.value=response[statusCode].toString();
        statusMsg.value=response[messageKey].toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isButtonLoading.value = false;
    } on DioError catch (e) {
      isButtonLoading.value = false;
      print(e.response);
       statusCodeapp.value=e.response?.statusCode.toString()??'';
       statusMsg.value=e.response?.data?["message"]?.toString() ?? '';
      /*postInsuranceModel.value = PostInsuranceModel.fromJson(e.response as Map<String, dynamic>);*/
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      print(f);
      isButtonLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  addStoreTransactionApi(context, String screenTitle, String pdfUrl, var paymentData) async {
    isLoadingStoreTransaction.value = true;
    try {
      var tranData = (paymentData is Map && paymentData.containsKey('data')) ? paymentData['data'] : paymentData;

      InsurancePdfController insurancePdfController = Get.put(InsurancePdfController());

      // Upload signature after payment is accepted/successful
      if (insurancePdfController.signatureBytes.value != null && insurancePdfController.signatureUrl.value.isEmpty) {
        final purchasePolicyId = postInsuranceModel.value.data?.purchasePolicyId ??
            postInsuranceModel.value.data?.purchaseId ??
            postInsuranceModel.value.data?.id ??
            0;
        final clientId = postInsuranceModel.value.data?.clientId ?? getProfileModelGlobal.data?.id ?? 0;

        await insurancePdfController.uploadSignatureApi(
          context: context,
          pngBytes: insurancePdfController.signatureBytes.value!,
          purchasePolicyId: purchasePolicyId,
          clientId: clientId,
        );
      }

      Map<String, dynamic> data = {
        'purchase_id': postInsuranceModel.value.data?.purchaseId ?? postInsuranceModel.value.data?.purchasePolicyId ?? 0,
        'transaction_id': tranData['transactionReference'] ?? '',
        'amount': tranData['tranTotal'] ?? tranData['cartAmount'] ?? tranData['tran_total'] ?? 0,
        'payment_type': tranData['paymentInfo']?['payment_method'] ?? tranData['paymentInfo']?['cardScheme'] ?? "Paytabs",
        'payment_status': (tranData['isSuccess'] == true) ? 1 : 0,
        'full_responce': jsonEncode(paymentData),
        'user_sign': insurancePdfController.signatureUrl.value,
      };
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: addStoreTransaction, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PolicyPdf(
              screenTitle: screenTitle,
              pdfUrl: pdfUrl,
              purchasePolicyId: postInsuranceModel.value.data?.purchasePolicyId ?? postInsuranceModel.value.data?.purchaseId ?? postInsuranceModel.value.data?.id,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingStoreTransaction.value = false;
    } on DioError catch (e) {
      isLoadingStoreTransaction.value = false;
      print(e.response);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      print(f);
      isLoadingStoreTransaction.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }

  /// Discount Screen
  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  RxBool isLoadingDiscountAmount = false.obs;
  Rx<GetDiscountAmountModel> getDiscountAmountModel = GetDiscountAmountModel().obs;
  RxBool isApplyCoupon = false.obs;

  getDiscountAmountApi(context) async {
    isLoadingDiscountAmount.value = true;
    try {
      Map<String, dynamic> data = {
        'purchase_id': postInsuranceModel.value.data!.purchaseId ?? 0,
        'coupon_id': "",
        'coupon_code': couponCodeController.value.text,
      };
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(context: context, endpoint: getDiscountAmount, body: (data), options: Options(headers: header));
      if (response[statusCode] == 200 || response[statusCode] == 201) {
        getDiscountAmountModel.value = GetDiscountAmountModel.fromJson(response);
        isApplyCoupon.value = true;
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: response[messageKey].toString(), txtColor: primaryWhite, size: 12)));
      }
      isLoadingDiscountAmount.value = false;
    } on DioError catch (e) {
      isLoadingDiscountAmount.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: e.response!.statusMessage!, txtColor: primaryWhite, size: 12)));
    } catch (f) {
      isLoadingDiscountAmount.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "$f", txtColor: primaryWhite, size: 12)));
    }
  }
}
