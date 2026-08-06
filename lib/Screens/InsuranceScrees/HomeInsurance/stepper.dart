
import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class CustomStep extends StatefulWidget {
   int totalStep;
   int currentStep;

   CustomStep({super.key,required this.totalStep,required this.currentStep});

  @override
  State<CustomStep> createState() => _CustomStepState();
}

class _CustomStepState extends State<CustomStep> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        for(int i=0;i<widget.totalStep;i++)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: i==widget.currentStep?availableColor:primaryGreyShade
                ),
              ),
              AppText(text: (i+1).toString(),size: 15,)
            ],),
          )
      ],
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_plan.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_plan_fourth_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_second_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/office_insurance.dart';

class CustomSteper extends StatefulWidget {
  const CustomSteper({super.key});

  @override
  State<CustomSteper> createState() => _CustomSteperState();
}

class _CustomSteperState extends State<CustomSteper> {
  @override
  int _currentStep = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper Example'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.horizontal,
        onStepContinue: () {
          setState(() {
            if (_currentStep < 2) {
              _currentStep += 1;
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            }
          });
        },
        steps: <Step>[

          Step(
            title: Text(''),
            content: HomefirstScreen(),
            isActive: _currentStep == 0,
          ),
          Step(
            title: Text('Step 2'),
            content: HomeInsurancePlanSecondScreen(),
            isActive: _currentStep == 1,
          ),
          Step(
            title: Text('Step 2'),
            content: HomeInsurancePlanScreen(),
            isActive: _currentStep == 2,
          ),
         */
/* Step(
            title: Text('Step 3'),
            content: HomethreeScreen(),
            isActive: _currentStep == 3,
          ),
          Step(
            title: Text('Step 4'),
            content: HomethreeScreen(),
            isActive: _currentStep == 4,
          ),*//*

        ],
      ),
    );
  }
}
*/
