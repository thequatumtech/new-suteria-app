import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/family_medical_insurance_controller.dart';
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

class IndividualFamilyInsuranceThirdScreen extends StatefulWidget {
  Function onNext;

  IndividualFamilyInsuranceThirdScreen({super.key, required this.onNext});

  @override
  State<IndividualFamilyInsuranceThirdScreen> createState() => _IndividualFamilyInsuranceThirdScreenState();
}

class _IndividualFamilyInsuranceThirdScreenState extends State<IndividualFamilyInsuranceThirdScreen> {
  FamilyMedicalInsuranceController familyMedicalInsuranceController = Get.put(FamilyMedicalInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextfield(
                readOnly: true,
                hint: inceptiondate,
                lable: inceptiondate,
                controller: familyMedicalInsuranceController.inceptionDateController.value,
                ontap: () {
                  startDateDialog();
                }),
            const SizedBox(height: 20),
            AppTextfield(
              readOnly: true,
              hint: expiredaate,
              lable: expiredaate,
              controller: familyMedicalInsuranceController.expiryDateController.value,
            ),
            const SizedBox(height: 20),
            /*  AppText(
              text: insurancetype,
              size: 16,
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: DropdownButtonFormField(
                value: familyMedicalInsuranceController.insurancetypes,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                hint: const Text(insurancetype),
                onChanged: (newValue) {
                  setState(() {
                    familyMedicalInsuranceController.insurancetypes = newValue!;
                    if (familyMedicalInsuranceController.insurancetypes == 'In Patient Only') {
                      familyMedicalInsuranceController.getInsuranceLimit(context, '6');
                    } else if (familyMedicalInsuranceController.insurancetypes == 'In & Out Patient Only') {
                      familyMedicalInsuranceController.getInsuranceLimit(context, '7');
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
                  familyMedicalInsuranceController.insurancetypes = newValue!;
                  if (familyMedicalInsuranceController.insurancetypes == inPatientOnly) {
                    familyMedicalInsuranceController.getInsuranceLimit(context, '6');
                  } else if (familyMedicalInsuranceController.insurancetypes == inOutPatientOnly) {
                    familyMedicalInsuranceController.getInsuranceLimit(context, '7');
                  }
                });
              },
              items: const [inPatientOnly, inOutPatientOnly],
              selectedValue: familyMedicalInsuranceController.insurancetypes,
              dropdownTitle: insurancetype,
            ),
            CustomDropDownBorder(
              onchage: (newValue) {
                setState(() {
                  familyMedicalInsuranceController.selectclass = newValue!;
                });
              },
              items: const [vIPClass, firstClass, secondClass, thirdClass],
              selectedValue: familyMedicalInsuranceController.selectclass,
              dropdownTitle: insuranceclass,
            ),
            const SizedBox(height: 10),
            familyMedicalInsuranceController.insurancetypes == inPatientOnly || familyMedicalInsuranceController.insurancetypes == inOutPatientOnly
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownBorder1(
                        dropdownTitle: oinPatientDeductible,
                        onchage: (newValue) {
                          setState(() {
                            try {
                              GetInPatientList cdl = familyMedicalInsuranceController.getInPatientList.firstWhere((element) => element.id == newValue);
                              familyMedicalInsuranceController.selectInPatient.value = cdl;
                            } catch (e) {
                              print(e);
                            }
                            // profileController.selectNationality = newValue;
                          });
                        },
                        items: familyMedicalInsuranceController.getInPatientList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: familyMedicalInsuranceController.getInPatientList.any((element) => element.id == familyMedicalInsuranceController.selectInPatient.value.id) ? familyMedicalInsuranceController.selectInPatient.value.id ?? 0 : null,
                      )
                    ],
                  )
                : const SizedBox(),
            familyMedicalInsuranceController.insurancetypes == inOutPatientOnly
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownBorder1(
                        dropdownTitle: outPatientDeductible,
                        onchage: (newValue) {
                          setState(() {
                            try {
                              GetOutPatientList cdl = familyMedicalInsuranceController.getOutPatientList.firstWhere((element) => element.id == newValue);
                              familyMedicalInsuranceController.selectOutPatient.value = cdl;
                            } catch (e) {
                              print(e);
                            }
                            // profileController.selectNationality = newValue;
                          });
                        },
                        items: familyMedicalInsuranceController.getOutPatientList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: familyMedicalInsuranceController.getOutPatientList.any((element) => element.id == familyMedicalInsuranceController.selectOutPatient.value.id) ? familyMedicalInsuranceController.selectOutPatient.value.id ?? 0 : null,
                      ),
                      CustomDropDownBorder1(
                        dropdownTitle: numberOfVisitsOutPatients,
                        onchage: (newValue) {
                          setState(() {
                            try {
                              GetNoOfVisitsList cdl = familyMedicalInsuranceController.getNoOfVisitsList.firstWhere((element) => element.id == newValue);
                              familyMedicalInsuranceController.selectNoOfVisits.value = cdl;
                            } catch (e) {
                              print(e);
                            }
                            // profileController.selectNationality = newValue;
                          });
                        },
                        items: familyMedicalInsuranceController.getNoOfVisitsList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name.toString() ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: familyMedicalInsuranceController.getNoOfVisitsList.any((element) => element.id == familyMedicalInsuranceController.selectNoOfVisits.value.id) ? familyMedicalInsuranceController.selectNoOfVisits.value.id ?? 0 : null,
                      ),
                    ],
                  )
                : const SizedBox(),
            familyMedicalInsuranceController.isLoadingInsuranceLimit.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        InsuranceLimitListData cdl = familyMedicalInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                        familyMedicalInsuranceController.selectedInsuranceLimit.value = cdl;
                      });
                    },
              items: familyMedicalInsuranceController.insuranceLimitList
                  .map((e) => e.limit)
                  .where((e) => e != null && e!.trim().isNotEmpty)
                  .toSet()  // remove duplicate planName
                  .map((name) => DropdownMenuItem(
                value: name,
                child: Text(getTranslated(context, name!), style: const TextStyle(fontSize: 15, color: primaryBlack)),
              ))
                  .toList(),
              /* items: familyMedicalInsuranceController.insuranceLimitList.map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
               */     selectedValue: familyMedicalInsuranceController.insuranceLimitList.any((element) => element.limit == familyMedicalInsuranceController.selectedInsuranceLimit.value.limit) ? familyMedicalInsuranceController.selectedInsuranceLimit.value.limit ?? 0 : null,
                    dropdownTitle: patientCoverageAmount,
                  ),
            const SizedBox(height: 10),
            /*  familyMedicalInsuranceController.isShowHWValidationMsg.value || familyMedicalInsuranceController.isShowMessage.value
                ? AppText(
                    text: sorryYourRequestTypeOfInsuranceCannotBeProcessedDueToTechnicalUnderwritingPleaseContactUsAnyClarification,
                    txtColor: Colors.red,
                    size: 14,
                  )
                : */
            AppBtnWithColorShades(
              onTap: () {
                if (familyMedicalInsuranceController.inceptionDateController.value.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInceptionDate, txtColor: primaryWhite, size: 12)));
                } else if (familyMedicalInsuranceController.insurancetypes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceType, txtColor: primaryWhite, size: 12)));
                } else if (familyMedicalInsuranceController.selectclass == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectClassOfInsurance, txtColor: primaryWhite, size: 12)));
                } else if (familyMedicalInsuranceController.selectInPatient.value.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInPatientDeductible, txtColor: primaryWhite, size: 12)));
                } else if (familyMedicalInsuranceController.insurancetypes == inOutPatientOnly && familyMedicalInsuranceController.selectOutPatient.value.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectOutPatientDeductible, txtColor: primaryWhite, size: 12)));
                } else if (familyMedicalInsuranceController.insurancetypes == inOutPatientOnly && familyMedicalInsuranceController.selectNoOfVisits.value.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectNumberOfVisitsForOutPatients, txtColor: primaryWhite, size: 12)));
                } else if (familyMedicalInsuranceController.selectedInsuranceLimit.value.limit == null) {
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

  startDateDialog() async {
   /* if (familyMedicalInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (familyMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        familyMedicalInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(familyMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        familyMedicalInsuranceController.initialDate.value = familyMedicalInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        familyMedicalInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      familyMedicalInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: familyMedicalInsuranceController.initialDate.value,
      firstDate: familyMedicalInsuranceController.initialDate.value,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dddd').format(pickedDate);
      familyMedicalInsuranceController.inceptionDateController.value.text = commonDateFormat(formattedDate);
      familyMedicalInsuranceController.expiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(pickedDate)).add(const Duration(days: 364)).toString())));
      setState(() {});
    } else {
      print("Date is not selected");
    }
  }
}
