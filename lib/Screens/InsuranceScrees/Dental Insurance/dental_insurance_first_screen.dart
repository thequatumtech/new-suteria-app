import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class DentalInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  DentalInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<DentalInsuranceFirstScreen> createState() => _DentalInsuranceFirstScreenState();
}

class _DentalInsuranceFirstScreenState extends State<DentalInsuranceFirstScreen> {
  DentalInsuranceController dentalInsuranceController = Get.put(DentalInsuranceController());

  @override
  void initState() {
    dentalInsuranceController.initCall(context);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => dentalInsuranceController.isLoading.value
        ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(
                  width: 10,
                  hint: policyHolderFirstName,
                  lable: policyHolderFirstName,
                  readOnly: true,
                  controller: dentalInsuranceController.policyHolderFirstNameController.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(
                  width: 10,
                  hint: policyHolderSecondName,
                  lable: policyHolderSecondName,
                  readOnly: true,
                  controller: dentalInsuranceController.policyHolderSecondNameController.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(
                  width: 10,
                  hint: policyHolderThirdName,
                  lable: policyHolderThirdName,
                  readOnly: true,
                  controller: dentalInsuranceController.policyHolderThirdNameController.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(
                  width: 10,
                  hint: policyHolderFamilyName,
                  lable: policyHolderFamilyName,
                  readOnly: true,
                  controller: dentalInsuranceController.policyHolderFamilyNameController.value,
                ),
              ),
              /*  Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(
            width: 10,
            hint: nationality,
            lable: nationality,
             readOnly: true,
            controller: dentalInsuranceController.nationalityController.value,
          ),
        ),*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropDownBorderDisable(
                  onchage: (newValue) {
                    setState(() {
                      GetNationalityList cdl = dentalInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                      dentalInsuranceController.selectNatonality.value = cdl;
                    });
                  },
                  items: dentalInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  selectedValue: dentalInsuranceController.nationalityList.any((element) => element.id == dentalInsuranceController.selectNatonality.value.id) ? dentalInsuranceController.selectNatonality.value.id ?? 0 : null,
                  dropdownTitle: nationality,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(
                  width: 10,
                  hint: nationalnopassport,
                  lable: nationalnopassport,
                  readOnly: true,
                  controller: dentalInsuranceController.nationPassportNoController.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(
                  width: 10,
                  hint: residenceno,
                  lable: residenceno,
                  readOnly: true,
                  controller: dentalInsuranceController.idOrResidenceNoController.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(
                  width: 10,
                  hint: birthdate,
                  lable: birthdate,
                  controller: dentalInsuranceController.birthDateController.value,
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomDropDownBorderStringDisable(
                  onchage: (newValue) {
                    setState(() {
                      dentalInsuranceController.selectedgender = newValue!;
                    });
                  },
                  items: dentalInsuranceController.genderList,
                  selectedValue: dentalInsuranceController.selectedgender,
                  dropdownTitle: selectgender,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomDropDownBorderStringDisable(
                  onchage: (newValue) {
                    setState(() {
                      dentalInsuranceController.selectedMaritalStatus = newValue!;
                    });
                  },
                  items: dentalInsuranceController.maritalStatusList,
                  selectedValue: dentalInsuranceController.selectedMaritalStatus,
                  dropdownTitle: mrgstatus,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomDropDownBorder1(
                  onchage: (newValue) {
                    setState(() {
                      GetCountryList cdl = dentalInsuranceController.residenceList.firstWhere((element) => element.id == newValue);
                      dentalInsuranceController.selectResidence.value = cdl;
                    });
                  },
                  items: dentalInsuranceController.residenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  selectedValue: dentalInsuranceController.residenceList.any((element) => element.id == dentalInsuranceController.selectResidence.value.id) ? dentalInsuranceController.selectResidence.value.id ?? 0 : null,
                  dropdownTitle: placeofresidence,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropDownBorderDisable(
                  onchage: (newValue) {
                    setState(() {
                      OccuptionList cdl = dentalInsuranceController.occupationList.firstWhere((element) => element.id == newValue);
                      dentalInsuranceController.selectOccupation.value = cdl;
                    });
                  },
                  items: dentalInsuranceController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  selectedValue: dentalInsuranceController.occupationList.any((element) => element.id == dentalInsuranceController.selectOccupation.value.id) ? dentalInsuranceController.selectOccupation.value.id ?? 0 : null,
                  dropdownTitle: occupancy,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: AppBtnWithColorShades(
                  onTap: () {
                    if (dentalInsuranceController.selectedMaritalStatus == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectYourMaritalStatus, txtColor: primaryWhite, size: 12)));
                    } else if (dentalInsuranceController.selectResidence.value.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectYourResidence, txtColor: primaryWhite, size: 12)));
                    } else {
                      widget.onNext();
                    }
                  },
                  btnTxt: next,
                  color1: darkBlue2,
                  color2: darkBlue1,
                ),
              ),
            ],
          ));
  }

  startDateDialog() async {
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
        dentalInsuranceController.birthDateController.value.text = formattedDate; //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
