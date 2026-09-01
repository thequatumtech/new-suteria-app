import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/file_upload_gallary.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

import 'profile_controller/profile_controller.dart';

class WorkDetailProfileScreen extends StatefulWidget {
  const WorkDetailProfileScreen({super.key});

  @override
  State<WorkDetailProfileScreen> createState() => _WorkDetailSingupScreenState();
}

class _WorkDetailSingupScreenState extends State<WorkDetailProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
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
                            GetCountryList cdl = profileController.countryList.firstWhere((element) => element.id == newValue);
                            profileController.selectCountry.value = cdl;
                            profileController.getCityMethod(context);
                          });
                        },
                        items: profileController.countryList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: profileController.countryList.any((element) => element.id == profileController.selectCountry.value.id) ? profileController.selectCountry.value.id ?? 0 : null,
                        dropdownTitle: selectccountry,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: profileController.check,
                            onChanged: (value) {
                              setState(() {
                                profileController.check = value ?? true;
                                print(profileController.check);
                                profileController.getCityMethod(context);
                              });
                            },
                          ),
                          Expanded(
                            child: AppText(
                              text: areYouResidingInTheSameCountry,
                              size: 14,
                              maxLine: 3,
                            ),
                          ),
                        ],
                      ),
                      if (!profileController.check)
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              GetCountryList cdl = profileController.residencyList.firstWhere((element) => element.id == newValue);
                              profileController.selectResidency.value = cdl;
                              profileController.getCityMethod(context);
                            });
                          },
                          items: profileController.residencyList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: profileController.residencyList.any((element) => element.id == profileController.selectResidency.value.id) ? profileController.selectResidency.value.id ?? 0 : null,
                          dropdownTitle: selectCountryOfResidence,
                        ),
                      CustomDropDownBorder1(
                        onchage: (newValue) {
                          setState(() {
                            CityListModel cdl = profileController.cityList.firstWhere((element) => element.id == newValue);
                            profileController.selectCity.value = cdl;
                            profileController.getDistrictMethod(context);
                          });
                        },
                        items: profileController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: profileController.cityList.any((element) => element.id == profileController.selectCity.value.id) ? profileController.selectCity.value.id ?? 0 : null,
                        dropdownTitle: selectccity,
                      ),
                      CustomDropDownBorder1(
                        onchage: (newValue) {
                          setState(() {
                            DistrictList cdl = profileController.districtList.firstWhere((element) => element.id == newValue);
                            profileController.selectDistrict.value = cdl;
                          });
                        },
                        items: profileController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: profileController.districtList.any((element) => element.id == profileController.selectDistrict.value.id) ? profileController.selectDistrict.value.id ?? 0 : null,
                        dropdownTitle: selectdistricct,
                      ),
                      AppTextfield(
                        //
                        width: 10,
                        hint: streetname,
                        lable: streetname,
                        controller: profileController.streetController.value,
                      ),
                      SizedBox(height: 10),
                      AppTextfield(
                        width: 10,
                        hint: buildingno,
                        lable: buildingno,
                        controller: profileController.buildingController.value,
                      ),
                      SizedBox(height: 10),
                      CustomDropDownBorder(
                        onchage: (newValue) {
                          setState(() {
                            profileController.selectEmp = newValue!;
                          });
                        },
                        items: const [employed, retired, unemployed, selfEmployed],
                        selectedValue: profileController.selectEmp,
                        dropdownTitle: selectEmploymentType,
                      ),
                      if (profileController.selectEmp == employed)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextfield(
                              width: 10,
                              hint: companyname,
                              lable: companyname,
                              controller: profileController.companyController.value,
                            ),
                            const SizedBox(height: 10),
                            CustomDropDownBorder1(
                              onchage: (newValue) {
                                setState(() {
                                  OccuptionList cdl = profileController.positionList.firstWhere((element) => element.id == newValue);
                                  profileController.selectPosition.value = cdl;
                                });
                              },
                              items: profileController.positionList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                              selectedValue: profileController.positionList.any((element) => element.id == profileController.selectPosition.value.id) ? profileController.selectPosition.value.id ?? 0 : null,
                              dropdownTitle: position,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 10,
                              hint: worknature,
                              lable: worknature,
                              controller: profileController.workNatureController.value,
                            ),
                            CustomDropDownBorder1(
                              onchage: (newValue) {
                                setState(() {
                                  CityListModel cdl = profileController.cityListCompany.firstWhere((element) => element.id == newValue);
                                  profileController.selectCityCompany.value = cdl;
                                });
                              },
                              items: profileController.cityListCompany.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                              selectedValue: profileController.cityListCompany.any((element) => element.id == profileController.selectCityCompany.value.id) ? profileController.selectCityCompany.value.id ?? 0 : null,
                              dropdownTitle: selectccity,
                            ),
                            CustomDropDownBorder1(
                              onchage: (newValue) {
                                setState(() {
                                  DistrictList cdl = profileController.districtListCompany.firstWhere((element) => element.id == newValue);
                                  profileController.selectDistrictCompany.value = cdl;
                                });
                              },
                              items: profileController.districtListCompany.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                              selectedValue: profileController.districtListCompany.any((element) => element.id == profileController.selectDistrictCompany.value.id) ? profileController.selectDistrictCompany.value.id ?? 0 : null,
                              dropdownTitle: selectdistricct,
                            ),
                            AppTextfield(
                              //
                              width: 10,
                              hint: streetname,
                              lable: streetname,
                              controller: profileController.companyStreetNameController.value,
                            ),
                            const SizedBox(height: 20),
                            AppTextfield(
                              width: 10,
                              hint: buildingno,
                              lable: buildingno,
                              controller: profileController.companyBuildingNoController.value,
                            ),
                            const SizedBox(height: 20),
                            AppTextfield(
                              width: 10,
                              hint: companycontact,
                              lable: companycontact,
                              keyboardType: TextInputType.number,
                              controller: profileController.companyContactNoController.value,
                            ),
                          ],
                        ),
                      InkWell(
                          onTap: () async {
                            profileController.residenceCardFont = (await selectImageFromGallery(context)) ?? profileController.residenceCardFont;
                            setState(() {});
                          },
                          child: profileController.residenceCardFont.path.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: 120,
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(border: Border.all(color: skyBlueShade2), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: CachedNetworkImage(imageUrl: "$imgBaseUrl/${profileController.getProfileModel.value.data?.idFront ?? ''}", placeholder: (context, url) => const CircularProgressIndicator(), errorWidget: (context, url, error) => const Icon(Icons.error), fit: BoxFit.contain),
                                )
                              : ImageUploadWidget(image: profileController.residenceCardFont, txt: addIdResidenceCardFrontSide, borderColor: skyBlueShade2)),
                      InkWell(
                          onTap: () async {
                            profileController.residenceCardBack = (await selectImageFromGallery(context)) ?? profileController.residenceCardBack;
                            setState(() {});
                          },
                          child: profileController.residenceCardBack.path.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: 120,
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(border: Border.all(color: skyBlueShade2), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: CachedNetworkImage(imageUrl: "$imgBaseUrl/${profileController.getProfileModel.value.data?.idBack ?? ''}", placeholder: (context, url) => const CircularProgressIndicator(), errorWidget: (context, url, error) => const Icon(Icons.error), fit: BoxFit.contain),
                                )
                              : ImageUploadWidget(image: profileController.residenceCardBack, txt: addIdResidenceCardBackSide, borderColor: skyBlueShade2)),
                      InkWell(
                          onTap: () async {
                            profileController.personalPicDoc = (await selectImageFromGallery(context)) ?? profileController.personalPicDoc;
                            setState(() {});
                          },
                          child: profileController.personalPicDoc.path.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: 120,
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(border: Border.all(color: skyBlueShade2), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child:
                                      CachedNetworkImage(imageUrl: "$imgBaseUrl/${profileController.getProfileModel.value.data?.profilePic ?? ''}", placeholder: (context, url) => const CircularProgressIndicator(), errorWidget: (context, url, error) => const Icon(Icons.error), fit: BoxFit.contain),
                                )
                              : ImageUploadWidget(image: profileController.personalPicDoc, txt: addPersonalPicture, borderColor: skyBlueShade2)),
                      AppTextfield(hint: pleaseFillInNumber, lable: pleaseFillIn, keyboardType: TextInputType.number, controller: profileController.agentNoController.value),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Column(
                    children: [
                      AppBtnWithColorShades(
                        onTap: () {
                          if (profileController.selectCountry.value.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCountry, txtColor: primaryWhite, size: 12)));
                          } else if (residenceValidation()) {
                            print("object>>>>>>>>>");
                          } else if (profileController.selectCity.value.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCity, txtColor: primaryWhite, size: 12)));
                          } else if (profileController.selectDistrict.value.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDistrict, txtColor: primaryWhite, size: 12)));
                          } else if (profileController.streetController.value.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterStreetName, txtColor: primaryWhite, size: 12)));
                          } else if (profileController.buildingController.value.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBuildingNo, txtColor: primaryWhite, size: 12)));
                          } else if (profileController.selectEmp == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEmployeeType, txtColor: primaryWhite, size: 12)));
                          } else if (employeeValidation()) {
                            print("<<<<<<<<<<<object");
                          }
                          /*else if (profileController.agentNoController.value.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: AppText(
                              text: "Please enter agent No.",
                              txtColor: primaryWhite,
                              size: 12,
                            )));
                          } */
                          else {
                            profileController.updateProfileApi(context);
                          }
                        },
                        btnTxt: submit,
                        color1: darkBlue2,
                        color2: darkBlue1,
                        isLoad: profileController.isLoadingPost.value,
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
      ),
    );
  }

  bool residenceValidation() {
    if (profileController.check == false) {
      if (profileController.selectResidency.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCountryOfResidence, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }

  bool employeeValidation() {
    if (profileController.selectEmp == employed) {
      if (profileController.companyController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (profileController.selectPosition.value.name == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterYourPosition, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (profileController.workNatureController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterWorkNature, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (profileController.selectCityCompany.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCity, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (profileController.selectDistrict.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDistrict, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (profileController.companyStreetNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterStreetName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (profileController.companyBuildingNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBuildingNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (profileController.companyContactNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyContactNo, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }
}
