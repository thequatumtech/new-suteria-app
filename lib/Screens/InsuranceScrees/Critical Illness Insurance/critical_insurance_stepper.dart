import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_illness_insurance_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_insurance_data_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_insurance_fourth_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_insurance_second_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_insurance_third_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'critical_insurance_first_screen.dart';

class CriticalInsuranceStep extends StatefulWidget {
  const CriticalInsuranceStep({super.key});

  @override
  State<CriticalInsuranceStep> createState() => _CriticalInsuranceStepState();
}

class _CriticalInsuranceStepState extends State<CriticalInsuranceStep> {
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  CriticalIllnessInsuranceController criticalIllnessInsuranceController = Get.put(CriticalIllnessInsuranceController());

  @override
  void initState() {
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
    criticalIllnessInsuranceController.clearData();
    super.initState();
  }

  int currentStep = 0;

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
            text: criticalinsurance,
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
                      totalStep: 4,
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
      return CriticalInsuranceFirstScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 1) {
      return CriticalInsuranceSecondScreen(
        onNext: () {
          onnext();
        },
      );
    } else if (currentStep == 2) {
      return CriticalInsuranceThirdScreen(
        onNext: () {
          onnext();
        },
      );
    } else {
      return CriticalInsuranceFourthScreen(
        onNext: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CriticalInsuranceDataScreen()));

          /*currentStep = 0;
          setState(() {});*/
        },
      );
    }
  }
}
