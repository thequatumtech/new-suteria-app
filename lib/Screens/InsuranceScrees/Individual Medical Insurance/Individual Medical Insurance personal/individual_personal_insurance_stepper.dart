import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_medical_insurance_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_medical_insurance_list_data_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'individual_personal_Insurance_second_screen.dart';
import 'individual_personal_Insurance_third_screen.dart';
import 'individual_personal_insurance_first_Screen.dart';

class IndividualPersonalInsuranceStep extends StatefulWidget {
  const IndividualPersonalInsuranceStep({super.key});

  @override
  State<IndividualPersonalInsuranceStep> createState() => _IndividualPersonalInsuranceStepState();
}

class _IndividualPersonalInsuranceStepState extends State<IndividualPersonalInsuranceStep> {
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  IndividualMedicalInsuranceController individualMedicalInsuranceController = Get.put(IndividualMedicalInsuranceController());
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    individualMedicalInsuranceController.clearData();
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
    super.initState();
  }

  int currentStep = 0;

  void onnext() {
    setState(() {
      currentStep++;
    });
    _scrollController.jumpTo(0);
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
            text: individualMedicalInsurance,
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Column(
          children: [
            const Divider(color: grayshad200),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
      return IndividualPersonalInsuranceFirstScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 1) {
      return IndividualPersonalInsuranceSecondScreen(
        onNext: () {
          onnext();
        },
      );
    } else {
      return IndividualPersonalInsuranceThirdScreen(
        onNext: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => IndividualMedicalInsuranceListDataScreen(screenTitle: individualMedicalInsurance),
          ));

          /*currentStep = 0;
          setState(() {});*/
        },
      );
    }
  }
}
