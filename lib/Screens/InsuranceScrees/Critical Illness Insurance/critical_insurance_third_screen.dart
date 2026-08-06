import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_illness_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/utils.dart';
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';

class CriticalInsuranceThirdScreen extends StatefulWidget {
  Function onNext;

  CriticalInsuranceThirdScreen({super.key, required this.onNext});

  @override
  State<CriticalInsuranceThirdScreen> createState() => _CriticalInsuranceThirdScreenState();
}

class _CriticalInsuranceThirdScreenState extends State<CriticalInsuranceThirdScreen> {
  CriticalIllnessInsuranceController criticalIllnessInsuranceController = Get.put(CriticalIllnessInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    AppText(text: heightcm, size: 12),
                    const SizedBox(width: 100),
                    AppText(text: weightkg, size: 12),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                        width: 120,
                        child: AppTextfield(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                          hint: height,
                          lable: height,
                          controller: criticalIllnessInsuranceController.heightController.value,
                          onChange: () {
                            criticalIllnessInsuranceController.isShowHWValidationMsg.value = Utils.heightWeightValidation(
                                height: criticalIllnessInsuranceController.heightController.value.text, weight: criticalIllnessInsuranceController.weightController.value.text);
                          },
                        )),
                    const SizedBox(width: 60),
                    SizedBox(
                      width: 120,
                      child: AppTextfield(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                        hint: weight,
                        lable: weight,
                        controller: criticalIllnessInsuranceController.weightController.value,
                        onChange: () {
                          criticalIllnessInsuranceController.isShowHWValidationMsg.value = Utils.heightWeightValidation(
                              height: criticalIllnessInsuranceController.heightController.value.text, weight: criticalIllnessInsuranceController.weightController.value.text);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            /*  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: doYouAnyChronicDisease, size: 15, txtAlign: TextAlign.start),
              ],
            ),


            const SizedBox(height: 20),*/

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: doYouAnyChronicDisease, size: 15, txtAlign: TextAlign.start),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: criticalIllnessInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      criticalIllnessInsuranceController.selectedChronicDisease = value!;
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: criticalIllnessInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      criticalIllnessInsuranceController.selectedChronicDisease = value!;
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),
            if (criticalIllnessInsuranceController.selectedChronicDisease == yesTxt) ...[
              MultiSelectDialogField<GetChronicDiseasesList>(
                items: criticalIllnessInsuranceController.getChronicDiseasesList.map((e) => MultiSelectItem<GetChronicDiseasesList>(e, e.name ?? '')).toList(),
                title: const Text(selectchodiseases),
                selectedColor: blueShade1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: skyBlueShade1),
                ),
                buttonIcon: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                ),
                buttonText: const Text(
                  selectchodiseases,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onConfirm: (List<GetChronicDiseasesList> selectedValues) {
                  criticalIllnessInsuranceController.selectedChronicDiseasesList.value = selectedValues;
                },
                initialValue: criticalIllnessInsuranceController.selectedChronicDiseasesList.value,
              ),
            ],

            /*  Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: criticalIllnessInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      criticalIllnessInsuranceController.selectedChronicDisease = value!;
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: criticalIllnessInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      criticalIllnessInsuranceController.selectedChronicDisease = value!;
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),


            if (criticalIllnessInsuranceController.selectedChronicDisease == yesTxt)CustomDropDownBorder1(
              dropdownTitle: selectchodiseases,
              onchage: (newValue) {
                setState(() {
                  try {
                    GetChronicDiseasesList cdl = criticalIllnessInsuranceController.getChronicDiseasesList.firstWhere((element) => element.id == newValue);
                    criticalIllnessInsuranceController.selectChronicDiseases.value = cdl;
                  } catch (e) {
                    print(e);
                  }
                  // profileController.selectNationality = newValue;
                });
              },
              items: criticalIllnessInsuranceController.getChronicDiseasesList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: criticalIllnessInsuranceController.getChronicDiseasesList.any((element) => element.id == criticalIllnessInsuranceController.selectChronicDiseases.value.id) ? criticalIllnessInsuranceController.selectChronicDiseases.value.id ?? 0 : null,
            ),*/

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(
                        text: indiq2,
                        size: 15,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: criticalIllnessInsuranceController.selectedOption,
                        onChanged: (value) {
                          setState(() {
                            criticalIllnessInsuranceController.selectedOption = value!;
                          });
                        },
                      ),
                      Text(yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: criticalIllnessInsuranceController.selectedOption,
                        onChanged: (value) {
                          setState(() {
                            criticalIllnessInsuranceController.selectedOption = value!;
                          });
                        },
                      ),
                      Text(noTxt),
                    ],
                  ),
                ],
              ),
            ),
            if (criticalIllnessInsuranceController.selectedOption == yesTxt)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextfield(controller: criticalIllnessInsuranceController.operationDetailsController.value, hint: indiqnote, lable: indiqnote),
              ),
            criticalIllnessInsuranceController.isShowHWValidationMsg.value
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppText(
                      text: sorryYourRequestTypeOfInsuranceCannotBeProcessedDueToTechnicalUnderwritingPleaseContactUsAnyClarification,
                      txtColor: Colors.red,
                      size: 14,
                    ),
                  )
                : AppBtnWithColorShades(
                    onTap: () {
                      if (criticalIllnessInsuranceController.selectedOption == yesTxt && criticalIllnessInsuranceController.operationDetailsController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterOperationDetails, txtColor: primaryWhite, size: 12)));
                      } else if (criticalIllnessInsuranceController.heightController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterHeight, txtColor: primaryWhite, size: 12)));
                      } else if (criticalIllnessInsuranceController.weightController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterWeight, txtColor: primaryWhite, size: 12)));
                      }
                      /*else if (criticalIllnessInsuranceController.selectChronicDiseases.value.name == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                }*/
                      else {
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
      ),
    );
  }
}
