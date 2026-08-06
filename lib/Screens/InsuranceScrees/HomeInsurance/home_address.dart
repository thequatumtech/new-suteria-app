import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_controller.dart';
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

class HomeAddress extends StatefulWidget {
  Function onNext;

  HomeAddress({super.key, required this.onNext});

  @override
  State<HomeAddress> createState() => _HomeAddressState();
}

class _HomeAddressState extends State<HomeAddress> {
  HomeInsuranceController homeInsuranceController = Get.put(HomeInsuranceController());

  @override
  void initState() {
/*  homeInsuranceController.init(context);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: homeaddress,
              size: 16,
              fontWeight: FontWeight.bold,
              txtAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomDropDownBorderDisable(
              onchage: (newValue) {
                setState(() {
                  GetCountryList cdl = homeInsuranceController.countryList.firstWhere((element) => element.id == newValue);
                  homeInsuranceController.selectCountry.value = cdl;
                });
              },
              items: homeInsuranceController.countryList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: homeInsuranceController.countryList.any((element) => element.id == homeInsuranceController.selectCountry.value.id) ? homeInsuranceController.selectCountry.value.id ?? 0 : null,
              dropdownTitle: selectccountry,
            ),
            CustomDropDownBorderDisable(
              onchage: (newValue) {
                setState(() {
                  CityListModel cdl = homeInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                  homeInsuranceController.selectCity.value = cdl;
                });
              },
              items: homeInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: homeInsuranceController.cityList.any((element) => element.id == homeInsuranceController.selectCity.value.id) ? homeInsuranceController.selectCity.value.id ?? 0 : null,
              dropdownTitle: selectccity,
            ),
            CustomDropDownBorderDisable(
              onchage: (newValue) {
                setState(() {
                  DistrictList cdl = homeInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                  homeInsuranceController.selectDistrict.value = cdl;
                });
              },
              items: homeInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: homeInsuranceController.districtList.any((element) => element.id == homeInsuranceController.selectDistrict.value.id) ? homeInsuranceController.selectDistrict.value.id ?? 0 : null,
              dropdownTitle: selectdistricct,
            ),
            const SizedBox(
              height: 20,
            ),
            AppTextfield(
              controller: homeInsuranceController.streetNameController.value,
              width: 10,
              readOnly: true,
              hint: streetname,
              lable: streetname,
            ),
            const SizedBox(height: 10),
            AppTextfield(
              controller: homeInsuranceController.buildingNoController.value,
              width: 10,
              readOnly: true,
              hint: buildingno,
              lable: buildingno,
            ),
            const SizedBox(height: 10),
            getProfileModelGlobal.data?.employmentType != null
                ? getProfileModelGlobal.data?.employmentType == employed
                    ? Column(
                        children: [
                          AppTextfield(
                            controller: homeInsuranceController.companyNameController.value,
                            width: 10,
                            readOnly: true,
                            hint: companyname,
                            lable: companyname,
                          ),
                          const SizedBox(height: 10),
                          AppTextfield(
                            controller: homeInsuranceController.positionController.value,
                            width: 10,
                            readOnly: true,
                            hint: position,
                            lable: position,
                          ),
                          const SizedBox(height: 10),
                          AppTextfield(
                            controller: homeInsuranceController.workNatureController.value,
                            width: 10,
                            readOnly: true,
                            hint: worknature,
                            lable: worknature,
                          ),
                          CustomDropDownBorderDisable(
                            onchage: (newValue) {
                              setState(() {
                                CityListModel cdl = homeInsuranceController.companyCityList.firstWhere((element) => element.id == newValue);
                                homeInsuranceController.selectCompanyCity.value = cdl;
                              });
                            },
                            items: homeInsuranceController.companyCityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: homeInsuranceController.companyCityList.any((element) => element.id == homeInsuranceController.selectCompanyCity.value.id) ? homeInsuranceController.selectCompanyCity.value.id ?? 0 : null,
                            dropdownTitle: selectccity,
                          ),
                        ],
                      )
                    : const SizedBox()
                : const SizedBox(),
            const SizedBox(height: 20),
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
