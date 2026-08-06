import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';

class PersonalInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  PersonalInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<PersonalInsuranceFirstScreen> createState() => _PersonalInsuranceFirstScreenState();
}

class _PersonalInsuranceFirstScreenState extends State<PersonalInsuranceFirstScreen> {
  PersonalInsuranceController personalInsuranceController = Get.put(PersonalInsuranceController());

  @override
  void initState() {
     personalInsuranceController.init(context);
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return personalInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderFirstName, lable: policyHolderFirstName, controller: personalInsuranceController.policyHolderFirstNameController.value),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderSecondName, lable: policyHolderSecondName, controller: personalInsuranceController.policyHolderSecondNameController.value),
                  SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderThirdName, lable: policyHolderThirdName, controller: personalInsuranceController.policyHolderThirdNameController.value),
                  SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderFamilyName, lable: policyHolderFamilyName, controller: personalInsuranceController.policyHolderFamilyNameController.value),
                  SizedBox(height: 10),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = personalInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        personalInsuranceController.selectNationality.value = cdl;
                      });
                    },
                    items: personalInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: personalInsuranceController.nationalityList.any((element) => element.id == personalInsuranceController.selectNationality.value.id) ? personalInsuranceController.selectNationality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: nationalnopassport, lable: nationalnopassport, controller: personalInsuranceController.nationPassportNoController.value),
                  SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: residenceno, lable: residenceno, controller: personalInsuranceController.idOrResidenceNoController.value),
                  SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: birthdate, lable: birthdate, controller: personalInsuranceController.birthDateController.value),
                  SizedBox(height: 10),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        personalInsuranceController.selectedGender = newValue!;
                      });
                    },
                    items: personalInsuranceController.genderList,
                    selectedValue: personalInsuranceController.selectedGender,
                    dropdownTitle: selectgender,
                  ),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        personalInsuranceController.selectedMaritalStatus = newValue!;
                      });
                    },
                    items: personalInsuranceController.maritalStatusList,
                    selectedValue: personalInsuranceController.selectedMaritalStatus,
                    dropdownTitle: mrgstatus,
                  ),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        GetCountryList cdl = personalInsuranceController.placeResidenceList.firstWhere((element) => element.id == newValue);
                        personalInsuranceController.selectPlaceResidence.value = cdl;
                      });
                    },
                    items: personalInsuranceController.placeResidenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: personalInsuranceController.placeResidenceList.any((element) => element.id == personalInsuranceController.selectPlaceResidence.value.id) ? personalInsuranceController.selectPlaceResidence.value.id ?? 0 : null,
                    dropdownTitle: placeofresidence,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: AppBtnWithColorShades(
                      onTap: () {
                        if (personalInsuranceController.selectedMaritalStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMaritalStatus, txtColor: primaryWhite, size: 12)));
                        } else if (personalInsuranceController.selectPlaceResidence.value.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectPlaceOfResidency, txtColor: primaryWhite, size: 12)));
                        } else {
                          widget.onNext();
                        }
                      },
                      btnTxt: next,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
