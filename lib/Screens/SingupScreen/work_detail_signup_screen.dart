import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/SingupScreen/sign_up_controller.dart';
import 'package:soperia_user/Screens/SingupScreen/upload_singup_documents_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class WorkDetailSingupScreen extends StatefulWidget {
  const WorkDetailSingupScreen({super.key});

  @override
  State<WorkDetailSingupScreen> createState() => _WorkDetailSingupScreenState();
}

class _WorkDetailSingupScreenState extends State<WorkDetailSingupScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            height: 40,
                            width: 35,
                            child: Icon(Icons.arrow_back, size: 25),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        AppText(text: personaldetails, size: 25),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(alignment: Alignment.topLeft, child: AppText(text: homeaddress, size: 16)),
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              GetCountryList cdl = signUpController.countryList.firstWhere((element) => element.id == newValue);
                              signUpController.selectCountry.value = cdl;
                              signUpController.getCityMethod(context);
                            });

                          },
                          items: signUpController.countryList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: signUpController.countryList.any((element) => element.id == signUpController.selectCountry.value.id) ? signUpController.selectCountry.value.id ?? 0 : null,
                          dropdownTitle: selectccountry,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: signUpController.check,
                              onChanged: (value) {
                                setState(() {
                                  signUpController.check = value ?? true;
                                  signUpController.getCityMethod(context);
                                });
                              },
                            ),
                            const Expanded(
                              child: Text.rich(maxLines: 3, style: TextStyle(fontSize: 14), TextSpan(children: [TextSpan(text: areYouResidingInTheSameCountry)])),
                            ),
                          ],
                        ),
                        if (!signUpController.check)
                          CustomDropDownBorder1(
                            onchage: (newValue) {
                              setState(() {
                                GetCountryList cdl = signUpController.residencyList.firstWhere((element) => element.id == newValue);
                                signUpController.selectResidency.value = cdl;
                                signUpController.getCityMethod(context);
                              });
                            },
                            items: signUpController.residencyList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                            selectedValue: signUpController.residencyList.any((element) => element.id == signUpController.selectResidency.value.id) ? signUpController.selectResidency.value.id ?? 0 : null,
                            dropdownTitle: selectCountryOfResidence,
                          ),
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              OccuptionList cdl = signUpController.occupationList.firstWhere((element) => element.id == newValue);
                              signUpController.selectOccupation.value = cdl;
                            });
                          },
                          items: signUpController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: signUpController.occupationList.any((element) => element.id == signUpController.selectOccupation.value.id) ? signUpController.selectOccupation.value.id ?? 0 : null,
                          dropdownTitle: occupancy,
                        ),
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              CityListModel cdl = signUpController.cityList.firstWhere((element) => element.id == newValue);
                              signUpController.selectCity.value = cdl;
                              signUpController.getDistrictMethod(context);
                            });
                          },
                          items: signUpController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: signUpController.cityList.any((element) => element.id == signUpController.selectCity.value.id) ? signUpController.selectCity.value.id ?? 0 : null,
                          dropdownTitle: selectccity,
                        ),
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              DistrictList cdl = signUpController.districtList.firstWhere((element) => element.id == newValue);
                              signUpController.selectDistrict.value = cdl;
                            });
                          },
                          items: signUpController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: signUpController.districtList.any((element) => element.id == signUpController.selectDistrict.value.id) ? signUpController.selectDistrict.value.id ?? 0 : null,
                          dropdownTitle: selectdistricct,
                        ),
                        AppTextfield(
                          //
                          width: 10,
                          hint: streetname,
                          lable: streetname,
                          controller: signUpController.streetController.value,
                        ),
                        const SizedBox(height: 10),
                        AppTextfield(
                          width: 10,
                          hint: buildingno,
                          lable: buildingno,
                          controller: signUpController.buildingController.value,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownBorder(
                          onchage: (newValue) {
                            setState(() {
                              signUpController.selectEmp = newValue!;
                            });
                          },
                          items: const [employed, retired, unemployed, selfEmployed],
                          selectedValue: signUpController.selectEmp,
                          dropdownTitle: selectEmploymentType,
                        ),
                        if (signUpController.selectEmp == employed)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextfield(
                                width: 10,
                                hint: companyname,
                                lable: companyname,
                                controller: signUpController.companyController.value,
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownBorder1(
                                onchage: (newValue) {
                                  setState(() {
                                    OccuptionList cdl = signUpController.positionList.firstWhere((element) => element.id == newValue);
                                    signUpController.selectPosition.value = cdl;
                                  });
                                },
                                items: signUpController.positionList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: signUpController.positionList.any((element) => element.id == signUpController.selectPosition.value.id) ? signUpController.selectPosition.value.id ?? 0 : null,
                                dropdownTitle: position,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                hint: worknature,
                                lable: worknature,
                                controller: signUpController.workNatureController.value,
                              ),
                              CustomDropDownBorder1(
                                onchage: (newValue) {
                                  setState(() {
                                    CityListModel cdl = signUpController.cityListCompany.firstWhere((element) => element.id == newValue);
                                    signUpController.selectCityCompany.value = cdl;
                                  });
                                },
                                items: signUpController.cityListCompany.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: signUpController.cityListCompany.any((element) => element.id == signUpController.selectCityCompany.value.id) ? signUpController.selectCityCompany.value.id ?? 0 : null,
                                dropdownTitle: selectccity,
                              ),
                              CustomDropDownBorder1(
                                onchage: (newValue) {
                                  setState(() {
                                    DistrictList cdl = signUpController.districtListCompany.firstWhere((element) => element.id == newValue);
                                    signUpController.selectDistrictCompany.value = cdl;
                                  });
                                },
                                items: signUpController.districtListCompany.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: signUpController.districtListCompany.any((element) => element.id == signUpController.selectDistrictCompany.value.id) ? signUpController.selectDistrictCompany.value.id ?? 0 : null,
                                dropdownTitle: selectdistricct,
                              ),
                              AppTextfield(
                                //
                                width: 10,
                                hint: streetname,
                                lable: streetname,
                                controller: signUpController.companyStreetNameController.value,
                              ),
                              const SizedBox(height: 20),
                              AppTextfield(
                                width: 10,
                                hint: buildingno,
                                lable: buildingno,
                                controller: signUpController.companyBuildingNoController.value,
                              ),
                              const SizedBox(height: 20),
                              AppTextfield(
                                width: 10,
                                hint: companycontact,
                                lable: companycontact,
                                keyboardType: TextInputType.number,
                                controller: signUpController.companyContactNoController.value,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        AppBtnWithColorShades(
                          onTap: () {
                            if (signUpController.selectCountry.value.id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCountry, txtColor: primaryWhite, size: 12)));
                            } else if (signUpController.selectOccupation.value.id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectOccupancyTypeOfWork, txtColor: primaryWhite, size: 12)));
                            } else if (residenceValidation()) {
                              print("object>>>>>>>>>");
                            } else if (signUpController.selectCity.value.id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCity, txtColor: primaryWhite, size: 12)));
                            } else if (signUpController.selectDistrict.value.id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDistrict, txtColor: primaryWhite, size: 12)));
                            } else if (signUpController.streetController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterStreetName, txtColor: primaryWhite, size: 12)));
                            } else if (signUpController.buildingController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBuildingNo, txtColor: primaryWhite, size: 12)));
                            } else if (signUpController.selectEmp == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEmployeeType, txtColor: primaryWhite, size: 12)));
                            } else if (employeeValidation()) {
                              print("<<<<<<<<<<<object");
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadSingUpDocumentsScreen()));
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
                  )
                ],
              ),
            ),
          ),
        ));
  }

  bool residenceValidation() {
    if (signUpController.check == false) {
      if (signUpController.selectResidency.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCountryOfResidence, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }

  bool employeeValidation() {
    if (signUpController.selectEmp == employed) {
      if (signUpController.companyController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (signUpController.selectPosition.value.name == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterYourPosition, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (signUpController.workNatureController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterWorkNature, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (signUpController.selectCityCompany.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCity, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (signUpController.selectDistrictCompany.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDistrict, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (signUpController.companyStreetNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterStreetName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (signUpController.companyBuildingNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBuildingNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (signUpController.companyContactNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyContactNo, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }
}
