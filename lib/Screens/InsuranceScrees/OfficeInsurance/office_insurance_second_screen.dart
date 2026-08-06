import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

class OfficeInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  OfficeInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<OfficeInsuranceSecondScreen> createState() => _OfficeInsuranceSecondScreenState();
}

class _OfficeInsuranceSecondScreenState extends State<OfficeInsuranceSecondScreen> {
  OfficeInsuranceController officeInsuranceController = Get.put(OfficeInsuranceController());


  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topLeft, child: AppText(text: companyAddress, size: 16,fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),

              AppTextfield(
                width: 10,
                hint: companyNameAsPerRegi,
                lable: companyNameAsPerRegi,
                controller: officeInsuranceController.companyNameController.value,
              ),
              SizedBox(height: 10),
              AppTextfield(
                keyboardType: TextInputType.number,
                width: 10,
                hint: companyregister,
                lable: companyregister,
                controller: officeInsuranceController.companyRegisterNationalIdNoController.value,
              ),
              SizedBox(height: 10),
              AppTextfield(
                keyboardType: TextInputType.number,
                width: 10,
                hint: companyregistorno,
                lable: companyregistorno,
                controller: officeInsuranceController.companyRegisterNoController.value,
              ),
              const SizedBox(height: 10),
              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    officeInsuranceController.selectofficetype = newValue!;
                  });
                },
                items: const [officeSpace, villa],
                selectedValue: officeInsuranceController.selectofficetype,
                dropdownTitle: "$selectYour $officetype",
              ),
              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    officeInsuranceController.selectNoOfFloor = newValue!;
                  });
                },
                items: const [' 1 ', ' 2', ' 3', ' 4 ', ' 5', ' 6'],
                selectedValue: officeInsuranceController.selectNoOfFloor,
                dropdownTitle: select + nooffloors,
              ),
              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    officeInsuranceController.selectedroomsItem = newValue!;
                  });
                },
                items: const [' 1 ', ' 2', ' 3', ' 4 ', ' 5', ' 6', ' 7 ', ' 8', ' 9'],
                selectedValue: officeInsuranceController.selectedroomsItem,
                dropdownTitle: selectNoOfRoomsForOfficeVilla,
              ),
              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    officeInsuranceController.selectAgeOfBuilding = newValue!;
                  });
                },
                items: const [' 1 ', ' 2', ' 3', ' 4 ', ' 5', ' 6', ' 7 ', ' 8', ' 9', "10", ' 11 ', ' 12', ' 13', ' 14 ', ' 15', ' 16', ' 17 ', ' 18', ' 19', "20", ' 21 ', ' 22', ' 23', ' 24 ', ' 25', '26', ' 27 ', ' 28', ' 29', "30"],
                selectedValue: officeInsuranceController.selectAgeOfBuilding,
                dropdownTitle: selectAgeOfBuildingVilla,
              ),
              AppTextfield(
                keyboardType: TextInputType.number,
                hint: sizeOfOfficeVillaInSqm,
                lable: sizeOfOfficeVillaInSqm,
                controller: officeInsuranceController.officeSizeController.value,
              ),
              const SizedBox(height: 20),
              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    officeInsuranceController.selectedOfficeCategory = newValue!;
                  });
                },
                items: const [owned, rented],
                selectedValue: officeInsuranceController.selectedOfficeCategory,
                dropdownTitle: selectOfficeCategory,
              ),
              if (officeInsuranceController.selectedOfficeCategory == owned)
                Column(
                  children: [
                    AppTextfield(
                      keyboardType: TextInputType.number,
                      controller: officeInsuranceController.blockNoController.value,
                      width: 10,
                      hint: blockNo,
                      lable: blockNo,
                    ),
                    const SizedBox(height: 10),
                    AppTextfield(
                      keyboardType: TextInputType.number,
                      width: 10,
                      hint: plateNo,
                      lable: plateNo,
                      controller: officeInsuranceController.plateNoController.value,
                    ),
                    SizedBox(height: 8),
                    AppTextfield(
                      keyboardType: TextInputType.number,
                      width: 10,
                      hint: plotNo,
                      lable: plotNo,
                      controller: officeInsuranceController.plotNoController.value,
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              AppTextfield(
                  readOnly: true,
                  hint: effectivedaate,
                  lable: effectivedaate,
                  controller: officeInsuranceController.effectiveDateController.value,
                  ontap: () {
                    effectiveDateDialog();
                  }),
              const SizedBox(height: 10),
              AppTextfield(
                  readOnly: true,
                  hint: expiredaate,
                  lable: expiredaate,
                  controller: officeInsuranceController.effectiveExpiryDateController.value,
                ),
              const SizedBox(height: 10),
              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    officeInsuranceController.selectNoOfEmployee = newValue!;
                  });
                },
                items: officeInsuranceController.employeeNumber,
                selectedValue: officeInsuranceController.selectNoOfEmployee,
                dropdownTitle: selectNumberOfEmployees,
              ),
              const SizedBox(height: 10),
              AppText(
                text: companyaddress,
                size: 16,
                fontWeight: FontWeight.bold,
                txtAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() async {
                    GetCountryList cdl = officeInsuranceController.countryList.firstWhere((element) => element.id == newValue);
                    officeInsuranceController.selectCountry.value = cdl;
                    await officeInsuranceController.getCityMethod(context,officeInsuranceController.selectCountry.value.id.toString()??'');
                  });
                },
                items: officeInsuranceController.countryList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: officeInsuranceController.countryList.any((element) => element.id == officeInsuranceController.selectCountry.value.id) ? officeInsuranceController.selectCountry.value.id ?? 0 : null,
                dropdownTitle: selectccountry,
              ),
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() async {
                    CityListModel cdl = officeInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                    officeInsuranceController.selectCity.value = cdl;
                    await officeInsuranceController.getDistrictMethod(context,officeInsuranceController.selectCity.value.id.toString());
                  });
                },
                items: officeInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: officeInsuranceController.cityList.any((element) => element.id == officeInsuranceController.selectCity.value.id) ? officeInsuranceController.selectCity.value.id ?? 0 : null,
                dropdownTitle: selectccity,
              ),
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() {
                    DistrictList cdl = officeInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                    officeInsuranceController.selectDistrict.value = cdl;
                  });
                },
                items: officeInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: officeInsuranceController.districtList.any((element) => element.id == officeInsuranceController.selectDistrict.value.id) ? officeInsuranceController.selectDistrict.value.id ?? 0 : null,
                dropdownTitle: selectdistricct,
              ),
              AppTextfield(
                width: 10,
                hint: streetname,
                lable: streetname,
                controller: officeInsuranceController.streetNameController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                keyboardType: TextInputType.number,
                width: 10,
                hint: buildingno,
                lable: buildingno,
                controller: officeInsuranceController.buildingNoController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                keyboardType: TextInputType.number,
                width: 10,
                hint: officeno,
                lable: officeno,
                controller: officeInsuranceController.officeNoController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                width: 10,
                keyboardType: TextInputType.number,
                maxLength: 10,
                hint: companytele,
                lable: companytele,
                controller: officeInsuranceController.companyTelephoneNoController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                width: 10,
                hint: companyOwnerFirstName,
                lable: companyOwnerFirstName,
                controller: officeInsuranceController.companyOwnerFirstNameController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                width: 10,
                hint: companyOwnerSecondName,
                lable: companyOwnerSecondName,
                controller: officeInsuranceController.companyOwnerSecondNameController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                width: 10,
                hint: companyOwnerThirdName,
                lable: companyOwnerThirdName,
                controller: officeInsuranceController.companyOwnerThirdNameController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                width: 10,
                hint: companyOwnerFamilyName,
                lable: companyOwnerFamilyName,
                controller: officeInsuranceController.companyOwnerFamilyNameController.value,
              ),
              SizedBox(height: 20),
              AppTextfield(
                width: 10,
                keyboardType: TextInputType.number,
                maxLength: 10,
                hint: companyownertele,
                lable: companyownertele,
                controller: officeInsuranceController.companyOwnerTelephoneNoController.value,
              ),
              SizedBox(height: 20),
              AppBtnWithColorShades(
                onTap: () {
                  if (officeInsuranceController.companyNameController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyName, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyRegisterNationalIdNoController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyRegisteredNationalIdNo, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyRegisterNoController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyRegistrationNo, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectofficetype == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectTypeOfOffice, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectNoOfFloor == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectNoOfFloorsForBuildingVilla, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectedroomsItem == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectNoOfRoomsForOfficeVilla, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectAgeOfBuilding == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAgeOfBuildingVilla, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.officeSizeController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterSizeOfOfficeSpaceVillaInSqm, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectedOfficeCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectOfficeCategory, txtColor: primaryWhite, size: 12)));
                  } else if (officeCategoryValidation()) {
                    print("object?????????");
                  } else if (officeInsuranceController.effectiveDateController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEffectiveDate, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectNoOfEmployee == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectNoOfEmployees, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectCountry.value.name == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCountry, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectCity.value.name == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCity, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.selectDistrict.value.name == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDistrict, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.streetNameController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterStreetName, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.buildingNoController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBuildingNo, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.officeNoController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterOfficeNo, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyTelephoneNoController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyTelephoneNo, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyOwnerFirstNameController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersFirstName, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyOwnerSecondNameController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersSecondName, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyOwnerThirdNameController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersThirdName, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyOwnerFamilyNameController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersFamilyName, txtColor: primaryWhite, size: 12)));
                  } else if (officeInsuranceController.companyOwnerTelephoneNoController.value.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersTelephoneNo, txtColor: primaryWhite, size: 12)));
                  } else {
                    widget.onNext();
                  }
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
        );
      },
    );
  }

  bool officeCategoryValidation() {
    if (officeInsuranceController.selectedOfficeCategory == owned) {
      if (officeInsuranceController.blockNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBlockNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (officeInsuranceController.plateNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPlateNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (officeInsuranceController.plotNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPlotNo, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }

  effectiveDateDialog() async {
   /* if (officeInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (officeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        officeInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(officeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        officeInsuranceController.initialDate.value = officeInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        officeInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      officeInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: officeInsuranceController.initialDate.value , //get today's date
      firstDate: officeInsuranceController.initialDate.value , //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      //formatted date output using intl package =>  2022-07-04
      officeInsuranceController.initialDate.value=pickedDate;
      setState(() {
        officeInsuranceController.effectiveDateController.value.text = commonDateFormat(formattedDate);
        officeInsuranceController.effectiveExpiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(pickedDate)).add(const Duration(days: 364)).toString())));
      });
    } else {
      print("Date is not selected");
    }
  }

}
