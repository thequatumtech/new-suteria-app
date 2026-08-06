import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_list_data_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_third_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'dental_insurance_first_screen.dart';
import 'dental_insurance_second_screen.dart';

class DentalInsuranceStep extends StatefulWidget {
  const DentalInsuranceStep({super.key});

  @override
  State<DentalInsuranceStep> createState() => _DentalInsuranceStepState();
}

class _DentalInsuranceStepState extends State<DentalInsuranceStep> {
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  DentalInsuranceController dentalInsuranceController = Get.put(DentalInsuranceController());

  int currentStep = 0;

  @override
  void initState() {
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
    dentalInsuranceController.clearData();
    super.initState();
  }

  void onnext() {
    setState(() {
      currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (currentStep == 0) {
          return Future.value(true);
        } else {
          setState(() {
            currentStep--;
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                if (currentStep == 0) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    currentStep--;
                  });
                }
              },
              child: const Icon(Icons.keyboard_backspace_outlined)),
          title: AppText(
            text: dentalinsurance,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Column(
          children: [
            const Divider(color: grayshad200),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomStep(
                      currentStep: currentStep,
                      totalStep: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: AppText(
                        text: beforeWeProceed,
                        size: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Stepwidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Stepwidget() {
    if (currentStep == 0) {
      return DentalInsuranceFirstScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 1) {
      return DentalInsuranceSecondScreen(
        onNext: () {
          onnext();
        },
      );
    } else {
      return DentalInsuranceThirdScreen(
        onNext: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DentalInsuranceListData(screenTitle: dentalInsuranceCapital)));
        },
      );
    }
  }
}
