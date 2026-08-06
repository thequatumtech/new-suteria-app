import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

class DentalInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  DentalInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<DentalInsuranceSecondScreen> createState() => _DentalInsuranceSecondScreenState();
}

class _DentalInsuranceSecondScreenState extends State<DentalInsuranceSecondScreen> {
  DentalInsuranceController dentalInsuranceController = Get.put(DentalInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            CustomDropDownBorderDisable(
              onchage: (newValue) {
                setState(() {
                  CityListModel cdl = dentalInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                  dentalInsuranceController.selectCity.value = cdl;
                });
              },
              items: dentalInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: dentalInsuranceController.cityList.any((element) => element.id == dentalInsuranceController.selectCity.value.id) ? dentalInsuranceController.selectCity.value.id ?? 0 : null,
              dropdownTitle: selectccity,
            ),
            CustomDropDownBorderDisable(
              onchage: (newValue) {
                setState(() {
                  DistrictList cdl = dentalInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                  dentalInsuranceController.selectDistrict.value = cdl;
                });
              },
              items: dentalInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: dentalInsuranceController.districtList.any((element) => element.id == dentalInsuranceController.selectDistrict.value.id) ? dentalInsuranceController.selectDistrict.value.id ?? 0 : null,
              dropdownTitle: selectdistricct,
            ),
            SizedBox(height: 20), // Added space
            AppTextfield(
              width: 10,
              hint: streetname,
              lable: streetname,
              controller: dentalInsuranceController.streetNameController.value,
              readOnly: true,
            ),
            SizedBox(height: 20), // Added space
            AppTextfield(
              controller: dentalInsuranceController.buildingNoController.value,
              width: 10,
              hint: buildingno,
              lable: buildingno,
              readOnly: true,
            ),
            SizedBox(height: 20),
            // Added space

            getProfileModelGlobal.data?.employmentType != null
                ? getProfileModelGlobal.data?.employmentType == employed
                    ? Column(
                        children: [
                          AppTextfield(
                            controller: dentalInsuranceController.companyNameController.value,
                            width: 10,
                            hint: companyname,
                            lable: companyname,
                            readOnly: true,
                          ),
                          SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: dentalInsuranceController.positionController.value,
                            width: 10,
                            hint: position,
                            lable: position,
                            readOnly: true,
                          ),
                          SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: dentalInsuranceController.workNatureController.value,
                            width: 10,
                            hint: worknature,
                            lable: worknature,
                          ),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                CityListModel cdl = dentalInsuranceController.companyCityList.firstWhere((element) => element.id == newValue);
                                dentalInsuranceController.selectCompanyCity.value = cdl;
                              });
                            },
                            items: dentalInsuranceController.companyCityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: dentalInsuranceController.companyCityList.any((element) => element.id == dentalInsuranceController.selectCompanyCity.value.id) ? dentalInsuranceController.selectCompanyCity.value.id ?? 0 : null,
                            dropdownTitle: selectccity,
                          ),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                DistrictList cdl = dentalInsuranceController.companyDistrictList.firstWhere((element) => element.id == newValue);
                                dentalInsuranceController.selectCompanyDistrict.value = cdl;
                              });
                            },
                            items: dentalInsuranceController.companyDistrictList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: dentalInsuranceController.companyDistrictList.any((element) => element.id == dentalInsuranceController.selectCompanyDistrict.value.id) ? dentalInsuranceController.selectCompanyDistrict.value.id ?? 0 : null,
                            dropdownTitle: selectdistricct,
                          ),
                          AppTextfield(
                            width: 10,
                            hint: streetname,
                            lable: streetname,
                            readOnly: true,
                            controller: dentalInsuranceController.companyStreetNameController.value,
                          ),
                          SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: dentalInsuranceController.companyBuildingNoController.value,
                            width: 10,
                            hint: buildingno,
                            readOnly: true,
                            lable: buildingno,
                          ),
                          SizedBox(height: 20), // Added space
                          AppTextfield(
                            controller: dentalInsuranceController.companyContactNoController.value,
                            width: 10,
                            readOnly: true,
                            hint: companycontact,
                            lable: companycontact,
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                    : const SizedBox()
                : const SizedBox(), // Added space
            /* InkWell(
              onTap: () => widget.onNext(),
              child: Image.asset(nextImg),
            ),*/
            AppBtnWithColorShades(
              onTap: () {
                widget.onNext();
              },
              btnTxt: next,
              color1: darkBlue2,
              color2: darkBlue1,
            ),
            SizedBox(height: 20), // Added space
          ],
        ),
      ),
    );
  }
}
