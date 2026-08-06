import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class HomeInsurancePlanSecondScreen extends StatefulWidget {
  Function onNext;

  HomeInsurancePlanSecondScreen({super.key, required this.onNext});

  @override
  State<HomeInsurancePlanSecondScreen> createState() => _HomeInsurancePlanSecondScreenState();
}

class _HomeInsurancePlanSecondScreenState extends State<HomeInsurancePlanSecondScreen> {
  HomeInsuranceController homeInsuranceController = Get.put(HomeInsuranceController());

  /*String? selectedgender;
  String? selectedMaritalStatus;
  TextEditingController startDateController = TextEditingController();
  String? selectcity;*/

  @override
  void initState() {
    homeInsuranceController.init(context);

    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return homeInsuranceController.isLoading.value
              ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AppTextfield(width: 10, hint: policyHolderFirstName, readOnly: true, lable: policyHolderFirstName, controller: homeInsuranceController.policyHolderFirstNameController.value),
                      SizedBox(height: 10),
                      AppTextfield(
                        width: 10,
                        hint: policyHolderSecondName,
                        readOnly: true,
                        lable: policyHolderSecondName,
                        controller: homeInsuranceController.policyHolderSecondNameController.value,
                      ),
                      SizedBox(height: 10),
                      AppTextfield(
                        width: 10,
                        hint: policyHolderThirdName,
                        readOnly: true,
                        lable: policyHolderThirdName,
                        controller: homeInsuranceController.policyHolderThirdNameController.value,
                      ),
                      SizedBox(height: 10),
                      AppTextfield(width: 10, hint: policyHolderFamilyName, readOnly: true, lable: policyHolderFamilyName, controller: homeInsuranceController.policyHolderFamilyNameController.value),
                      SizedBox(height: 10),

                      //  AppTextfield(width: 10, hint: nationality, readOnly: true, lable: nationality,controller: homeInsuranceController.nationalityController.value),

                      CustomDropDownBorderDisable(
                        onchage: (newValue) {
                          setState(() {
                            GetNationalityList cdl = homeInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                            homeInsuranceController.selectNatonality.value = cdl;
                          });
                        },
                        items: homeInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: homeInsuranceController.nationalityList.any((element) => element.id == homeInsuranceController.selectNatonality.value.id) ? homeInsuranceController.selectNatonality.value.id ?? 0 : null,
                        dropdownTitle: nationality,
                      ),

                      SizedBox(height: 10),
                      AppTextfield(width: 10, hint: nationalnopassport, readOnly: true, lable: nationalnopassport, controller: homeInsuranceController.nationPassportNoController.value),
                      SizedBox(height: 10),
                      AppTextfield(width: 10, hint: residenceno, readOnly: true, lable: residenceno, controller: homeInsuranceController.idOrResidenceNoController.value),
                      SizedBox(height: 10),
                      AppTextfield(width: 10, hint: birthdate, readOnly: true, lable: birthdate, controller: homeInsuranceController.birthDateController.value),
                      SizedBox(height: 10),
                      CustomDropDownBorderStringDisable(
                        onchage: (newValue) {
                          setState(() {
                            homeInsuranceController.selectedgender = newValue!;
                          });
                        },
                        items: homeInsuranceController.genderList,
                        selectedValue: homeInsuranceController.selectedgender,
                        dropdownTitle: selectgender,
                      ),
                      SizedBox(height: 10),
                      CustomDropDownBorderStringDisable(
                        onchage: (newValue) {
                          setState(() {
                            homeInsuranceController.selectedMaritalStatus = newValue!;
                          });
                        },
                        items: homeInsuranceController.selectedMaritalStatusList,
                        selectedValue: homeInsuranceController.selectedMaritalStatus,
                        dropdownTitle: mrgstatus,
                      ),
                      SizedBox(height: 10),

                      CustomDropDownBorder1(
                        onchage: (newValue) {
                          setState(() {
                            GetCountryList cdl = homeInsuranceController.placeResidenceList.firstWhere((element) => element.id == newValue);
                            homeInsuranceController.selectPlaceResidence.value = cdl;
                          });
                        },
                        items: homeInsuranceController.placeResidenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: homeInsuranceController.placeResidenceList.any((element) => element.id == homeInsuranceController.selectPlaceResidence.value.id) ? homeInsuranceController.selectPlaceResidence.value.id ?? 0 : null,
                        dropdownTitle: placeofresidence,
                      ),
                      CustomDropDownBorderDisable(
                        onchage: (newValue) {
                          setState(() {
                            OccuptionList cdl = homeInsuranceController.occupationList.firstWhere((element) => element.id == newValue);
                            homeInsuranceController.selectOccupation.value = cdl;
                          });
                        },
                        items: homeInsuranceController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: homeInsuranceController.occupationList.any((element) => element.id == homeInsuranceController.selectOccupation.value.id) ? homeInsuranceController.selectOccupation.value.id ?? 0 : null,
                        dropdownTitle: occupancy,
                      ),
                      /* CustomDropDownBorder(
              onchage: (newValue) {
                setState(() {
                  homeInsuranceController.selectPlaceOfResidence = newValue!;
                });
              },
              items: ['item1', 'item2', 'item3'],
              selectedValue: homeInsuranceController.selectPlaceOfResidence,
              dropdownTitle: placeofresidence,
                        ),*/
                      /*  SizedBox(height: 10),
                        AppTextfield(width: 10, hint: occupancy, lable: occupancy,controller: homeInsuranceController.occupancyController.value),*/
                      const SizedBox(height: 10),
                      AppBtnWithColorShades(
                        onTap: () {
                          /* if(homeInsuranceController.selectPlaceResidence.value ==''){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "Please select place of residence", txtColor: primaryWhite, size: 12)));
                }
               else {*/
                          widget.onNext();
                          // }
                        },
                        btnTxt: next,
                        color1: darkBlue2,
                        color2: darkBlue1,
                      ),
                    ],
                  ),
                );
        }));
  }

  startDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(1901), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      setState(() {
        homeInsuranceController.birthDateController.value.text = formattedDate; //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
