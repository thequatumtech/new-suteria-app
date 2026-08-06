import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/family_medical_insurance_controller.dart';
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

class IndividualFamilyInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  IndividualFamilyInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<IndividualFamilyInsuranceFirstScreen> createState() => _IndividualFamilyInsuranceFirstScreenState();
}

class _IndividualFamilyInsuranceFirstScreenState extends State<IndividualFamilyInsuranceFirstScreen> {
  FamilyMedicalInsuranceController familyMedicalInsuranceController = Get.put(FamilyMedicalInsuranceController());

  @override
  void initState() {
    familyMedicalInsuranceController.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return familyMedicalInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  AppTextfield(width: 10, hint: policyHolderFirstName, lable: policyHolderFirstName, controller: familyMedicalInsuranceController.policyHolderFirstNameController.value, readOnly: true),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, hint: policyHolderSecondName, lable: policyHolderSecondName, controller: familyMedicalInsuranceController.policyHolderSecondNameController.value, readOnly: true),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, hint: policyHolderThirdName, lable: policyHolderThirdName, controller: familyMedicalInsuranceController.policyHolderThirdNameController.value, readOnly: true),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, hint: policyHolderFamilyName, lable: policyHolderFamilyName, controller: familyMedicalInsuranceController.policyHolderFamilyNameController.value, readOnly: true),
                  const SizedBox(height: 10),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = familyMedicalInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        familyMedicalInsuranceController.selectNationality.value = cdl;
                      });
                    },
                    items: familyMedicalInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: familyMedicalInsuranceController.nationalityList.any((element) => element.id == familyMedicalInsuranceController.selectNationality.value.id) ? familyMedicalInsuranceController.selectNationality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, hint: nationalnopassport, lable: nationalnopassport, controller: familyMedicalInsuranceController.nationPassportNoController.value, readOnly: true),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, hint: residenceno, lable: residenceno, controller: familyMedicalInsuranceController.idOrResidenceNoController.value, readOnly: true),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, hint: birthdate, lable: birthdate, controller: familyMedicalInsuranceController.birthDateController.value, readOnly: true),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        familyMedicalInsuranceController.selectedGender = newValue!;
                      });
                    },
                    items: familyMedicalInsuranceController.genderList,
                    selectedValue: familyMedicalInsuranceController.selectedGender,
                    dropdownTitle: selectgender,
                  ),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        familyMedicalInsuranceController.selectedMaritalStatus = newValue!;
                      });
                    },
                    items: familyMedicalInsuranceController.maritalStatusList,
                    selectedValue: familyMedicalInsuranceController.selectedMaritalStatus,
                    dropdownTitle: mrgstatus,
                  ),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        OccuptionList cdl = familyMedicalInsuranceController.occupationList.firstWhere((element) => element.id == newValue);
                        familyMedicalInsuranceController.selectOccupation.value = cdl;
                      });
                    },
                    items: familyMedicalInsuranceController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: familyMedicalInsuranceController.occupationList.any((element) => element.id == familyMedicalInsuranceController.selectOccupation.value.id) ? familyMedicalInsuranceController.selectOccupation.value.id ?? 0 : null,
                    dropdownTitle: occupancy,
                  ),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.topLeft,
                      child: AppText(
                        text: homeaddress,
                        size: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        CityListModel cdl = familyMedicalInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                        familyMedicalInsuranceController.selectCity.value = cdl;
                      });
                    },
                    items: familyMedicalInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: familyMedicalInsuranceController.cityList.any((element) => element.id == familyMedicalInsuranceController.selectCity.value.id) ? familyMedicalInsuranceController.selectCity.value.id ?? 0 : null,
                    dropdownTitle: selectccity,
                  ),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        DistrictList cdl = familyMedicalInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                        familyMedicalInsuranceController.selectDistrict.value = cdl;
                      });
                    },
                    items: familyMedicalInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: familyMedicalInsuranceController.districtList.any((element) => element.id == familyMedicalInsuranceController.selectDistrict.value.id) ? familyMedicalInsuranceController.selectDistrict.value.id ?? 0 : null,
                    dropdownTitle: selectdistricct,
                  ),
                  const SizedBox(height: 4),
                  AppTextfield(width: 10, hint: streetname, lable: streetname, controller: familyMedicalInsuranceController.streetNameController.value, readOnly: true),
                  const SizedBox(height: 10),
                  AppTextfield(controller: familyMedicalInsuranceController.buildingNoController.value, width: 10, hint: buildingno, lable: buildingno, readOnly: true),
                  if (getProfileModelGlobal.data?.employmentType != null)
                    if (getProfileModelGlobal.data?.employmentType == employed)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          AppTextfield(controller: familyMedicalInsuranceController.companyNameController.value, width: 10, hint: companyname, lable: companyname, readOnly: true),
                          const SizedBox(height: 10),
                          AppTextfield(controller: familyMedicalInsuranceController.positionController.value, width: 10, hint: position, lable: position, readOnly: true),
                          const SizedBox(height: 10),
                          AppTextfield(controller: familyMedicalInsuranceController.workNatureController.value, width: 10, hint: worknature, lable: worknature, readOnly: true),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                CityListModel cdl = familyMedicalInsuranceController.companyCityList.firstWhere((element) => element.id == newValue);
                                familyMedicalInsuranceController.selectCompanyCity.value = cdl;
                              });
                            },
                            items: familyMedicalInsuranceController.companyCityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: familyMedicalInsuranceController.companyCityList.any((element) => element.id == familyMedicalInsuranceController.selectCompanyCity.value.id) ? familyMedicalInsuranceController.selectCompanyCity.value.id ?? 0 : null,
                            dropdownTitle: selectccity,
                          ),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                DistrictList cdl = familyMedicalInsuranceController.companyDistrictList.firstWhere((element) => element.id == newValue);
                                familyMedicalInsuranceController.selectCompanyDistrict.value = cdl;
                              });
                            },
                            items: familyMedicalInsuranceController.companyDistrictList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: familyMedicalInsuranceController.companyDistrictList.any((element) => element.id == familyMedicalInsuranceController.selectCompanyDistrict.value.id) ? familyMedicalInsuranceController.selectCompanyDistrict.value.id ?? 0 : null,
                            dropdownTitle: selectdistricct,
                          ),
                          AppTextfield(width: 10, hint: streetname, lable: streetname, controller: familyMedicalInsuranceController.companyStreetNameController.value, readOnly: true),
                          const SizedBox(height: 10),
                          AppTextfield(controller: familyMedicalInsuranceController.companyBuildingNoController.value, width: 10, hint: buildingno, lable: buildingno, readOnly: true),
                          const SizedBox(height: 10),
                          AppTextfield(controller: familyMedicalInsuranceController.companyContactNoController.value, width: 10, hint: companycontact, lable: companycontact, readOnly: true),
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
      print(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      print(formattedDate);

      setState(() {
        familyMedicalInsuranceController.birthDateController.value.text = formattedDate; //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
