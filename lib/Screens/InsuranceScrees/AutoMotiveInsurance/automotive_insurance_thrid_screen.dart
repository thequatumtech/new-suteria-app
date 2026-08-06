import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/motor_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class AutomotiveInsuranceThridScreen extends StatefulWidget {
  Function onNext;

  AutomotiveInsuranceThridScreen({super.key, required this.onNext});

  @override
  State<AutomotiveInsuranceThridScreen> createState() => _AutomotiveInsuranceThridScreenState();
}

class _AutomotiveInsuranceThridScreenState extends State<AutomotiveInsuranceThridScreen> {
  MotorInsuranceController motorInsuranceController = Get.put(MotorInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextfield(
                readOnly: true,
                hint: inceptiondate,
                lable: inceptiondate,
                controller: motorInsuranceController.inceptionDateController.value,
                ontap: () {
                  inceptionDateDialog();
                }),
            const SizedBox(height: 10),
            AppTextfield(
                readOnly: true,
                hint: expiredaate,
                lable: expiredaate,
                controller: motorInsuranceController.expiryDateController.value,
               ),
            const SizedBox(height: 20),
            AppTextfield(

              hint: nationalIdNumber,
              lable: nationalIdNumber,
              controller: motorInsuranceController.nationIdController.value,
            ),
            const SizedBox(height: 10),
            AppTextfield(

              hint: residencyNumber,
              lable: residencyNumber,
              controller: motorInsuranceController.residencyNumberController.value,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: buttonColorApp,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  txtAlign: TextAlign.center,
                  text: clickToObtainOwnerInformation,
                  txtColor: primaryWhite,
                  size: 16,
                ),
              ),
            ),
            /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(text: "VEHICLE INFORMATION IS CORRECT",size: 10),
                      )),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all()
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(text: "VEHICLE INFORMATION IS NOT CORRECT",size: 10),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            AppText(
              text: "PLEASE CONFIRM IF THE VEHICLE INFORMATION IS CORRECT TO PROCEED FURTHER, OTHERWISE, PLEASE CONTACT US FOR MORE CLARIFICATION.",
              size: 10,
              txtAlign: TextAlign.start,
            ),*/
            const SizedBox(height: 20),
            AppTextfield(
              hint: auto3accident,
              lable: auto3accident,
              keyboardType: TextInputType.number,
              controller: motorInsuranceController.noOfAccidentController.value,
            ),
            const SizedBox(height: 20),
            AppTextfield(
              hint: autonoticket,
              keyboardType: TextInputType.number,
              lable: autonoticket,
              controller: motorInsuranceController.noOfTicketsController.value,
            ),
            const SizedBox(height: 20),
            AppTextfield(
              hint: autonopoint,
              lable: autonopoint,
              keyboardType: TextInputType.number,
              controller: motorInsuranceController.noOfPointsController.value,
            ),
            const SizedBox(height: 20),
            /*  InkWell(
              onTap: () => widget.onNext(),
              child: Image.asset(nextImg),
            ),*/
            AppBtnWithColorShades(
              onTap: () {
                if (motorInsuranceController.noOfAccidentController.value.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterNumberOfAccidentsInThePast3Years, txtColor: primaryWhite, size: 12)));
                } else if (motorInsuranceController.noOfTicketsController.value.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterNumberOfTicketsInThePast12Months, txtColor: primaryWhite, size: 12)));
                } else if (motorInsuranceController.noOfPointsController.value.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterNumberOfPointsInThePast3Years, txtColor: primaryWhite, size: 12)));
                } else {
                  widget.onNext();
                }
              },
              btnTxt: next,
              color1: darkBlue2,
              color2: darkBlue1,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  inceptionDateDialog() async {
    /*if (motorInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (motorInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        motorInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(motorInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        motorInsuranceController.initialDate.value = motorInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        motorInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      motorInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: motorInsuranceController.initialDate.value, //get today's date
      firstDate: motorInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dddd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      motorInsuranceController.inceptionDateController.value.text = commonDateFormat(formattedDate);
      motorInsuranceController.expiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(pickedDate)).add(const Duration(days: 364)).toString())));

      setState(() {});
    } else {
      print("Date is not selected");
    }
  }
}
