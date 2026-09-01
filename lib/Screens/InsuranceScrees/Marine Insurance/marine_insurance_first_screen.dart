import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/new_upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';
import 'package:soperia_user/model_class/get_city_model.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_district_model.dart';

class MarineInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  MarineInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<MarineInsuranceFirstScreen> createState() => _MarineInsuranceFirstScreenState();
}

class _MarineInsuranceFirstScreenState extends State<MarineInsuranceFirstScreen> {
  MarineInsuranceController marineInsuranceController = Get.put(MarineInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return marineInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Column(
              children: [
                marineInsuranceController.individual.value
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextfield(
                              width: 10,
                              hint: policyIssuersFirstName,
                              lable: policyIssuersFirstName,
                              readOnly: true,
                              controller: marineInsuranceController.policyHolderFirstNameController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 10,
                              hint: policyIssuersSecondName,
                              lable: policyIssuersSecondName,
                              readOnly: true,
                              controller: marineInsuranceController.policyHolderSecondNameController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 10,
                              hint: policyIssuersThirdName,
                              lable: policyIssuersThirdName,
                              readOnly: true,
                              controller: marineInsuranceController.policyHolderThirdNameController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 10,
                              hint: policyIssuersFamilyName,
                              lable: policyIssuersFamilyName,
                              readOnly: true,
                              controller: marineInsuranceController.policyHolderFamilyNameController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 10,
                              hint: nationalnopassport,
                              lable: nationalnopassport,
                              readOnly: true,
                              controller: marineInsuranceController.nationPassportNoController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 10,
                              hint: residenceno,
                              lable: residenceno,
                              readOnly: true,
                              controller: marineInsuranceController.idOrResidenceNoController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              readOnly: true,
                              width: 10,
                              hint: birthdate,
                              lable: birthdate,
                              controller: marineInsuranceController.birthDateController.value,
                            ),
                            /*   Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: selectgender,
                        size: 16,
                        fontWeight: FontWeight.bold,
                        txtAlign: TextAlign.start,
                      ),
                      DropdownButtonFormField(
                        value: selectedGender,decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        hint: Text('Select Gender'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: ['Male', 'Female']
                            .map((gender) => DropdownMenuItem(
                          child: Text(gender,style: TextStyle(
                              color: primaryGrey
                          )),
                          value: gender,
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),*/
                            CustomDropDownBorderStringDisable(
                              onchage: (newValue) {
                                setState(() {
                                  marineInsuranceController.selectedGender = newValue!;
                                });
                              },
                              items: const [male, female, other],
                              selectedValue: marineInsuranceController.selectedGender,
                              dropdownTitle: selectgender,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextfield(
                                width: 10,
                                hint: companyNameAsPerRegi,
                                lable: companyNameAsPerRegi,
                                controller: marineInsuranceController.companyNameController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                keyboardType: TextInputType.number,
                                width: 10,
                                hint: companyregister,
                                lable: companyregister,
                                controller: marineInsuranceController.companyRegisterNationalIdNoController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                keyboardType: TextInputType.number,
                                width: 10,
                                hint: companyregistorno,
                                lable: companyregistorno,
                                controller: marineInsuranceController.companyRegisterNoController.value,
                              ),
                              const SizedBox(height: 10),
                              AppText(
                                text: companyaddress,
                                size: 16,
                                fontWeight: FontWeight.bold,
                                txtAlign: TextAlign.start,
                              ),
                              CustomDropDownBorder1(
                                onchage: (newValue) {
                                  setState(() {
                                    GetCountryList cdl = marineInsuranceController.countryList.firstWhere((element) => element.id == newValue);
                                    marineInsuranceController.selectCompanyCountry.value = cdl;
                                    marineInsuranceController.getCityMethod(context,marineInsuranceController.selectCompanyCountry.value.id.toString());

                                  });
                                },
                                items: marineInsuranceController.countryList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: marineInsuranceController.countryList.any((element) => element.id == marineInsuranceController.selectCompanyCountry.value.id) ? marineInsuranceController.selectCompanyCountry.value.id ?? 0 : null,
                                dropdownTitle: selectccountry,
                              ),
                              CustomDropDownBorder1(
                                onchage: (newValue) {
                                  setState(() {
                                    CityListModel cdl = marineInsuranceController.cityList.firstWhere((element) => element.id == newValue);
                                    marineInsuranceController.selectCompanyCity.value = cdl;
                                    marineInsuranceController.getDistrictMethod(context,marineInsuranceController.selectCompanyCity.value.id.toString());
                                  });
                                },
                                items: marineInsuranceController.cityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: marineInsuranceController.cityList.any((element) => element.id == marineInsuranceController.selectCompanyCity.value.id) ? marineInsuranceController.selectCompanyCity.value.id ?? 0 : null,
                                dropdownTitle: selectccity,
                              ),
                              CustomDropDownBorder1(
                                onchage: (newValue) {
                                  setState(() {
                                    DistrictList cdl = marineInsuranceController.districtList.firstWhere((element) => element.id == newValue);
                                    marineInsuranceController.selectCompanyDistrict.value = cdl;
                                  });
                                },
                                items: marineInsuranceController.districtList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: marineInsuranceController.districtList.any((element) => element.id == marineInsuranceController.selectCompanyDistrict.value.id) ? marineInsuranceController.selectCompanyDistrict.value.id ?? 0 : null,
                                dropdownTitle: selectdistricct,
                              ),
                              AppTextfield(
                                width: 10,
                                hint: streetname,
                                lable: streetname,
                                controller: marineInsuranceController.streetNameController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                hint: buildingno,
                                lable: buildingno,
                                controller: marineInsuranceController.buildingNoController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                hint: officeno,
                                lable: officeno,
                                controller: marineInsuranceController.officeNoController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                keyboardType: TextInputType.number,
                                hint: companytele,
                                lable: companytele,
                                controller: marineInsuranceController.companyTelephoneNoController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                hint: companyOwnerFirstName,
                                lable: companyOwnerFirstName,
                                controller: marineInsuranceController.companyOwnerFirstNameController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                hint: companyOwnerSecondName,
                                lable: companyOwnerSecondName,
                                controller: marineInsuranceController.companyOwnerSecondNameController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                hint: companyOwnerThirdName,
                                lable: companyOwnerThirdName,
                                controller: marineInsuranceController.companyOwnerThirdNameController.value,
                              ),
                              SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                hint: companyOwnerFamilyName,
                                lable: companyOwnerFamilyName,
                                controller: marineInsuranceController.companyOwnerFamilyNameController.value,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(
                                width: 10,
                                keyboardType: TextInputType.number,
                                hint: companyownertele,
                                lable: companyownertele,
                                controller: marineInsuranceController.companyOwnerTelephoneNoController.value,
                              ),
                              AppText(text: mariq1, size: 15, txtAlign: TextAlign.start),
                              const SizedBox(height: 4),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        marineInsuranceController.selectedPartnerInTheCompanyOption = yesTxt;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: yesTxt,
                                          groupValue: marineInsuranceController.selectedPartnerInTheCompanyOption,
                                          onChanged: (value) {
                                            setState(() {
                                              marineInsuranceController.selectedPartnerInTheCompanyOption = value!;
                                            });
                                          },
                                        ),
                                        AppText(text: yesTxt, size: 15, fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        marineInsuranceController.selectedPartnerInTheCompanyOption = noTxt;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: noTxt,
                                          groupValue: marineInsuranceController.selectedPartnerInTheCompanyOption,
                                          onChanged: (value) {
                                            setState(() {
                                              marineInsuranceController.selectedPartnerInTheCompanyOption = value!;
                                            });
                                          },
                                        ),
                                        AppText(text: noTxt, size: 15, fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              AppText(text: mariq2, size: 15, txtAlign: TextAlign.start),
                              const SizedBox(height: 4),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption = yesTxt;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: yesTxt,
                                          groupValue: marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption,
                                          onChanged: (value) {
                                            setState(() {
                                              marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption = value!;
                                            });
                                          },
                                        ),
                                        AppText(text: yesTxt, size: 15, fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption = noTxt;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: noTxt,
                                          groupValue: marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption,
                                          onChanged: (value) {
                                            setState(() {
                                              marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption = value!;
                                            });
                                          },
                                        ),
                                        AppText(text: noTxt, size: 15, fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption == yesTxt)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(text: marinq3, size: 15, txtAlign: TextAlign.start),
                                    const SizedBox(height: 8),
                                    AppTextfield(
                                      controller: marineInsuranceController.authorizedPositionController.value,
                                      hint: authorizedPosition,
                                      lable: authorizedPosition,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 10),
                              AppText(text: mariq5, size: 15, txtAlign: TextAlign.start),
                              const SizedBox(height: 4),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        marineInsuranceController.selectedCompanyRegistrationOption = yesTxt;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: yesTxt,
                                          groupValue: marineInsuranceController.selectedCompanyRegistrationOption,
                                          onChanged: (value) {
                                            setState(() {
                                              marineInsuranceController.selectedCompanyRegistrationOption = value!;
                                            });
                                          },
                                        ),
                                        AppText(text: yesTxt, size: 15, fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        marineInsuranceController.selectedCompanyRegistrationOption = noTxt;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: noTxt,
                                          groupValue: marineInsuranceController.selectedCompanyRegistrationOption,
                                          onChanged: (value) {
                                            setState(() {
                                              marineInsuranceController.selectedCompanyRegistrationOption = value!;
                                            });
                                          },
                                        ),
                                        AppText(text: noTxt, size: 15, fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (marineInsuranceController.selectedCompanyRegistrationOption == noTxt)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    AppText(text: marinq6, size: 15, txtAlign: TextAlign.start),
                                    marineInsuranceController.selectedDocuments.isEmpty
                                        ? InkWell(
                                            onTap: () {
                                              selectDocument();
                                            },
                                            child: ImageUploadWidget(borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingDocuments.value))
                                        : NewUploadDocumentsCommonScreen(
                                            documentNameText: documents,
                                            selectedDocumentsImg: marineInsuranceController.selectedDocuments,
                                            removeDocumentFunction: (index) {
                                              removeDocumentsImage(marineInsuranceController.selectedDocuments[index]);
                                            },
                                            addDocumentFunction: () {
                                              selectDocument();
                                            },
                                            addDocText: addDocuments,
                                            isLoading: marineInsuranceController.isLoadingDocuments.value,
                                          ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: /*marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption == noTxt
                      ?  AppText(
                    text: dangerousGoodsErrorMSG,
                    size: 25,
                    txtColor: redShade2,
                  ):*/AppBtnWithColorShades(
                    onTap: () {
                      if (companyValidations()) {

                      } else {
                        widget.onNext();
                      }
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
    });
  }

  Future selectDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingDocuments.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedDocuments.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingDocuments.value = false;
    setState(() {});
  }

  void removeDocumentsImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedDocuments.remove(item);
    }
    setState(() {});
  }

  birthDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(1901), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      print(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      print(formattedDate); //formatted date output using intl package =>  2022-07-04
      //You can format date as per your need

      //endDate = formattedDate;

      setState(() {
        marineInsuranceController.birthDateController.value.text = formattedDate; //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  bool companyValidations() {
    if (marineInsuranceController.individual.value == false) {
      if (marineInsuranceController.companyNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyRegisterNationalIdNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyRegisterNationalIdNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyRegisterNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyRegistrationNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectCompanyCountry.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCountry, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectCompanyCity.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCity, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectCompanyDistrict.value.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDistrict, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.streetNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterStreetName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.buildingNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBuildingNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.officeNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterOfficeNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyTelephoneNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyContactNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyOwnerFirstNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersFirstName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyOwnerSecondNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersSecondName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyOwnerThirdNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersThirdName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyOwnerFamilyNameController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnersFamilyName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.companyOwnerTelephoneNoController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyOwnerNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectedPartnerInTheCompanyOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectPartnerInTheCompanyQuestion, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAreYouAuthorizedToIssueQuestion, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption == yesTxt && marineInsuranceController.authorizedPositionController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterAuthorizedPosition, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectedCompanyRegistrationOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectIsYourAuthorizationIsStatedQuestion, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (marineInsuranceController.selectedCompanyRegistrationOption == noTxt && marineInsuranceController.selectedDocuments.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDocuments, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }
}
