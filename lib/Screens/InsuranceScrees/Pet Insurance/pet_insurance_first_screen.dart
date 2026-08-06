import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class PetInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  PetInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<PetInsuranceFirstScreen> createState() => _PetInsuranceFirstScreenState();
}

class _PetInsuranceFirstScreenState extends State<PetInsuranceFirstScreen> {
  PetInsuranceController petInsuranceController = Get.put(PetInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () {
          return petInsuranceController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    AppTextfield(width: 10, hint: policyHolderFirstName, lable: policyHolderFirstName, readOnly: true, controller: petInsuranceController.policyHolderFirstNameController.value),
                    SizedBox(height: 10),
                    AppTextfield(
                      width: 10,
                      hint: policyHolderSecondName,
                      lable: policyHolderSecondName,
                      controller: petInsuranceController.policyHolderSecondNameController.value,
                      readOnly: true,
                      /*readOnly: true,*/
                    ),
                    SizedBox(height: 10),
                    AppTextfield(
                      width: 10,
                      hint: policyHolderThirdName,
                      lable: policyHolderThirdName,
                      readOnly: true,
                      controller: petInsuranceController.policyHolderThirdNameController.value,
                    ),
                    SizedBox(height: 10),
                    AppTextfield(
                      width: 10,
                      hint: policyHolderFamilyName,
                      lable: policyHolderFamilyName,
                      readOnly: true,
                      controller: petInsuranceController.policyHolderFamilyNameController.value,
                    ),
                    SizedBox(height: 10),
                    AppTextfield(width: 10, readOnly: true, hint: nationalnopassport, lable: nationalnopassport, controller: petInsuranceController.nationPassportNoController.value),
                    SizedBox(height: 10),
                    AppTextfield(width: 10, readOnly: true, hint: residenceno, lable: residenceno, controller: petInsuranceController.idOrResidenceNoController.value),
                    SizedBox(height: 10),
                    AppTextfield(width: 10, readOnly: true, hint: ownerbirthdate, lable: ownerbirthdate, controller: petInsuranceController.ownerBirthDateController.value),
                    SizedBox(height: 10),
                    AppBtnWithColorShades(
                      onTap: () {
                        widget.onNext();
                      },
                      btnTxt: next,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
