import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_address.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_screen_no_fifth.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_second_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_sisth_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/stepper.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/post_pets_insurance_model.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'home_insurance_plan_fourth_screen.dart';

class HomeInsuranceStep extends StatefulWidget {
  const HomeInsuranceStep({super.key});

  @override
  State<HomeInsuranceStep> createState() => _HomeInsuranceStepState();
}

class _HomeInsuranceStepState extends State<HomeInsuranceStep> {
  HomeInsuranceController homeInsuranceController=Get.put(HomeInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());
  int currentStep = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    homeInsuranceController.clearDataMethod();
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
            text: homeinsurance,
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
                    CustomStep(currentStep: currentStep, totalStep: 5),
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
      return HomeInsurancePlanSecondScreen(onNext: () {
        onnext();
      });
    } else if (currentStep == 1) {
      return HomethreeScreen(
        onNext: () {
          onnext();
        },
      );
    } else if (currentStep == 2) {
      return HomeAddress(
        onNext: () {
          onnext();
        },
      );
    } else if (currentStep == 3) {
      return HomeScreenFith(onNext: () {
        onnext();
      });
    } else {
      return HomeScreensixeth(
        onNext: ()async {
         await Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeInsurance(screenTitle: homeInsurance)));

          /*currentStep = 0;
          setState(() {});*/
        },
      );
    }
  }
}
