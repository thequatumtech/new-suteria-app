import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/insurance_pdf_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/insurance_pdf_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InsuranceDraftPdfScreen extends StatefulWidget {
  String screenTitle = '';
  String pdfPath = '';
  String insurancePolicyText = '';
  Map<String, dynamic> data;
  String apiUrl;
  String insuranceType;

  InsuranceDraftPdfScreen({super.key, required this.insuranceType, required this.screenTitle, required this.pdfPath, required this.insurancePolicyText, required this.data, required this.apiUrl});

  @override
  State<InsuranceDraftPdfScreen> createState() => _InsuranceDraftPdfScreenState();
}

class _InsuranceDraftPdfScreenState extends State<InsuranceDraftPdfScreen> {
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  InsurancePdfController insurancePdfController = Get.put(InsurancePdfController());

  @override
  void initState() {
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
    draftPdfController.postInsuranceApi(context, widget.data, widget.apiUrl);
    draftPdfController.apiMethod(context);
    insurancePdfController.isTermConditions.value = false;
    insurancePdfController.isTermConditionsDraf.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.keyboard_backspace_outlined)),
        title: AppText(text: "${widget.screenTitle} Draft Policy", size: 18, fontWeight: FontWeight.bold),
      ),
      body: Obx(() {
        return draftPdfController.isButtonLoading.value
            ? const Center(child: CircularProgressIndicator())
            : draftPdfController.statusCodeapp.value == "200" || draftPdfController.statusCodeapp.value == "201"
                ? Column(
                    children: [
                      Expanded(
                          child: draftPdfController.postInsuranceModel.value.data == null ||
                                  draftPdfController.postInsuranceModel.value.data!.url == null ||
                                  draftPdfController.postInsuranceModel.value.data!.url!.isEmpty
                              ? Center(child: AppText(text: noDraftFound, size: 20, fontWeight: FontWeight.w600))
                              : SfPdfViewer.network(draftPdfController.postInsuranceModel.value.data!.url ?? '')),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 12),
                        child: Row(
                          children: [
                            Checkbox(
                              value: insurancePdfController.isTermConditionsDraf.value,
                              onChanged: (value) {
                                setState(() {
                                  insurancePdfController.isTermConditionsDraf.value = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text.rich(
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 14),
                                  TextSpan(children: [
                                    TextSpan(
                                      text: iAcceptAllTerms,
                                    ),
                                  ])),
                            ),
                          ],
                        ),
                      ),
                      /* Row(
                    children: [
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InsurancePdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: widget.pdfPath,
                                    insurancePolicyText: widget.insurancePolicyText,
                                  )));
                        },
                        child: AppText(
                          text: termsConditions,
                          size: 16,
                          txtColor: darkBlue2,
                          fontWeight: FontWeight.w500,
                          textunderline: TextDecoration.underline,
                          textUnderlineColor: darkBlue2,
                        ),
                      ),
                    ],
                  ),*/
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                        child: AppBtnWithColorShades(
                          isLoad: draftPdfController.isLoadingStoreTransaction.value,
                          onTap: () async {
                            if (insurancePdfController.isTermConditionsDraf.value == true) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => InsurancePdfScreen(
                                        screenTitle: widget.screenTitle,
                                        pdfPath: widget.pdfPath,
                                        insurancePolicyText: widget.insurancePolicyText,
                                        insuranceType: widget.insuranceType,
                                      )));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseAcceptAllTermsAndConditions, txtColor: primaryWhite, size: 12)));
                            }
                          },
                          btnTxt: next,
                          color1: darkBlue2,
                          color2: darkBlue1,
                        ),
                      ),
                      /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(editIcon),
                                  const SizedBox(width: 10),
                                  AppText(
                                    text: editt,
                                    fontWeight: FontWeight.w500,
                                    size: 18,
                                    txtColor: deepBluedark,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: AppBtnWithColorShades(
                            isLoad: draftPdfController.isLoadingStoreTransaction.value,
                            onTap: () async {
                              if (insurancePdfController.isTermConditions.value == true) {
                                payPressed();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseReadTermsAndConditions, txtColor: primaryWhite, size: 12)));
                              }
                            },
                            btnTxt: submit,
                            color1: darkBlue2,
                            color2: darkBlue1,
                          ),
                        ),
                      ],
                    ),
                  )*/
                    ],
                  )
                : Padding(padding: const EdgeInsets.all(15.0), child: AppText(text: "${draftPdfController.statusMsg.value}", size: 20, txtColor: Colors.red, fontWeight: FontWeight.w600));
      }),
    );
  }

/*  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails('${getProfileModelGlobal.data?.firstName ?? ""} ${getProfileModelGlobal.data?.surname ?? ""}', getProfileModelGlobal.data?.emailId ?? "", getProfileModelGlobal.data?.mobileNo ?? "", getProfileModelGlobal.data?.streetName ?? "", 'JO',
        draftPdfController.selectCity.value.name ?? '', draftPdfController.selectDistrict.value.name ?? '', "");
    var shippingDetails = ShippingDetails('${getProfileModelGlobal.data?.firstName ?? ""} ${getProfileModelGlobal.data?.surname ?? ""}', getProfileModelGlobal.data?.emailId ?? "", getProfileModelGlobal.data?.mobileNo ?? "", getProfileModelGlobal.data?.streetName ?? "", 'JO',
        draftPdfController.selectCity.value.name ?? '', draftPdfController.selectDistrict.value.name ?? '', "");

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
        amount: draftPdfController.postInsuranceModel.value.data!.grossPremium ?? 0,
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
            draftPdfController.addStoreTransactionApi(context, widget.screenTitle, draftPdfController.postInsuranceModel.value.data!.url ?? '', event);
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }
          insurancePdfController.isPaymentSuccess.value = true;
        } else if (event["status"] == "error") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: event["message"].toString(), txtColor: primaryWhite, size: 12)));
          print(event);
        } else if (event["status"] == "event") {
          print("event");
        }
      });
    });
  }*/
}
