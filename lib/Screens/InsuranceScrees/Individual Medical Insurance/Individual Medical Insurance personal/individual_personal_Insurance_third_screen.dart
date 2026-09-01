import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_medical_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/model_class/get_in_patient_deductible_model.dart';
import 'package:soperia_user/model_class/get_number_of_visit_model.dart';
import 'package:soperia_user/model_class/get_out_patient_deductible_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class IndividualPersonalInsuranceThirdScreen extends StatefulWidget {
  Function onNext;

  IndividualPersonalInsuranceThirdScreen({super.key, required this.onNext});

  @override
  State<IndividualPersonalInsuranceThirdScreen> createState() => _IndividualPersonalInsuranceThirdScreenState();
}

class _IndividualPersonalInsuranceThirdScreenState extends State<IndividualPersonalInsuranceThirdScreen> {
  IndividualMedicalInsuranceController individualMedicalInsuranceController = Get.put(IndividualMedicalInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextfield(
                readOnly: true,
                hint: inceptiondate,
                lable: inceptiondate,
                controller: individualMedicalInsuranceController.inceptionDateController.value,
                ontap: () {
                  inceptionDateDialog();
                }),
            const SizedBox(height: 20),
            AppTextfield(
              readOnly: true,
              hint: expiredaate,
              lable: expiredaate,
              controller: individualMedicalInsuranceController.expiryDateController.value,
            ),
            const SizedBox(height: 20),
            /*  AppText(text: insurancetype, size: 16, fontWeight: FontWeight.bold),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: DropdownButtonFormField(
                value: individualMedicalInsuranceController.insurancetypes,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                hint: const Text(insurancetype),
                onChanged: (newValue) {
                  setState(() {
                    individualMedicalInsuranceController.insurancetypes = newValue!;
                    if (individualMedicalInsuranceController.insurancetypes == 'In Patient Only') {
                      individualMedicalInsuranceController.getInsuranceLimit(context, '6');
                    } else if (individualMedicalInsuranceController.insurancetypes == 'In & Out Patient Only') {
                      individualMedicalInsuranceController.getInsuranceLimit(context, '7');
                    }
                  });
                },
                items: ['In Patient Only', 'In & Out Patient Only']
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
              ),
            ),*/

            CustomDropDownBorder(
              onchage: (newValue) {
                setState(() {
                  individualMedicalInsuranceController.insurancetypes = newValue!;
                  if (individualMedicalInsuranceController.insurancetypes == inPatientOnly) {
                    individualMedicalInsuranceController.getInsuranceLimit(context, '6');
                  } else if (individualMedicalInsuranceController.insurancetypes == inOutPatientOnly) {
                    individualMedicalInsuranceController.getInsuranceLimit(context, '7');
                  }
                });
              },
              items: const [inPatientOnly, inOutPatientOnly],
              selectedValue: individualMedicalInsuranceController.insurancetypes,
              dropdownTitle: insurancetype,
            ),
            CustomDropDownBorder(
              onchage: (newValue) {
                setState(() {
                  individualMedicalInsuranceController.selectclass = newValue!;
                });
              },
              items: const [vIPClass, firstClass, secondClass, thirdClass],
              selectedValue: individualMedicalInsuranceController.selectclass,
              dropdownTitle: insuranceclass,
            ),
            const SizedBox(height: 10),
            individualMedicalInsuranceController.insurancetypes == inPatientOnly || individualMedicalInsuranceController.insurancetypes == inOutPatientOnly
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownBorder1(
                        dropdownTitle: oinPatientDeductible,
                        onchage: (newValue) {
                          setState(() {
                            try {
                              GetInPatientList cdl = individualMedicalInsuranceController.getInPatientList.firstWhere((element) => element.id == newValue);
                              individualMedicalInsuranceController.selectInPatient.value = cdl;
                            } catch (e) {
                              print(e);
                            }
                          });
                        },
                        items: individualMedicalInsuranceController.getInPatientList
                            .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack))))
                            .toList(),
                        selectedValue: individualMedicalInsuranceController.getInPatientList.any((element) => element.id == individualMedicalInsuranceController.selectInPatient.value.id)
                            ? individualMedicalInsuranceController.selectInPatient.value.id ?? 0
                            : null,
                      )
                    ],
                  )
                : const SizedBox(),
            individualMedicalInsuranceController.insurancetypes == inOutPatientOnly
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownBorder1(
                        dropdownTitle: outPatientDeductible,
                        onchage: (newValue) {
                          setState(() {
                            try {
                              GetOutPatientList cdl = individualMedicalInsuranceController.getOutPatientList.firstWhere((element) => element.id == newValue);
                              individualMedicalInsuranceController.selectOutPatient.value = cdl;
                            } catch (e) {
                              print(e);
                            }
                          });
                        },
                        items: individualMedicalInsuranceController.getOutPatientList
                            .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack))))
                            .toList(),
                        selectedValue: individualMedicalInsuranceController.getOutPatientList.any((element) => element.id == individualMedicalInsuranceController.selectOutPatient.value.id)
                            ? individualMedicalInsuranceController.selectOutPatient.value.id ?? 0
                            : null,
                      ),
                      CustomDropDownBorder1(
                        dropdownTitle: numberOfVisitsOutPatients,
                        onchage: (newValue) {
                          setState(() {
                            try {
                              GetNoOfVisitsList cdl = individualMedicalInsuranceController.getNoOfVisitsList.firstWhere((element) => element.id == newValue);
                              individualMedicalInsuranceController.selectNoOfVisits.value = cdl;
                            } catch (e) {
                              print(e);
                            }
                          });
                        },
                        items: individualMedicalInsuranceController.getNoOfVisitsList
                            .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name.toString() ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack))))
                            .toList(),
                        selectedValue: individualMedicalInsuranceController.getNoOfVisitsList.any((element) => element.id == individualMedicalInsuranceController.selectNoOfVisits.value.id)
                            ? individualMedicalInsuranceController.selectNoOfVisits.value.id ?? 0
                            : null,
                      ),
                    ],
                  )
                : const SizedBox(),
            individualMedicalInsuranceController.isLoadingInsuranceLimit.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        InsuranceLimitListData cdl = individualMedicalInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                        individualMedicalInsuranceController.selectedInsuranceLimit.value = cdl;
                      });
                    },
                    items: individualMedicalInsuranceController.insuranceLimitList
                        .map((e) => e.limit)
                        .where((e) => e != null && e!.trim().isNotEmpty)
                        .toSet() // remove duplicate planName
                        .map((name) => DropdownMenuItem(
                              value: name,
                              child: Text(getTranslated(context, name!), style: const TextStyle(fontSize: 15, color: primaryBlack)),
                            ))
                        .toList(),
                    selectedValue: individualMedicalInsuranceController.insuranceLimitList.any((element) => element.limit == individualMedicalInsuranceController.selectedInsuranceLimit.value.limit)
                        ? individualMedicalInsuranceController.selectedInsuranceLimit.value.limit ?? 0
                        : null,
                    dropdownTitle: patientCoverageAmount,
                  ),
            const SizedBox(height: 10),
            AppBtnWithColorShades(
              onTap: () {
                if (individualMedicalInsuranceController.inceptionDateController.value.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInceptionDate, txtColor: primaryWhite, size: 12)));
                } else if (individualMedicalInsuranceController.insurancetypes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceType, txtColor: primaryWhite, size: 12)));
                } else if (individualMedicalInsuranceController.selectclass == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectClassOfInsurance, txtColor: primaryWhite, size: 12)));
                } else if (individualMedicalInsuranceController.selectInPatient.value.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInPatientDeductible, txtColor: primaryWhite, size: 12)));
                } else if (individualMedicalInsuranceController.insurancetypes == inOutPatientOnly && individualMedicalInsuranceController.selectOutPatient.value.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectOutPatientDeductible, txtColor: primaryWhite, size: 12)));
                } else if (individualMedicalInsuranceController.insurancetypes == inOutPatientOnly && individualMedicalInsuranceController.selectNoOfVisits.value.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectNumberOfVisitsForOutPatients, txtColor: primaryWhite, size: 12)));
                } else if (individualMedicalInsuranceController.selectedInsuranceLimit.value.limit == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInPatientInsuranceLimitInPatientCoverageAmount, txtColor: primaryWhite, size: 12)));
                } else {
                  widget.onNext();
                }
              },
              btnTxt: continuE,
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

  inceptionDateDialog() async {
    /*  if (individualMedicalInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (individualMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        individualMedicalInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(individualMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        individualMedicalInsuranceController.initialDate.value = individualMedicalInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        individualMedicalInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      individualMedicalInsuranceController.initialDate.value = DateTime.now();
    }*/

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: individualMedicalInsuranceController.initialDate.value,
      firstDate: individualMedicalInsuranceController.initialDate.value,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      print(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dddd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      individualMedicalInsuranceController.inceptionDateController.value.text = commonDateFormat(formattedDate);
      individualMedicalInsuranceController.expiryDateController.value.text =
          commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(pickedDate)).add(const Duration(days: 364)).toString())));

      setState(() {});
    } else {
      print("Date is not selected");
    }
  }
}
