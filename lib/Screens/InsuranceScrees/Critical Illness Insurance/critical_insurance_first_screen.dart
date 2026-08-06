import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_illness_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class CriticalInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  CriticalInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<CriticalInsuranceFirstScreen> createState() => _CriticalInsuranceFirstScreenState();
}

class _CriticalInsuranceFirstScreenState extends State<CriticalInsuranceFirstScreen> {
  CriticalIllnessInsuranceController criticalIllnessInsuranceController = Get.put(CriticalIllnessInsuranceController());

  @override
  void initState() {
    criticalIllnessInsuranceController.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return criticalIllnessInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AppTextfield(
                    width: 10,
                    hint: policyHolderFirstName,
                    lable: policyHolderFirstName,
                    readOnly: true,
                    controller: criticalIllnessInsuranceController.policyHolderFirstNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderSecondName,
                    lable: policyHolderSecondName,
                    readOnly: true,
                    controller: criticalIllnessInsuranceController.policyHolderSecondNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderThirdName,
                    lable: policyHolderThirdName,
                    readOnly: true,
                    controller: criticalIllnessInsuranceController.policyHolderThirdNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderFamilyName,
                    lable: policyHolderFamilyName,
                    controller: criticalIllnessInsuranceController.policyHolderFamilyNameController.value,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = criticalIllnessInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        criticalIllnessInsuranceController.selectNationality.value = cdl;
                      });
                    },
                    items: criticalIllnessInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: criticalIllnessInsuranceController.nationalityList.any((element) => element.id == criticalIllnessInsuranceController.selectNationality.value.id) ? criticalIllnessInsuranceController.selectNationality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: nationalnopassport,
                    lable: nationalnopassport,
                    controller: criticalIllnessInsuranceController.nationPassportNoController.value,
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: residenceno,
                    lable: residenceno,
                    controller: criticalIllnessInsuranceController.idOrResidenceNoController.value,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: birthdate, lable: birthdate, controller: criticalIllnessInsuranceController.birthDateController.value),
                  SizedBox(height: 10),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        criticalIllnessInsuranceController.selectedgender = newValue!;
                      });
                    },
                    items: criticalIllnessInsuranceController.genderList,
                    selectedValue: criticalIllnessInsuranceController.selectedgender,
                    dropdownTitle: selectgender,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: beneficiaryFirstName,
                    lable: beneficiaryFirstName,
                    controller: criticalIllnessInsuranceController.beneficiaryFirstNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: beneficiarySecondName,
                    lable: beneficiarySecondName,
                    controller: criticalIllnessInsuranceController.beneficiarySecondNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: beneficiaryThirdName,
                    lable: beneficiaryThirdName,
                    controller: criticalIllnessInsuranceController.beneficiaryThirdNameController.value,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: beneficiaryFamilyName,
                    lable: beneficiaryFamilyName,
                    controller: criticalIllnessInsuranceController.beneficiaryFamilyNameController.value,
                  ),
                  const SizedBox(height: 10),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        criticalIllnessInsuranceController.selectedMaritalStatus = newValue!;
                      });
                    },
                    items: criticalIllnessInsuranceController.maritalStatusList,
                    selectedValue: criticalIllnessInsuranceController.selectedMaritalStatus,
                    dropdownTitle: mrgstatus,
                  ),
                  /*  Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: AppText(
                        text: placeofresidence,
                        size: 16,
                        fontWeight: FontWeight.bold,
                        txtAlign: TextAlign.start,
                      )),
                  DropdownButtonFormField(
                    value: criticalIllnessInsuranceController.selectPlaceOfResidence,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    hint: Text('Select'),
                    onChanged: (newValue) {
                      setState(() {
                        criticalIllnessInsuranceController.selectPlaceOfResidence = newValue!;
                      });
                    },
                    items: ['item1', 'item2', 'item3']
                        .map((gender) => DropdownMenuItem(
                              child: Text(gender),
                              value: gender,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),*/
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        GetCountryList cdl = criticalIllnessInsuranceController.placeResidenceList.firstWhere((element) => element.id == newValue);
                        criticalIllnessInsuranceController.selectPlaceResidence.value = cdl;
                      });
                    },
                    items: criticalIllnessInsuranceController.placeResidenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: criticalIllnessInsuranceController.placeResidenceList.any((element) => element.id == criticalIllnessInsuranceController.selectPlaceResidence.value.id) ? criticalIllnessInsuranceController.selectPlaceResidence.value.id ?? 0 : null,
                    dropdownTitle: placeofresidence,
                  ),

                  /* AppTextfield(
              width: 10,
              hint: occupancy,
              lable: occupancy,
              controller: criticalIllnessInsuranceController.occupancyController.value,
            ),*/

                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        OccuptionList cdl = criticalIllnessInsuranceController.occupationList.firstWhere((element) => element.id == newValue);
                        criticalIllnessInsuranceController.selectOccupation.value = cdl;
                      });
                    },
                    items: criticalIllnessInsuranceController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: criticalIllnessInsuranceController.occupationList.any((element) => element.id == criticalIllnessInsuranceController.selectOccupation.value.id) ? criticalIllnessInsuranceController.selectOccupation.value.id ?? 0 : null,
                    dropdownTitle: occupancy,
                  ),
                  SizedBox(height: 10),

                  /*InkWell(
              onTap: () => widget.onNext(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(nextImg)),
                  ),
                ),
              ),
            ),*/

                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: AppBtnWithColorShades(
                      onTap: () {
                        if (criticalIllnessInsuranceController.beneficiaryFirstNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneficiaryFirstName, txtColor: primaryWhite, size: 12)));
                        } else if (criticalIllnessInsuranceController.beneficiarySecondNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneficiarySecondName, txtColor: primaryWhite, size: 12)));
                        } else if (criticalIllnessInsuranceController.beneficiaryThirdNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneficiaryThirdName, txtColor: primaryWhite, size: 12)));
                        } else if (criticalIllnessInsuranceController.beneficiaryFamilyNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneficiaryFamilyName, txtColor: primaryWhite, size: 12)));
                        } else if (criticalIllnessInsuranceController.selectedMaritalStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMaritalStatus, txtColor: primaryWhite, size: 12)));
                        } else if (criticalIllnessInsuranceController.selectPlaceResidence.value.name == null) {
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

  startDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(1901), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      setState(() {
        criticalIllnessInsuranceController.birthDateController.value.text = formattedDate; //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
