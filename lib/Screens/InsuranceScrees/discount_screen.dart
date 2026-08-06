import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/Profile/Coupons/my_coupons_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/Screens/InsuranceScrees/insurance_pdf_controller.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'dart:async';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:soperia_user/model_class/get_discount_amount_model.dart';

class DiscountScreen extends StatefulWidget {
  String screenTitle;
  String insuranceType;

  DiscountScreen({super.key, required this.insuranceType, required this.screenTitle});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  InsurancePdfController insurancePdfController = Get.put(InsurancePdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.keyboard_backspace_outlined)),
        title: Row(
          children: [
            AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
            /*  const Spacer(),
            InkWell(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCouponsScreen()));
                if (draftPdfController.couponCodeController.value.text.isNotEmpty) {
                  draftPdfController.getDiscountAmountApi(context, widget.screenTitle);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(color: gold), borderRadius: BorderRadius.circular(10)),
                child:  AppText(
                  text: viewCoupons,
                  size: 13,
                  txtColor: deepBluedark,
                  fontWeight: FontWeight.bold,
                  txtAlign: TextAlign.start,
                ),
              ),
            )*/
          ],
        ),
      ),
      body: Obx(
        () {
          return Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 26, left: 14, right: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* AppText(
                        text: couponCodeTxt,
                        size: 16,
                        txtColor: deepBluedark,
                        fontWeight: FontWeight.bold,
                        txtAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: AppTextfield(
                              keyboardType: TextInputType.number,
                              width: 10,
                              hint: couponCodeTxt,
                              lable: enterCouponCode,
                              controller: draftPdfController.couponCodeController.value,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppBtnWithColorShades(
                              isLoad: draftPdfController.isLoadingDiscountAmount.value,
                              onTap: () {
                                if (draftPdfController.couponCodeController.value.text.isNotEmpty) {
                                  draftPdfController.getDiscountAmountApi(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCouponCode, txtColor: primaryWhite, size: 12)));
                                }
                              },
                              btnTxt: apply,
                              color1: darkBlue2,
                              color2: darkBlue1,
                            ),
                          )
                        ],
                      ),*/
                      // const SizedBox(height: 14),

                      InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyCouponsScreen(
                                        isApplyCoupon: true,
                                        insuranceType: widget.insuranceType,
                                      )));
                          /*  if (draftPdfController.couponCodeController.value.text.isNotEmpty) {
                            draftPdfController.getDiscountAmountApi(context);
                          }*/
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration:
                              BoxDecoration(border: Border.all(color: gold), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  draftPdfController.isApplyCoupon.value
                                      ? Row(
                                          children: [
                                            AppText(
                                                text: draftPdfController.couponCodeController.value.text,
                                                size: 16,
                                                txtColor: deepBluedark,
                                                fontWeight: FontWeight.bold,
                                                txtAlign: TextAlign.start),
                                            const SizedBox(width: 5),
                                            AppText(
                                                text: applied,
                                                size: 14,
                                                fontWeight: FontWeight.bold,
                                                txtAlign: TextAlign.start),
                                          ],
                                        )
                                      : AppText(
                                          text: applyCoupons,
                                          size: 16,
                                          txtColor: deepBluedark,
                                          fontWeight: FontWeight.bold,
                                          txtAlign: TextAlign.start),
                                  const Spacer(),
                                  draftPdfController.isApplyCoupon.value
                                      ? InkWell(
                                          onTap: () {
                                            draftPdfController.couponCodeController.value.clear();
                                            draftPdfController.isApplyCoupon.value = false;
                                            draftPdfController.getDiscountAmountModel.value = GetDiscountAmountModel();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: deepBluedark),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: AppText(
                                              text: remove,
                                              size: 12,
                                              txtColor: grayshad400,
                                              fontWeight: FontWeight.w500,
                                              txtAlign: TextAlign.start,
                                            ),
                                          ),
                                        )
                                      : const Icon(Icons.keyboard_arrow_right_outlined, color: deepBluedark, size: 26)
                                ],
                              ),
                              if (draftPdfController.isApplyCoupon.value)
                                Column(
                                  children: [
                                    const Divider(color: blackshad100),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyCouponsScreen(
                                                      isApplyCoupon: true,
                                                      insuranceType: widget.insuranceType,
                                                    )));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                            text: viewAllCoupons,
                                            size: 12,
                                            fontWeight: FontWeight.w500,
                                            txtAlign: TextAlign.start,
                                          ),
                                          const SizedBox(width: 2),
                                          const Icon(Icons.keyboard_arrow_right_outlined, size: 16)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      draftPdfController.getDiscountAmountModel.value.data != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 26, left: 14, right: 14),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      textWidget(netPremium, grayshad400),
                                      textWidget(issuanceFees, grayshad400),
                                      textWidget(tax, grayshad400),
                                      textWidget(stamps, grayshad400),
                                      textWidget(totalPremium, grayshad400),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      textWidget(
                                          draftPdfController.getDiscountAmountModel.value.data!.netPremium.toString(),
                                          deepBluedark),
                                      textWidget(draftPdfController.getDiscountAmountModel.value.data!.fees.toString(),
                                          deepBluedark),
                                      textWidget(
                                          draftPdfController.getDiscountAmountModel.value.data!.salesTax.toString(),
                                          deepBluedark),
                                      textWidget(
                                          draftPdfController.getDiscountAmountModel.value.data!.stamps.toString(),
                                          deepBluedark),
                                      textWidget(
                                          draftPdfController.getDiscountAmountModel.value.data!.totalNetPremium
                                              .toString(),
                                          deepBluedark),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 26, left: 14, right: 14),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      textWidget(netPremium, grayshad400),
                                      textWidget(issuanceFees, grayshad400),
                                      textWidget(tax, grayshad400),
                                      textWidget(stamps, grayshad400),
                                      textWidget(totalPremium, grayshad400),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      textWidget(
                                          draftPdfController.postInsuranceModel.value.data?.netPremium.toString()??'',
                                          deepBluedark),
                                      textWidget(draftPdfController.postInsuranceModel.value.data?.fees.toString()??'',
                                          deepBluedark),
                                      textWidget(draftPdfController.postInsuranceModel.value.data?.salesTax.toString()??'',
                                          deepBluedark),
                                      textWidget(draftPdfController.postInsuranceModel.value.data?.stamps.toString()??'',
                                          deepBluedark),
                                      textWidget(
                                          draftPdfController.postInsuranceModel.value.data?.grossPremium.toString()??'',
                                          deepBluedark),
                                    ],
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: primaryWhite,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: skyBlueShade2),
                          ),
                          child: Center(
                            child: AppText(
                              text: cancelReturn,
                              fontWeight: FontWeight.w500,
                              size: 18,
                              txtColor: deepBluedark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: AppBtnWithColorShades(
                        isLoad: draftPdfController.isLoadingStoreTransaction.value,
                        onTap: () async {
                          payPressed();
                        },
                        btnTxt: acceptProceed,
                        color1: darkBlue2,
                        color2: darkBlue1,
                      ),
                    ),
                  ],
                ),
              ),
              /* Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppBtnWithColorShades(
                  isLoad: draftPdfController.isLoadingDiscountAmount.value,
                  onTap: () {
                    if (draftPdfController.couponCodeController.value.text.isNotEmpty) {
                      draftPdfController.getDiscountAmountApi(context, widget.screenTitle);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCouponCode, txtColor: primaryWhite, size: 12)));
                    }
                  },
                  btnTxt: next,
                  color1: darkBlue2,
                  color2: darkBlue1,
                ),
              )*/
            ],
          );
        },
      ),
    );
  }

  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails(
        '${getProfileModelGlobal.data?.firstName ?? ""} ${getProfileModelGlobal.data?.surname ?? ""}',
        getProfileModelGlobal.data?.emailId ?? "",
        getProfileModelGlobal.data?.mobileNo ?? "",
        getProfileModelGlobal.data?.streetName ?? "",
        'JO',
        draftPdfController.selectCity.value.name ?? '',
        draftPdfController.selectDistrict.value.name ?? '',
        "");
    var shippingDetails = ShippingDetails(
        '${getProfileModelGlobal.data?.firstName ?? ""} ${getProfileModelGlobal.data?.surname ?? ""}',
        getProfileModelGlobal.data?.emailId ?? "",
        getProfileModelGlobal.data?.mobileNo ?? "",
        getProfileModelGlobal.data?.streetName ?? "",
        'JO',
        draftPdfController.selectCity.value.name ?? '',
        draftPdfController.selectDistrict.value.name ?? '',
        "");

    // var billingDetails = BillingDetails("Akram Soneji", "akram@domain.com", "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");
    // var shippingDetails = ShippingDetails("Akram Soneji", "akram@domain.com", "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");

    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.AMAN);
    final configuration = PaymentSdkConfigurationDetails(
        profileId: "145143",
        serverKey: "SZJ9RZBGWJ-JJHG2GJ29T-KMLDNT66DW",
        clientKey: "CRK266-Q27B66-HTMT6M-TM9RK2",
        cartId: draftPdfController.postInsuranceModel.value.data!.purchaseId.toString(),
        cartDescription: draftPdfController.postInsuranceModel.value.data!.planName ?? '',
        merchantName: "Al Netaq Insurance Solutions",
        screentTitle: "Pay with Card",
        // amount: draftPdfController.postInsuranceModel.value.data!.grossPremium ?? 0,

        amount: () {
          // Get your value using your original logic
          var rawValue = draftPdfController.getDiscountAmountModel.value.data != null
              ? draftPdfController.getDiscountAmountModel.value.data!.totalNetPremium ?? 0
              : draftPdfController.postInsuranceModel.value.data!.grossPremium!.contains("%")
              ? draftPdfController.postInsuranceModel.value.data!.grossPremium!.replaceAll("%", "")
              : draftPdfController.postInsuranceModel.value.data!.grossPremium;

          // 1. Convert whatever we got into a clean String (removing any extra text/spaces)
          String cleanString = rawValue.toString().replaceAll(RegExp(r'[^0-9.]'), '');

          // 2. Parse it to a double to satisfy the 'double?' parameter requirement
          return double.tryParse(cleanString) ?? 0.0;
        }(),
        ///remove comment
       /* amount: draftPdfController.getDiscountAmountModel.value.data != null
            ? draftPdfController.getDiscountAmountModel.value.data!.totalNetPremium ?? 0
            : draftPdfController.postInsuranceModel.value.data!.grossPremium!.contains("%")
                ? double.tryParse(
                        draftPdfController.postInsuranceModel.value.data!.grossPremium!.replaceAll("%", "")) ??
                    0
                : double.tryParse(draftPdfController.postInsuranceModel.value.data!.grossPremium.toString()) ?? 0,*/
        //  amount: draftPdfController.getDiscountAmountModel.value.data != null ? draftPdfController.getDiscountAmountModel.value.data!.totalNetPremium ?? 0 : draftPdfController.postInsuranceModel.value.data!.grossPremium!.contains("%")? double.parse(draftPdfController.postInsuranceModel.value.data!.grossPremium!.replaceAll("%", ".0")):double.parse(draftPdfController.postInsuranceModel.value.data!.grossPremium.toString()),
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: "JOD",
        merchantCountryCode: "JO",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);
    final theme = IOSThemeConfigurations();
    configuration.iOSThemeConfigurations = theme;
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            draftPdfController.addStoreTransactionApi(
                context, widget.screenTitle, draftPdfController.postInsuranceModel.value.data!.url ?? '', event);
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }
          insurancePdfController.isPaymentSuccess.value = true;
        } else if (event["status"] == "error") {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: event["message"].toString(), txtColor: primaryWhite, size: 12)));
          print(event);
        } else if (event["status"] == "event") {
          print("event");
        }
      });
    });
  }

  Widget textWidget(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: AppText(text: name, size: 16, txtColor: color, fontWeight: FontWeight.bold, txtAlign: TextAlign.start),
    );
  }
}
