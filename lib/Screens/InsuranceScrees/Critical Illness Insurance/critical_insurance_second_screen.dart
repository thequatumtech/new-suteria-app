import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_illness_insurance_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

class CriticalInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  CriticalInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<CriticalInsuranceSecondScreen> createState() => _CriticalInsuranceSecondScreenState();
}

class _CriticalInsuranceSecondScreenState extends State<CriticalInsuranceSecondScreen> {
  CriticalIllnessInsuranceController criticalIllnessInsuranceController = Get.put(CriticalIllnessInsuranceController());



  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: homeaddress,
              size: 16,
              fontWeight: FontWeight.bold,
              txtAlign: TextAlign.start,
            ),
            CustomDropDownBorderDisable(
              onchage: (newValue) {
                setState(() {
                  CityListModel cdl = criticalIllnessInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                  criticalIllnessInsuranceController.selectCity.value = cdl;
                });
              },
              items: criticalIllnessInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: criticalIllnessInsuranceController.cityList.any((element) => element.id == criticalIllnessInsuranceController.selectCity.value.id) ? criticalIllnessInsuranceController.selectCity.value.id ?? 0 : null,
              dropdownTitle: selectccity,
            ),
            CustomDropDownBorderDisable(
              onchage: (newValue) {
                setState(() {
                  DistrictList cdl = criticalIllnessInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                  criticalIllnessInsuranceController.selectDistrict.value = cdl;
                });
              },
              items: criticalIllnessInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: criticalIllnessInsuranceController.districtList.any((element) => element.id == criticalIllnessInsuranceController.selectDistrict.value.id) ? criticalIllnessInsuranceController.selectDistrict.value.id ?? 0 : null,
              dropdownTitle: selectdistricct,
            ),
            AppTextfield(
              //controller: _plotNoController,
              width: 10,
              hint: streetname,
              lable: streetname,
              readOnly: true,
              controller: criticalIllnessInsuranceController.streetNameController.value,
            ),
            const SizedBox(height: 10),
            AppTextfield(
              controller: criticalIllnessInsuranceController.buildingNoController.value,
              width: 10,
              readOnly: true,
              hint: buildingno,
              lable: buildingno,
            ),
            getProfileModelGlobal.data?.employmentType != null
                ? getProfileModelGlobal.data?.employmentType == employed
                    ? Column(
                        children: [
                          const SizedBox(height: 10),
                          AppTextfield(
                            controller: criticalIllnessInsuranceController.companyNameController.value,
                            width: 10,
                            readOnly: true,
                            hint: companyname,
                            lable: companyname,
                          ),
                          SizedBox(height: 10),
                          AppTextfield(
                            controller: criticalIllnessInsuranceController.positionController.value,
                            width: 10,
                            readOnly: true,
                            hint: position,
                            lable: position,
                          ),
                          SizedBox(height: 10),
                          AppTextfield(
                            controller: criticalIllnessInsuranceController.workNatureController.value,
                            width: 10,
                            readOnly: true,
                            hint: worknature,
                            lable: worknature,
                          ),
                          SizedBox(height: 10),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                CityListModel cdl = criticalIllnessInsuranceController.companyCityList.firstWhere((element) => element.id == newValue);
                                criticalIllnessInsuranceController.selectCompanyCity.value = cdl;
                              });
                            },
                            items: criticalIllnessInsuranceController.companyCityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: criticalIllnessInsuranceController.companyCityList.any((element) => element.id == criticalIllnessInsuranceController.selectCompanyCity.value.id) ? criticalIllnessInsuranceController.selectCompanyCity.value.id ?? 0 : null,
                            dropdownTitle: selectccity,
                          ),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                DistrictList cdl = criticalIllnessInsuranceController.companyDistrictList.firstWhere((element) => element.id == newValue);
                                criticalIllnessInsuranceController.selectCompanyDistrict.value = cdl;
                              });
                            },
                            items: criticalIllnessInsuranceController.companyDistrictList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: criticalIllnessInsuranceController.companyDistrictList.any((element) => element.id == criticalIllnessInsuranceController.selectCompanyDistrict.value.id) ? criticalIllnessInsuranceController.selectCompanyDistrict.value.id ?? 0 : null,
                            dropdownTitle: selectdistricct,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextfield(
                            //controller: _plotNoController,
                            width: 10,
                            hint: streetname,
                            readOnly: true,
                            lable: streetname,
                            controller: criticalIllnessInsuranceController.companyStreetNameController.value,
                          ),
                          SizedBox(height: 10),
                          AppTextfield(
                            readOnly: true,
                            controller: criticalIllnessInsuranceController.companyBuildingNoController.value,
                            width: 10,
                            hint: buildingno,
                            lable: buildingno,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextfield(
                            readOnly: true,
                            controller: criticalIllnessInsuranceController.companyContactNoController.value,
                            width: 10,
                            hint: companycontact,
                            lable: companycontact,
                          ),
                        ],
                      )
                    : const SizedBox()
                : const SizedBox(),
            const SizedBox(height: 20),

            /*InkWell(
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
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
