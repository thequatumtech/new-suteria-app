import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_list_data_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_thrid_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_type_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'marine_insurance_first_screen.dart';
import 'marine_insurance_second_screen.dart';

class MarineInsuranceStep extends StatefulWidget {
  const MarineInsuranceStep({super.key});

  @override
  State<MarineInsuranceStep> createState() => _MarineInsuranceStepState();
}

class _MarineInsuranceStepState extends State<MarineInsuranceStep> {
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  MarineInsuranceController marineInsuranceController = Get.put(MarineInsuranceController());
  ScrollController _scrollController = ScrollController();

  int currentStep = 0;
  bool _selectedOptin = false;

  @override
  void initState() {
    marineInsuranceController.clearData();
    draftPdfController.postInsuranceModel.value = PostInsuranceModel();

    super.initState();
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
            text: marine + insurance,
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
      return MarineInsuranceTypeScreen(onNext: () {
        onnext();
      });
    }  else if (currentStep == 1) {
      return MarineInsuranceFirstScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 2) {
      return MarineInsuranceThridScreen(
        onNext: (bool value) {
          _selectedOptin = value;
          onnext();
        },
      );
    } else {
      return MarineInsuranceSecondScreen(
        selectedOptin: _selectedOptin,
        onNext: () {
          if (!_selectedOptin) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MarineInsuranceListDataScreen(screenTitle: marine + insurance)));
           /* currentStep = 0;
            setState(() {});*/
          }
        },
      );
    }
  }
}
