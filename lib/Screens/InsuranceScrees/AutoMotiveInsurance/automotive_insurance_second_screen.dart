import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/motor_insurance_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

class AutomotiveInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  AutomotiveInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<AutomotiveInsuranceSecondScreen> createState() => _AutomotiveInsuranceSecondScreenState();
}

class _AutomotiveInsuranceSecondScreenState extends State<AutomotiveInsuranceSecondScreen> {
  MotorInsuranceController motorInsuranceController = Get.put(MotorInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => motorInsuranceController.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: homeaddress1,
                    size: 16,
                    fontWeight: FontWeight.bold,
                    txtAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20), // Added space

                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        CityListModel cdl = motorInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                        motorInsuranceController.selectCity.value = cdl;
                      });
                    },
                    items: motorInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: motorInsuranceController.cityList.any((element) => element.id == motorInsuranceController.selectCity.value.id) ? motorInsuranceController.selectCity.value.id ?? 0 : null,
                    dropdownTitle: selectccity,
                  ),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        DistrictList cdl = motorInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                        motorInsuranceController.selectDistrict.value = cdl;
                      });
                    },
                    items: motorInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: motorInsuranceController.districtList.any((element) => element.id == motorInsuranceController.selectDistrict.value.id) ? motorInsuranceController.selectDistrict.value.id ?? 0 : null,
                    dropdownTitle: selectdistricct,
                  ),
                  const SizedBox(height: 20), // Added space
                  AppTextfield(
                    width: 10,
                    hint: streetname,
                    lable: streetname,
                    readOnly: true,
                    controller: motorInsuranceController.streetNameController.value,
                  ),
                  const SizedBox(height: 20), // Added space
                  AppTextfield(
                    controller: motorInsuranceController.buildingNoController.value,
                    width: 10,
                    hint: buildingno,
                    lable: buildingno,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20), // Added space
                  AppTextfield(
                    controller: motorInsuranceController.userMobileNoController.value,
                    width: 10,
                    hint: usermobno,
                    lable: usermobno,
                    readOnly: true,
                  ),

                  if (getProfileModelGlobal.data?.employmentType != null)
                    if (getProfileModelGlobal.data?.employmentType == employed)
                      Column(
                        children: [
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: motorInsuranceController.companyNameController.value,
                            width: 10,
                            hint: companyname,
                            lable: companyname,
                            readOnly: true,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: motorInsuranceController.positionController.value,
                            width: 10,
                            hint: position,
                            lable: position,
                            readOnly: true,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: motorInsuranceController.workOfNatureController.value,
                            width: 10,
                            hint: worknature,
                            lable: worknature,
                            readOnly: true,
                          ),
                          // Added space
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                CityListModel cdl = motorInsuranceController.companyCityList.firstWhere((element) => element.id == newValue);
                                motorInsuranceController.selectCompanyCity.value = cdl;
                              });
                            },
                            items: motorInsuranceController.companyCityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: motorInsuranceController.companyCityList.any((element) => element.id == motorInsuranceController.selectCompanyCity.value.id) ? motorInsuranceController.selectCompanyCity.value.id ?? 0 : null,
                            dropdownTitle: selectccity,
                          ),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                DistrictList cdl = motorInsuranceController.companyDistrictList.firstWhere((element) => element.id == newValue);
                                motorInsuranceController.selectCompanyDistrict.value = cdl;
                              });
                            },
                            items: motorInsuranceController.companyDistrictList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: motorInsuranceController.companyDistrictList.any((element) => element.id == motorInsuranceController.selectCompanyDistrict.value.id) ? motorInsuranceController.selectCompanyDistrict.value.id ?? 0 : null,
                            dropdownTitle: selectdistricct,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            width: 10,
                            hint: streetname,
                            lable: streetname,
                            readOnly: true,
                            controller: motorInsuranceController.companyStreetNameController.value,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: motorInsuranceController.companyBuildingNoController.value,
                            width: 10,
                            hint: buildingno,
                            readOnly: true,
                            lable: buildingno,
                          ),
                          const SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: motorInsuranceController.companyContactNoController.value,
                            keyboardType: TextInputType.number,
                            width: 10,
                            hint: companycontact,
                            lable: companycontact,
                            readOnly: true,
                          ),
                        ],
                      ),

                  const SizedBox(height: 20), // Added space
                  AppBtnWithColorShades(
                    onTap: () {
                      widget.onNext();
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                  const SizedBox(height: 20), // Added space
                ],
              ),
            ),
          ));
  }
}
