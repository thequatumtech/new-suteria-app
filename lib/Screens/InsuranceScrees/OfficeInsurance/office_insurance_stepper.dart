import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_controller.dart';

import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_first_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_fourth_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_list_data_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_third_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'office_insurance_second_screen.dart';

class OfficeInsuranceStep extends StatefulWidget {
  const OfficeInsuranceStep({super.key});

  @override
  State<OfficeInsuranceStep> createState() => _OfficeInsuranceStepState();
}

class _OfficeInsuranceStepState extends State<OfficeInsuranceStep> {
  OfficeInsuranceController officeInsuranceController = Get.put(OfficeInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  int currentStep = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    officeInsuranceController.clearData();
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();
  }

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
            text: officeinsurance,
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
                controller: _scrollController,
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
      return OfficeInsuranceFirstScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 1) {
      return OfficeInsuranceSecondScreen(
        onNext: () {
          onnext();
        },
      );
    } else if (currentStep == 2) {
      return OfficeInsuranceThirdScreen(
        onNext: () {
          onnext();
        },
      );
    } else {
      return OfficeInsuranceFourthScreen(
        onNext: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OfficeInsuranceListDataScreen(screenTitle: officeinsurance)));
          /*currentStep = 0;
          setState(() {});*/
        },
      );
    }
  }
}
