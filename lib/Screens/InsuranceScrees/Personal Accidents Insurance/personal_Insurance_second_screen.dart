import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_insurance_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

import '../../../app_utils/app_textfileds.dart';

class PersonalInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  PersonalInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<PersonalInsuranceSecondScreen> createState() => _PersonalInsuranceSecondScreenState();
}

class _PersonalInsuranceSecondScreenState extends State<PersonalInsuranceSecondScreen> {
  PersonalInsuranceController personalInsuranceController = Get.put(PersonalInsuranceController());

@override
  void initState() {

  if(getProfileModelGlobal.data?.employmentType != null) {
    getProfileModelGlobal.data?.employmentType == employed?personalInsuranceController.selectedOption1=yesTxt:personalInsuranceController.selectedOption1=noTxt;
  }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => personalInsuranceController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                /*  getProfileModelGlobal.data?.employmentType != null
                      ? getProfileModelGlobal.data?.employmentType == employed
                          ?*/



                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: AppText(text: lifeq2, size: 15, txtAlign: TextAlign.start),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: personalInsuranceController.selectedOption1,
                        onChanged: (value) {
                          setState(() {
                            personalInsuranceController.selectedOption1 = value!;
                          });
                        },
                      ),
                      const Text(yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: personalInsuranceController.selectedOption1,
                        onChanged: (value) {
                          setState(() {
                            personalInsuranceController.selectedOption1 = value!;
                          });
                        },
                      ),
                      const Text(noTxt),
                    ],
                  ),
                  if (personalInsuranceController.selectedOption1 == yesTxt)Column(
                              children: [
                                AppTextfield(hint: companyname, readOnly: true, lable: companyname, controller: personalInsuranceController.companyNameController.value),
                                const SizedBox(height: 10),
                                AppTextfield(
                                  controller: personalInsuranceController.positionController.value,
                                  width: 10,
                                  hint: position,
                                  /*readOnly: true,*/
                                  lable: position,
                                ),
                                const SizedBox(height: 10),
                                AppTextfield(
                                  controller: personalInsuranceController.workNatureController.value,
                                  width: 10,
                                  hint: worknature,
                                  lable: worknature,
                                ),
                                CustomDropDownBorderDisable(
                                  onchage: (newValue) {
                                    setState(() {
                                      CityListModel cdl = personalInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                                      personalInsuranceController.selectCity.value = cdl;
                                    });
                                  },
                                  items: personalInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                  selectedValue: personalInsuranceController.cityList.any((element) => element.id == personalInsuranceController.selectCity.value.id) ? personalInsuranceController.selectCity.value.id ?? 0 : null,
                                  dropdownTitle: selectccity,
                                ),
                                CustomDropDownBorderDisable(
                                  onchage: (newValue) {
                                    setState(() {
                                      DistrictList cdl = personalInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                                      personalInsuranceController.selectDistrict.value = cdl;
                                    });
                                  },
                                  items: personalInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                  selectedValue: personalInsuranceController.districtList.any((element) => element.id == personalInsuranceController.selectDistrict.value.id) ? personalInsuranceController.selectDistrict.value.id ?? 0 : null,
                                  dropdownTitle: selectdistricct,
                                ),
                                AppTextfield(
                                  width: 10,
                                  hint: streetname,
                                  lable: streetname,
                                  controller: personalInsuranceController.streetNameController.value,
                                  readOnly: true,
                                ),
                                SizedBox(height: 10),
                                AppTextfield(
                                  controller: personalInsuranceController.buildingNoController.value,
                                  width: 10,
                                  hint: buildingno,
                                  lable: buildingno,
                                  readOnly: true,
                                ),
                                SizedBox(height: 10),
                                AppTextfield(
                                  controller: personalInsuranceController.companyTelephoneNoController.value,
                                  width: 10,
                                  hint: companycontact,
                                  readOnly: true,
                                  lable: companycontact,
                                ),
                              ],
                            ),


                         /* : const SizedBox()*/
                      /*: const SizedBox(),*/
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
              ),
            ),
    );
  }
}
