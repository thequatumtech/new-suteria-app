import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Life%20Insurance/life_insurance_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

class LifeInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  LifeInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<LifeInsuranceSecondScreen> createState() => _LifeInsuranceSecondScreenState();
}

class _LifeInsuranceSecondScreenState extends State<LifeInsuranceSecondScreen> {
  LifeInsuranceController lifeInsuranceController = Get.put(LifeInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(
        () => getProfileModelGlobal.data == null
            ? AppText(
                text: noDataFound,
                txtAlign: TextAlign.center,
                size: 20,
              )
            : lifeInsuranceController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: homeaddress,
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomDropDownBorderDisable(
                        onchage: (newValue) {
                          setState(() {
                            GetCountryList cdl = lifeInsuranceController.countryList.firstWhere((element) => element.id == newValue);
                            lifeInsuranceController.selectCountry.value = cdl;
                          });
                        },
                        items: lifeInsuranceController.countryList
                            .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack))))
                            .toList(),
                        selectedValue: lifeInsuranceController.countryList.any((element) => element.id == lifeInsuranceController.selectCountry.value.id)
                            ? lifeInsuranceController.selectCountry.value.id ?? 0
                            : null,
                        dropdownTitle: selectccountry,
                      ),
                      CustomDropDownBorderDisable(
                        onchage: (newValue) {
                          setState(() {
                            CityListModel cdl = lifeInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                            lifeInsuranceController.selectCity.value = cdl;
                          });
                        },
                        items: lifeInsuranceController.cityList
                            .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack))))
                            .toList(),
                        selectedValue:
                            lifeInsuranceController.cityList.any((element) => element.id == lifeInsuranceController.selectCity.value.id) ? lifeInsuranceController.selectCity.value.id ?? 0 : null,
                        dropdownTitle: selectccity,
                      ),
                      CustomDropDownBorderDisable(
                        onchage: (newValue) {
                          setState(() {
                            DistrictList cdl = lifeInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                            lifeInsuranceController.selectDistrict.value = cdl;
                          });
                        },
                        items: lifeInsuranceController.districtList
                            .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack))))
                            .toList(),
                        selectedValue: lifeInsuranceController.districtList.any((element) => element.id == lifeInsuranceController.selectDistrict.value.id)
                            ? lifeInsuranceController.selectDistrict.value.id ?? 0
                            : null,
                        dropdownTitle: selectdistricct,
                      ),
                      SizedBox(height: 10),
                      AppTextfield(
                        controller: lifeInsuranceController.streetNameController.value,
                        width: 10,
                        hint: streetname,
                        lable: streetname,
                        readOnly: true,
                      ),
                      SizedBox(height: 20),
                      AppTextfield(
                        controller: lifeInsuranceController.buildingNoController.value,
                        width: 10,
                        hint: buildingno,
                        lable: buildingno,
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: AppText(text: lifeq2, size: 15, txtAlign: TextAlign.start),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: yesTxt,
                            groupValue: lifeInsuranceController.selectedOption1,
                            onChanged: (value) {
                              setState(() {
                                lifeInsuranceController.selectedOption1 = value!;
                              });
                            },
                          ),
                          AppText(text: yesTxt),
                          Radio(
                            value: noTxt,
                            groupValue: lifeInsuranceController.selectedOption1,
                            onChanged: (value) {
                              setState(() {
                                lifeInsuranceController.selectedOption1 = value!;
                              });
                            },
                          ),
                          AppText(text: noTxt),
                        ],
                      ),
                      if (lifeInsuranceController.selectedOption1 == yesTxt)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextfield(
                              hint: companyname,
                              lable: companyname,
                              controller: lifeInsuranceController.companyNameController.value,
                              readOnly: true,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              controller: lifeInsuranceController.positionController.value,
                              width: 10,
                              hint: position,
                              lable: position,
                              readOnly: true,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              controller: lifeInsuranceController.workNatureController.value,
                              width: 10,
                              hint: worknature,
                              lable: worknature,
                            ),
                            CustomDropDownBorderDisable(
                              onchage: (newValue) {
                                setState(() {
                                  CityListModel cdl = lifeInsuranceController.companyCityList.firstWhere((element) => element.id == newValue);
                                  lifeInsuranceController.selectCompanyCity.value = cdl;
                                });
                              },
                              items: lifeInsuranceController.companyCityList
                                  .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack))))
                                  .toList(),
                              selectedValue: lifeInsuranceController.companyCityList.any((element) => element.id == lifeInsuranceController.selectCompanyCity.value.id)
                                  ? lifeInsuranceController.selectCompanyCity.value.id ?? 0
                                  : null,
                              dropdownTitle: selectccity,
                            ),
                            CustomDropDownBorderDisable(
                              onchage: (newValue) {
                                setState(() {
                                  DistrictList cdl = lifeInsuranceController.companyDistrictList.firstWhere((element) => element.id == newValue);
                                  lifeInsuranceController.selectCompanyDistrict.value = cdl;
                                });
                              },
                              items: lifeInsuranceController.companyDistrictList
                                  .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack))))
                                  .toList(),
                              selectedValue: lifeInsuranceController.companyDistrictList.any((element) => element.id == lifeInsuranceController.selectCompanyDistrict.value.id)
                                  ? lifeInsuranceController.selectCompanyDistrict.value.id ?? 0
                                  : null,
                              dropdownTitle: selectdistricct,
                            ),
                            AppTextfield(
                              //controller: _plotNoController,
                              width: 10,
                              hint: streetname,
                              lable: streetname,
                              controller: lifeInsuranceController.companyStreetNameController.value,
                              readOnly: true,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              controller: lifeInsuranceController.companyBuildingNoController.value,
                              width: 10,
                              hint: buildingno,
                              lable: buildingno,
                              readOnly: true,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              readOnly: true,
                              controller: lifeInsuranceController.companyContactNoController.value,
                              width: 10,
                              hint: companycontact,
                              lable: companycontact,
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      AppBtnWithColorShades(
                        onTap: () {
                          if (lifeInsuranceController.selectedOption1 == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEmployedOption, txtColor: primaryWhite, size: 12)));
                          } else {
                            widget.onNext();
                          }
                        },
                        btnTxt: next,
                        color1: darkBlue2,
                        color2: darkBlue1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
      ),
    );
  }
}
