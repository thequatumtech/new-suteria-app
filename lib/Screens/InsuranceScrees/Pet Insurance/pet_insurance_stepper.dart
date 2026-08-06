import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_first_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_list_data_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_type_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'pet_insurance_second_screen.dart';

class PetInsuranceStep extends StatefulWidget {
  const PetInsuranceStep({super.key});

  @override
  State<PetInsuranceStep> createState() => _PetInsuranceStepState();
}

class _PetInsuranceStepState extends State<PetInsuranceStep> {
  PetInsuranceController petInsuranceController = Get.put(PetInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  int currentStep = 0;

  @override
  void initState() {
    petInsuranceController.clearData();
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
            text: petinsurance,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Column(
          children: [
            const Divider(color: grayshad200),
            const SizedBox(height: 12),
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
      return PetInsuranceTypeScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 1) {
      return PetInsuranceFirstScreen(onNext: () {
        onnext();
      });
    } else {
      return PetInsuranceSecondScreen(
        onNext: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PetInsuranceListDataScreen(screenTitle: petinsurance)));

         /* currentStep = 0;
          setState(() {});*/
        },
      );
    }
  }
}
