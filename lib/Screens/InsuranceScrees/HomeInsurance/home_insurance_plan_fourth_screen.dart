import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';

class HomethreeScreen extends StatefulWidget {
  Function onNext;

  HomethreeScreen({super.key, required this.onNext});

  @override
  State<HomethreeScreen> createState() => _HomethreeScreenState();
}

class _HomethreeScreenState extends State<HomethreeScreen> {
  HomeInsuranceController homeInsuranceController = Get.put(HomeInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                homeInsuranceController.selecthomeType = newValue!;
              });
            },
            items: const [apartment, villa],
            selectedValue: homeInsuranceController.selecthomeType,
            dropdownTitle: hometype,
          ),
          CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                homeInsuranceController.selectNoOfFloors = newValue!;
              });
            },
            items: const ['1', '2', "3", "4", "5", "6"],
            selectedValue: homeInsuranceController.selectNoOfFloors,
            dropdownTitle: noOfFloorsForBuilding,
          ),
          CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                homeInsuranceController.selectedroomsItem = newValue!;
              });
            },
            items: const ['1', '2', "3", "4", "5", "6", "7", "8", "9"],
            selectedValue: homeInsuranceController.selectedroomsItem,
            dropdownTitle: noofrooms,
          ),
          CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                homeInsuranceController.selectedAgeItem = newValue!;
              });
            },
            items: const ['1', '2', "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", '16', '17', "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"],
            selectedValue: homeInsuranceController.selectedAgeItem,
            dropdownTitle: agebuilding,
          ),
          AppTextfield(hint: sizeofapartment, lable: sizeofapartment, controller: homeInsuranceController.sizeOfApartmentController.value, keyboardType: TextInputType.number),
          const SizedBox(height: 8),


          AppText(
            text: noofresidence ?? "",
            size: 16,
            txtColor: deepBluedark,
            fontWeight: FontWeight.bold,
            txtAlign: TextAlign.start,
          ),
          const SizedBox(height: 5,),
          AppTextfield(
            controller: homeInsuranceController.noOfResidence1,
            width: 10,
            hint: noofresidence,
            keyboardType: TextInputType.number,
            lable: noofresidence,
          ),

         /* CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                homeInsuranceController.noOfResidence = newValue!;
              });
            },
            items: const ['1', '2', "3", "4", "5", "6"],
            selectedValue: homeInsuranceController.noOfResidence,
            dropdownTitle: noofresidence,
          ),*/
          CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                homeInsuranceController.selectedOwnership = newValue!;
              });
            },
            items: const [owned, rented],
            selectedValue: homeInsuranceController.selectedOwnership,
            dropdownTitle: homecategory,
          ),
          if (homeInsuranceController.selectedOwnership == owned)
            Column(
              children: [
                AppTextfield(
                  controller: homeInsuranceController.blockNoController.value,
                  width: 10,
                  hint: blockNo,
                  lable: blockNo,
                ),
                const SizedBox(height: 10),
                AppTextfield(
                  width: 10,
                  hint: plateNo,
                  lable: plateNo,
                  controller: homeInsuranceController.plateNoController.value,
                ),
                const SizedBox(height: 10),
                AppTextfield(
                  width: 10,
                  hint: plotNo,
                  lable: plotNo,
                  controller: homeInsuranceController.plotNoController.value,
                ),
              ],
            ),
          const SizedBox(height: 20),
          AppBtnWithColorShades(
            onTap: () {
              if (homeInsuranceController.sizeOfApartmentController.value.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterSizeOfApartmentVillaInSqm, txtColor: primaryWhite, size: 12)));
              } else if (homeInsuranceController.noOfResidence1.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectNoOfResidence, txtColor: primaryWhite, size: 12)));
              } else if (checkValidation()) {
                print("object??????");
              } else {
                widget.onNext();
              }
            },
            btnTxt: next,
            color1: darkBlue2,
            color2: darkBlue1,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool checkValidation() {
    if (homeInsuranceController.selectedOwnership == owned) {
      if (homeInsuranceController.blockNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBlockNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (homeInsuranceController.plateNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPlateNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (homeInsuranceController.plotNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPlotNo, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }
}
