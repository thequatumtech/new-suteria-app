import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/motor_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class AutomotiveInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  AutomotiveInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<AutomotiveInsuranceFirstScreen> createState() => _AutomotiveInsuranceFirstScreenState();
}

class _AutomotiveInsuranceFirstScreenState extends State<AutomotiveInsuranceFirstScreen> {
  MotorInsuranceController motorInsuranceController = Get.put(MotorInsuranceController());

  @override
  void initState() {
    motorInsuranceController.initMethodCall(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return motorInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AppTextfield(
                    width: 10,
                    hint: policyHolderFirstName,
                    lable: policyHolderFirstName,
                    readOnly: true,
                    controller: motorInsuranceController.policyHolderFirstNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderSecondName,
                    lable: policyHolderSecondName,
                    readOnly: true,
                    controller: motorInsuranceController.policyHolderSecondNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderThirdName,
                    lable: policyHolderThirdName,
                    readOnly: true,
                    controller: motorInsuranceController.policyHolderThirdNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: policyHolderFamilyName,
                    lable: policyHolderFamilyName,
                    readOnly: true,
                    controller: motorInsuranceController.policyHolderFamilyNameController.value,
                  ),
                  const SizedBox(height: 10),
                  /*  CustomDropDownBorder1(
            onchage: (newValue) {
              setState(() {
                GetNationalityList cdl = motorInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                motorInsuranceController.selectNationality.value = cdl;
              });
            },
            items: motorInsuranceController.nationalityList
                .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style:  TextStyle(fontSize: 15, color: primaryBlack))))
                .toList(),
            selectedValue:motorInsuranceController.nationalityList.any((element) => element.id == motorInsuranceController.selectNationality.value.id)
                ? motorInsuranceController.selectNationality.value.id ?? 0
                : null,
            dropdownTitle: nationality,
          ),*/
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = motorInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        motorInsuranceController.selectNatonality.value = cdl;
                      });
                    },
                    items: motorInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: motorInsuranceController.nationalityList.any((element) => element.id == motorInsuranceController.selectNatonality.value.id) ? motorInsuranceController.selectNatonality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: nationalnopassport,
                    lable: nationalnopassport,
                    readOnly: true,
                    controller: motorInsuranceController.nationPassportNoController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: residenceno,
                    lable: residenceno,
                    readOnly: true,
                    controller: motorInsuranceController.idOrResidenceNoController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    hint: birthdate,
                    lable: birthdate,
                    controller: motorInsuranceController.birthDateController.value,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        motorInsuranceController.selectedGender = newValue!;
                      });
                    },
                    items: motorInsuranceController.genderList,
                    selectedValue: motorInsuranceController.selectedGender,
                    dropdownTitle: selectgender,
                  ),
                  const SizedBox(height: 10),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        motorInsuranceController.selectedMaritalStatus = newValue!;
                      });
                    },
                    items: motorInsuranceController.maritalStatusList,
                    selectedValue: motorInsuranceController.selectedMaritalStatus,
                    dropdownTitle: mrgstatus,
                  ),
                  const SizedBox(height: 10),
                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        OccuptionList cdl = motorInsuranceController.occupationList.firstWhere((element) => element.id == newValue);
                        motorInsuranceController.selectOccupation.value = cdl;
                      });
                    },
                    items: motorInsuranceController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: motorInsuranceController.occupationList.any((element) => element.id == motorInsuranceController.selectOccupation.value.id) ? motorInsuranceController.selectOccupation.value.id ?? 0 : null,
                    dropdownTitle: occupancy,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
            );
    });
  }

  startDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime.now(), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      setState(() {
        motorInsuranceController.birthDateController.value.text = formattedDate;
      });
    } else {
      print("Date is not selected");
    }
  }
}
