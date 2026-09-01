import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_medical_insurance_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class IndividualPersonalInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  IndividualPersonalInsuranceFirstScreen({Key? key, required this.onNext}) : super(key: key);

  @override
  State<IndividualPersonalInsuranceFirstScreen> createState() => _IndividualPersonalInsuranceFirstScreenState();
}

class _IndividualPersonalInsuranceFirstScreenState extends State<IndividualPersonalInsuranceFirstScreen> {
  IndividualMedicalInsuranceController individualMedicalInsuranceController = Get.put(IndividualMedicalInsuranceController());

  @override
  void initState() {
    individualMedicalInsuranceController.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return individualMedicalInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Added space
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderFirstName, lable: policyHolderFirstName, controller: individualMedicalInsuranceController.policyHolderFirstNameController.value),
                  const SizedBox(height: 20),
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderSecondName, lable: policyHolderSecondName, controller: individualMedicalInsuranceController.policyHolderSecondNameController.value),
                  const SizedBox(height: 20),

                  AppTextfield(width: 10, readOnly: true, hint: policyHolderThirdName, lable: policyHolderThirdName, controller: individualMedicalInsuranceController.policyHolderThirdNameController.value),
                  const SizedBox(height: 20),
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderFamilyName, lable: policyHolderFamilyName, controller: individualMedicalInsuranceController.policyHolderFamilyNameController.value),
                  const SizedBox(height: 20),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = individualMedicalInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        individualMedicalInsuranceController.selectNationality.value = cdl;
                      });
                    },
                    items: individualMedicalInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: individualMedicalInsuranceController.nationalityList.any((element) => element.id == individualMedicalInsuranceController.selectNationality.value.id) ? individualMedicalInsuranceController.selectNationality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),

                  const SizedBox(height: 20), // Added space
                  AppTextfield(width: 10, readOnly: true, hint: nationalnopassport, lable: nationalnopassport, controller: individualMedicalInsuranceController.nationPassportNoController.value),
                  const SizedBox(height: 20), // Added space
                  AppTextfield(width: 10, readOnly: true, hint: residenceno, lable: residenceno, controller: individualMedicalInsuranceController.idOrResidenceNoController.value),
                  const SizedBox(height: 20), // Added space
                  AppTextfield(width: 10, readOnly: true, hint: birthdate, lable: birthdate, controller: individualMedicalInsuranceController.birthDateController.value),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        individualMedicalInsuranceController.selectedGender = newValue!;
                      });
                    },
                    items: individualMedicalInsuranceController.genderList,
                    selectedValue: individualMedicalInsuranceController.selectedGender,
                    dropdownTitle: selectgender,
                  ),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        individualMedicalInsuranceController.selectedMaritalStatus = newValue!;
                      });
                    },
                    items: individualMedicalInsuranceController.maritalStatusList,
                    selectedValue: individualMedicalInsuranceController.selectedMaritalStatus,
                    dropdownTitle: mrgstatus,
                  ),
                  const SizedBox(height: 10), // Added space
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        OccuptionList cdl = individualMedicalInsuranceController.occupationList.firstWhere((element) => element.id == newValue);
                        individualMedicalInsuranceController.selectOccupation.value = cdl;
                      });
                    },
                    items: individualMedicalInsuranceController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: individualMedicalInsuranceController.occupationList.any((element) => element.id == individualMedicalInsuranceController.selectOccupation.value.id) ? individualMedicalInsuranceController.selectOccupation.value.id ?? 0 : null,
                    dropdownTitle: occupancy,
                  ),
                  const SizedBox(height: 10), // Added space
                  AppText(
                    text: homeaddress,
                    size: 16,
                    fontWeight: FontWeight.bold,
                    txtAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20), // Added space
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        CityListModel cdl = individualMedicalInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                        individualMedicalInsuranceController.selectCity.value = cdl;
                      });
                    },
                    items: individualMedicalInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: individualMedicalInsuranceController.cityList.any((element) => element.id == individualMedicalInsuranceController.selectCity.value.id) ? individualMedicalInsuranceController.selectCity.value.id ?? 0 : null,
                    dropdownTitle: selectccity,
                  ),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        DistrictList cdl = individualMedicalInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                        individualMedicalInsuranceController.selectDistrict.value = cdl;
                      });
                    },
                    items: individualMedicalInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: individualMedicalInsuranceController.districtList.any((element) => element.id == individualMedicalInsuranceController.selectDistrict.value.id) ? individualMedicalInsuranceController.selectDistrict.value.id ?? 0 : null,
                    dropdownTitle: selectdistricct,
                  ),
                  AppTextfield(
                    width: 10,
                    hint: streetname,
                    lable: streetname,
                    readOnly: true,
                    controller: individualMedicalInsuranceController.streetNameController.value,
                  ),
                  const SizedBox(height: 20), // Added space
                  AppTextfield(
                    controller: individualMedicalInsuranceController.buildingNoController.value,
                    width: 10,
                    readOnly: true,
                    hint: buildingno,
                    lable: buildingno,
                  ),

                  if (getProfileModelGlobal.data?.employmentType != null)
                    if (getProfileModelGlobal.data?.employmentType == employed)
                      Column(
                        children: [
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: individualMedicalInsuranceController.companyNameController.value,
                            width: 10,
                            readOnly: true,
                            hint: companyname,
                            lable: companyname,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: individualMedicalInsuranceController.positionController.value,
                            width: 10,
                            readOnly: true,
                            hint: position,
                            lable: position,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: individualMedicalInsuranceController.workNatureController.value,
                            width: 10,
                            hint: worknature,
                            readOnly: true,
                            lable: worknature,
                          ),
                          const SizedBox(height: 20), // Added space
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                CityListModel cdl = individualMedicalInsuranceController.companyCityList.firstWhere((element) => element.id == newValue);
                                individualMedicalInsuranceController.selectCompanyCity.value = cdl;
                              });
                            },
                            items: individualMedicalInsuranceController.companyCityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: individualMedicalInsuranceController.companyCityList.any((element) => element.id == individualMedicalInsuranceController.selectCompanyCity.value.id) ? individualMedicalInsuranceController.selectCompanyCity.value.id ?? 0 : null,
                            dropdownTitle: selectccity,
                          ),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                DistrictList cdl = individualMedicalInsuranceController.companyDistrictList.firstWhere((element) => element.id == newValue);
                                individualMedicalInsuranceController.selectCompanyDistrict.value = cdl;
                              });
                            },
                            items: individualMedicalInsuranceController.companyDistrictList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: individualMedicalInsuranceController.companyDistrictList.any((element) => element.id == individualMedicalInsuranceController.selectCompanyDistrict.value.id) ? individualMedicalInsuranceController.selectCompanyDistrict.value.id ?? 0 : null,
                            dropdownTitle: selectdistricct,
                          ),
                          AppTextfield(
                            width: 10,
                            hint: streetname,
                            readOnly: true,
                            lable: streetname,
                            controller: individualMedicalInsuranceController.companyStreetNameController.value,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: individualMedicalInsuranceController.companyBuildingNoController.value,
                            width: 10,
                            readOnly: true,
                            hint: buildingno,
                            lable: buildingno,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: individualMedicalInsuranceController.companyContactNoController.value,
                            width: 10,
                            readOnly: true,
                            hint: companycontact,
                            lable: companycontact,
                          ),
                        ],
                      ),

                  const SizedBox(height: 20),
                  AppText(text: americanNationality, size: 15, txtAlign: TextAlign.start),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: individualMedicalInsuranceController.selectAmericanNationality,
                        onChanged: (value) {
                          setState(() {
                            individualMedicalInsuranceController.selectAmericanNationality = value!;
                          });
                        },
                      ),
                      AppText(text: yesTxt, size: 14),
                      Radio(
                        value: noTxt,
                        groupValue: individualMedicalInsuranceController.selectAmericanNationality,
                        onChanged: (value) {
                          setState(() {
                            individualMedicalInsuranceController.selectAmericanNationality = value!;
                          });
                        },
                      ),
                      AppText(text: noTxt, size: 14),
                    ],
                  ),
                  individualMedicalInsuranceController.selectAmericanNationality == yesTxt
                      ? AppText(
                          text: lifeerror,
                          size: 14,
                          txtColor: Colors.red,
                        )
                      : const SizedBox(),
                  individualMedicalInsuranceController.selectAmericanNationality == yesTxt
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AppBtnWithColorShades(
                            onTap: () {
                              if (individualMedicalInsuranceController.selectAmericanNationality == '') {
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
                  const SizedBox(height: 20),
                ],
              ),
            );
    });
  }
}
