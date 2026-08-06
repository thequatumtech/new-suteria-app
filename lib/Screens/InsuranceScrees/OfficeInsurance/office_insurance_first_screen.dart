import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';

class OfficeInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  OfficeInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<OfficeInsuranceFirstScreen> createState() => _OfficeInsuranceFirstScreenState();
}

class _OfficeInsuranceFirstScreenState extends State<OfficeInsuranceFirstScreen> {
  OfficeInsuranceController officeInsuranceController = Get.put(OfficeInsuranceController());

  @override
  void initState() {
    officeInsuranceController.init(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return officeInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextfield(
                    width: 10,
                    readOnly: true,
                    hint: policyHolderFirstName,
                    lable: policyHolderFirstName,
                    controller: officeInsuranceController.policyHolderFirstNameController.value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextfield(
                    width: 10,
                    hint: policyHolderSecondName,
                    lable: policyHolderSecondName,
                    readOnly: true,
                    controller: officeInsuranceController.policyHolderSecondNameController.value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextfield(
                    width: 10,
                    hint: policyHolderThirdName,
                    lable: policyHolderThirdName,
                    readOnly: true,
                    controller: officeInsuranceController.policyHolderThirdNameController.value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextfield(
                    width: 10,
                    hint: policyHolderFamilyName,
                    lable: policyHolderFamilyName,
                    readOnly: true,
                    controller: officeInsuranceController.policyHolderFamilyNameController.value,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = officeInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        officeInsuranceController.selectNationality.value = cdl;
                      });
                    },
                    items: officeInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: officeInsuranceController.nationalityList.any((element) => element.id == officeInsuranceController.selectNationality.value.id) ? officeInsuranceController.selectNationality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextfield(
                    width: 10,
                    readOnly: true,
                    hint: nationalnopassport,
                    lable: nationalnopassport,
                    controller: officeInsuranceController.nationPassportNoController.value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextfield(
                    width: 10,
                    readOnly: true,
                    hint: residenceno,
                    lable: residenceno,
                    controller: officeInsuranceController.idOrResidenceNoController.value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextfield(
                    width: 10,
                    readOnly: true,
                    hint: birthdate,
                    lable: birthdate,
                    controller: officeInsuranceController.birthDateController.value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        officeInsuranceController.selectedgender = newValue!;
                      });
                    },
                    items: officeInsuranceController.genderList,
                    selectedValue: officeInsuranceController.selectedgender,
                    dropdownTitle: selectgender,
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        GetCountryList cdl = officeInsuranceController.placeResidenceList.firstWhere((element) => element.id == newValue);
                        officeInsuranceController.selectPlaceResidence.value = cdl;
                      });
                    },
                    items: officeInsuranceController.placeResidenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: officeInsuranceController.placeResidenceList.any((element) => element.id == officeInsuranceController.selectPlaceResidence.value.id) ? officeInsuranceController.selectPlaceResidence.value.id ?? 0 : null,
                    dropdownTitle: placeofresidence,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: AppBtnWithColorShades(
                    onTap: () {
                      widget.onNext();
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                ),
              ],
            );
    });
  }
}
