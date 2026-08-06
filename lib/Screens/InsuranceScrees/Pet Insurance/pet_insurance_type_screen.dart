import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class PetInsuranceTypeScreen extends StatefulWidget {
  Function onNext;

  PetInsuranceTypeScreen({super.key, required this.onNext});

  @override
  State<PetInsuranceTypeScreen> createState() => _PetInsuranceTypeScreenState();
}

class _PetInsuranceTypeScreenState extends State<PetInsuranceTypeScreen> {
  PetInsuranceController petInsuranceController = Get.put(PetInsuranceController());

  @override
  void initState() {
    petInsuranceController.setTextData();
    super.initState();
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      petInsuranceController.isDog.value = true;
                    },
                    child: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(border: Border.all(color: petInsuranceController.isDog.value ? skyBlue : primaryBlack), borderRadius: BorderRadius.circular(5)),
                      child: Center(child: AppText(text: dog, txtColor: petInsuranceController.isDog.value ? skyBlue : primaryBlack, fontWeight: FontWeight.bold, size: 15)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      petInsuranceController.isDog.value = false;
                    },
                    child: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(border: Border.all(color: !petInsuranceController.isDog.value ? skyBlue : primaryBlack), borderRadius: BorderRadius.circular(5)),
                      child: Center(child: AppText(text: cat, fontWeight: FontWeight.bold, txtColor: !petInsuranceController.isDog.value ? skyBlue : primaryBlack, size: 15)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

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
