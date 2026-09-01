import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

class HomeScreenFith extends StatefulWidget {
  Function onNext;

  HomeScreenFith({super.key, required this.onNext});

  @override
  State<HomeScreenFith> createState() => _HomeScreenFithState();
}

class _HomeScreenFithState extends State<HomeScreenFith> {
  HomeInsuranceController homeInsuranceController = Get.put(HomeInsuranceController());

  @override
  void initState() {
    /* homeInsuranceController.init(context);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeInsuranceController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(text: homeq1, size: 15, txtAlign: TextAlign.start),
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: homeInsuranceController.selectedOption1,
                        onChanged: (value) {
                          setState(() {
                            homeInsuranceController.selectedOption1 = value!;
                          });
                        },
                      ),
                      AppText(text: yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: homeInsuranceController.selectedOption1,
                        onChanged: (value) {
                          setState(() {
                            homeInsuranceController.selectedOption1 = value!;
                          });
                        },
                      ),
                      AppText(text: noTxt),
                    ],
                  ),
                  if (homeInsuranceController.selectedOption1 == yesTxt)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: AppTextfield(hint: homen1, lable: homen1, controller: homeInsuranceController.previousPolicyExplain.value),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(text: homeq2, size: 15, txtAlign: TextAlign.start),
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: homeInsuranceController.selectedOption2,
                        onChanged: (value) {
                          setState(() {
                            homeInsuranceController.selectedOption2 = value!;
                          });
                        },
                      ),
                      AppText(text: yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: homeInsuranceController.selectedOption2,
                        onChanged: (value) {
                          setState(() {
                            homeInsuranceController.selectedOption2 = value!;
                          });
                        },
                      ),
                      AppText(text: noTxt),
                    ],
                  ),
                  if (homeInsuranceController.selectedOption2 == yesTxt)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: AppTextfield(hint: homen2, maxLine: 2, lable: homen2, controller: homeInsuranceController.whyDeclineController.value),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(text: homeq3, size: 15, txtAlign: TextAlign.start),
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: homeInsuranceController.selectedOption3,
                        onChanged: (value) {
                          setState(() {
                            homeInsuranceController.selectedOption3 = value!;
                          });
                        },
                      ),
                      AppText(text: yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: homeInsuranceController.selectedOption3,
                        onChanged: (value) {
                          setState(() {
                            homeInsuranceController.selectedOption3 = value!;
                          });
                        },
                      ),
                      AppText(text: noTxt),
                    ],
                  ),
                  if(homeInsuranceController.selectedOption3 == yesTxt)
                       Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppTextfield(hint: homen3, lable: homen3, controller: homeInsuranceController.claimIn5yearController.value),
                        ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(
                          text: dYHHAPS,
                          size: 15,
                          txtAlign: TextAlign.start,
                        ),
                      ),
                      MultiDropdown<int>(
                        controller: homeInsuranceController.controller,
                        onSelectionChange: (List<int> selectedValues) {
                          homeInsuranceController.selectProtectionSystemList.value =
                              homeInsuranceController.protectionSystemListDrop
                                  .where((item) => selectedValues.contains(item.value))
                                  .toList();
                          setState(() {});
                        },
                        items: homeInsuranceController.protectionSystemListDrop,
                        fieldDecoration: FieldDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: skyBlueShade1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: skyBlueShade1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: getTranslated(context, pleaseChooseFromTheList),
                        ),
                        chipDecoration: const ChipDecoration(wrap: true),
                        dropdownDecoration: const DropdownDecoration(maxHeight: 200),
                        dropdownItemDecoration: const DropdownItemDecoration(
                          selectedIcon: Icon(Icons.check_circle),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: AppBtnWithColorShades(
                      onTap: () {
                        if (homeInsuranceController.selectedOption1 == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectPreviousHomeInsuranceOption, txtColor: primaryWhite, size: 12)));
                        } else if (homeInsuranceController.selectedOption1 == yesTxt && homeInsuranceController.previousPolicyExplain.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterInsurancePolicy, txtColor: primaryWhite, size: 12)));
                        } else if (homeInsuranceController.selectedOption2 == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceCompanyDeclinedToIssueOption, txtColor: primaryWhite, size: 12)));
                        } else if (homeInsuranceController.selectedOption2 == yesTxt && homeInsuranceController.whyDeclineController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterInsuranceCompanyDeclinedToIssue, txtColor: primaryWhite, size: 12)));
                        } else if (homeInsuranceController.selectedOption3 == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAccidentsOption, txtColor: primaryWhite, size: 12)));
                        } else if (homeInsuranceController.selectedOption3 == yesTxt && homeInsuranceController.claimIn5yearController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterDetailsTheClamAccident, txtColor: primaryWhite, size: 12)));
                        } else if (homeInsuranceController.selectedOption3 == noTxt && homeInsuranceController.selectProtectionSystemList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectProtectionSystem, txtColor: primaryWhite, size: 12)));
                        } else {
                          widget.onNext();
                        }
                      },
                      btnTxt: continuE,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
