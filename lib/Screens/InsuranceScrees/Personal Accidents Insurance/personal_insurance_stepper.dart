import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_Insurance_second_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_accident_insurance_list_data_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'personal_Insurance_third_screen.dart';
import 'personal_insurance_first_Screen.dart';

class PersonalInsuranceStep extends StatefulWidget {
  const PersonalInsuranceStep({super.key});

  @override
  State<PersonalInsuranceStep> createState() => _PersonalInsuranceStepState();
}

class _PersonalInsuranceStepState extends State<PersonalInsuranceStep> {
  PersonalInsuranceController personalInsuranceController = Get.put(PersonalInsuranceController());

  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  int currentStep = 0;

  @override
  void initState() {
    personalInsuranceController.clearData();
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
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
            text: personalinsurance,
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
      return PersonalInsuranceFirstScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 1) {
      return PersonalInsuranceSecondScreen(
        onNext: () {
          onnext();
        },
      );
    } else {
      return PersonalInsuranceThirdScreen(
        onNext: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonalAccidentInsuranceListDataScreen()));
          /*currentStep = 0;
          setState(() {});*/
        },
      );
    }
  }
}
