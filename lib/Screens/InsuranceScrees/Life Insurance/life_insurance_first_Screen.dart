import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Life%20Insurance/life_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class LifeInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  LifeInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<LifeInsuranceFirstScreen> createState() => _LifeInsuranceFirstScreenState();
}

class _LifeInsuranceFirstScreenState extends State<LifeInsuranceFirstScreen> {
  LifeInsuranceController lifeInsuranceController = Get.put(LifeInsuranceController());

  @override
  void initState() {
    lifeInsuranceController.init(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return lifeInsuranceController.isLoading.value
          ? const Padding(
              padding: EdgeInsets.only(top: 140),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextfield(
                    width: 10,
                    hint: policyHolderFirstName,
                    lable: policyHolderFirstName,
                    controller: lifeInsuranceController.policyHolderFirstNameController.value,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderSecondName,
                    lable: policyHolderSecondName,
                    controller: lifeInsuranceController.policyHolderSecondNameController.value,
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderThirdName,
                    lable: policyHolderThirdName,
                    controller: lifeInsuranceController.policyHolderThirdNameController.value,
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderFamilyName,
                    lable: policyHolderFamilyName,
                    controller: lifeInsuranceController.policyHolderFamilyNameController.value,
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = lifeInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        lifeInsuranceController.selectNatonality.value = cdl;
                      });
                    },
                    items: lifeInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: lifeInsuranceController.nationalityList.any((element) => element.id == lifeInsuranceController.selectNatonality.value.id) ? lifeInsuranceController.selectNatonality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: nationalnopassport,
                    lable: nationalnopassport,
                    controller: lifeInsuranceController.nationPassportNoController.value,
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: residenceno,
                    lable: residenceno,
                    controller: lifeInsuranceController.idOrResidenceNoController.value,
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: birthdate,
                    lable: birthdate,
                    controller: lifeInsuranceController.birthDateController.value,
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        lifeInsuranceController.selectedgender = newValue!;
                      });
                    },
                    items: lifeInsuranceController.genderList,
                    selectedValue: lifeInsuranceController.selectedgender,
                    dropdownTitle: selectgender,
                  ),
                  SizedBox(height: 10),
                  AppTextfield(width: 10, hint: beneficiaryFirstName, lable: beneficiaryFirstName, controller: lifeInsuranceController.beneficiaryFirstNameController.value),
                  SizedBox(height: 20),
                  AppTextfield(width: 10, hint: beneficiarySecondName, lable: beneficiarySecondName, controller: lifeInsuranceController.beneficiarySecondNameController.value),
                  SizedBox(height: 20),
                  AppTextfield(width: 10, hint: beneficiaryThirdName, lable: beneficiaryThirdName, controller: lifeInsuranceController.beneficiaryThirdNameController.value),
                  SizedBox(height: 20),
                  AppTextfield(width: 10, hint: beneficiaryFamilyName, lable: beneficiaryFamilyName, controller: lifeInsuranceController.beneficiaryFamilyNameController.value),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        lifeInsuranceController.selectedMaritalStatus = newValue!;
                      });
                    },
                    items: lifeInsuranceController.maritalStatusList,
                    selectedValue: lifeInsuranceController.selectedMaritalStatus,
                    dropdownTitle: mrgstatus,
                  ),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        GetCountryList cdl = lifeInsuranceController.placeResidenceList.firstWhere((element) => element.id == newValue);
                        lifeInsuranceController.selectPlaceResidence.value = cdl;
                      });
                    },
                    items: lifeInsuranceController.placeResidenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: lifeInsuranceController.placeResidenceList.any((element) => element.id == lifeInsuranceController.selectPlaceResidence.value.id) ? lifeInsuranceController.selectPlaceResidence.value.id ?? 0 : null,
                    dropdownTitle: placeofresidence,
                  ),
                  SizedBox(height: 20),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        OccuptionList cdl = lifeInsuranceController.occupationList.firstWhere((element) => element.id == newValue);
                        lifeInsuranceController.selectOccupation.value = cdl;
                      });
                    },
                    items: lifeInsuranceController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: lifeInsuranceController.occupationList.any((element) => element.id == lifeInsuranceController.selectOccupation.value.id) ? lifeInsuranceController.selectOccupation.value.id ?? 0 : null,
                    dropdownTitle: occupancy,
                  ),
                  SizedBox(height: 10),
                  AppText(text: americanNationality, size: 15, txtAlign: TextAlign.start),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: lifeInsuranceController.selectAmericanNationality,
                        onChanged: (value) {
                          setState(() {
                            lifeInsuranceController.selectAmericanNationality = value!;
                          });
                        },
                      ),
                      AppText(text: yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: lifeInsuranceController.selectAmericanNationality,
                        onChanged: (value) {
                          setState(() {
                            lifeInsuranceController.selectAmericanNationality = value!;
                          });
                        },
                      ),
                      AppText(text: noTxt),
                    ],
                  ),
                  lifeInsuranceController.selectAmericanNationality == yesTxt
                      ? AppText(
                          text: lifeerror,
                          size: 14,
                          txtColor: Colors.red,
                        )
                      : const SizedBox(),
                  lifeInsuranceController.selectAmericanNationality == yesTxt
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AppBtnWithColorShades(
                            onTap: () {
                              if (lifeInsuranceController.beneficiaryFirstNameController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneiciarysFirstName, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.beneficiarySecondNameController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneiciarysSecondName, txtColor: primaryWhite, size: 12)));
                              }/* else if (lifeInsuranceController.beneficiaryThirdNameController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneiciarysThirdName, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.beneficiaryFamilyNameController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBeneiciarysFamilyName, txtColor: primaryWhite, size: 12)));
                              }*/ else if (lifeInsuranceController.selectedMaritalStatus == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMaritalStatus, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.selectAmericanNationality == '') {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectNationality, txtColor: primaryWhite, size: 12)));
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
