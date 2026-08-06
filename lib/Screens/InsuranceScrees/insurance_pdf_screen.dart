import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/discount_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/insurance_pdf_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InsurancePdfScreen extends StatefulWidget {
  String screenTitle;
  String pdfPath;
  String insurancePolicyText;
  String insuranceType;

  InsurancePdfScreen({super.key, required this.insuranceType, required this.screenTitle, required this.pdfPath, required this.insurancePolicyText});

  @override
  State<InsurancePdfScreen> createState() => _InsurancePdfScreenState();
}

class _InsurancePdfScreenState extends State<InsurancePdfScreen> {
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
        title: AppText(text: "${widget.screenTitle} $termsConditionsPolicy", size: 14, fontWeight: FontWeight.bold),
      ),
      body: Obx(
        () {
          return Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.pdfPath.isEmpty || widget.pdfPath == ''
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Html(
                              data: widget.insurancePolicyText,
                              style: {'body': Style(fontWeight: FontWeight.w600, fontSize: FontSize(15))},
                            ),
                          )
                        : SizedBox(height: 800, child: SfPdfViewer.network(widget.pdfPath)),
                    Padding(
                      padding: const EdgeInsets.only(right: 30, top: 12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: insurancePdfController.isTermConditions.value,
                            onChanged: (value) {
                              setState(() {
                                insurancePdfController.isTermConditions.value = value ?? true;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text.rich(
                                maxLines: 3,
                                style: TextStyle(fontSize: 14),
                                TextSpan(children: [
                                  TextSpan(
                                    text: iAcceptAllTermsConditions,
                                  ),
                                ])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppBtnWithColorShades(
                  onTap: () {
                    if (insurancePdfController.isTermConditions.value == true) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DiscountScreen(screenTitle: widget.screenTitle, insuranceType: widget.insuranceType)));
                      // Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseAcceptDrafPolicy /*pleaseAcceptAllTermsAndConditions*/, txtColor: primaryWhite, size: 12)));
                    } // InsurancePolicyScreen(screenTitle: widget.screenTitle)));
                  },
                  btnTxt: next,
                  color1: darkBlue2,
                  color2: darkBlue1,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
