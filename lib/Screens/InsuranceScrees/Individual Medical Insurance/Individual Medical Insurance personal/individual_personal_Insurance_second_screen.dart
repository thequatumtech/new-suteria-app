import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_medical_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/new_upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';
import 'package:soperia_user/app_utils/utils.dart';
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';

class IndividualPersonalInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  IndividualPersonalInsuranceSecondScreen({Key? key, required this.onNext}) : super(key: key);

  @override
  State<IndividualPersonalInsuranceSecondScreen> createState() => _IndividualPersonalInsuranceSecondScreenState();
}

class _IndividualPersonalInsuranceSecondScreenState extends State<IndividualPersonalInsuranceSecondScreen> {
  IndividualMedicalInsuranceController individualMedicalInsuranceController = Get.put(IndividualMedicalInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: indiq1, size: 15, txtAlign: TextAlign.start),
            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption,
                  onChanged: (value) {
                    setState(() {
                      individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption = value!;
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption,
                  onChanged: (value) {
                    setState(() {
                      individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption = value!;
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),
            if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt) ...[
              const SizedBox(height: 20),
              AppTextfield(
                controller: individualMedicalInsuranceController.insuranceCompanyNameController.value,
                width: 10,
                hint: insurancecompnyname,
                lable: insurancecompnyname,
              ),
              const SizedBox(height: 20),
              AppTextfield(
                controller: individualMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value,
                width: 10,
                hint: expiredaate,
                lable: expiredaate,
                ontap: () {
                  expiryDate();
                },
                readOnly: true,
              ),
              individualMedicalInsuranceController.selectedMedicalCard.isEmpty
                  ? InkWell(
                      onTap: () {
                        selectMedicalCardDocument();
                      },
                      child: ImageUploadWidget(txt: uploadYourMedicalCard, borderColor: skyBlueShade2, isLoading: individualMedicalInsuranceController.isLoadingMedicalCard.value))
                  : NewUploadDocumentsCommonScreen(
                      documentNameText: documents,
                      selectedDocumentsImg: individualMedicalInsuranceController.selectedMedicalCard,
                      removeDocumentFunction: (index) {
                        removeMedicalCardImage(individualMedicalInsuranceController.selectedMedicalCard[index]);
                      },
                      addDocumentFunction: () {
                        selectMedicalCardDocument();
                      },
                      addDocText: addDocuments,
                      isLoading: individualMedicalInsuranceController.isLoadingMedicalCard.value,
                    ),
            ],
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(text: heightcm, size: 12),
                        const SizedBox(height: 10),
                        AppTextfield(
                            hint: height,
                            onChange: () {
                              if (individualMedicalInsuranceController.heightController.value.text.isNotEmpty && individualMedicalInsuranceController.weightController.value.text.isNotEmpty) {
                                individualMedicalInsuranceController.isShowHWValidationMsg.value = Utils.heightWeightValidation(
                                    height: individualMedicalInsuranceController.heightController.value.text, weight: individualMedicalInsuranceController.weightController.value.text);
                              }
                            },
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                            lable: height,
                            controller: individualMedicalInsuranceController.heightController.value),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(text: weightkg, size: 12),
                        const SizedBox(height: 10),
                        AppTextfield(
                            hint: weight,
                            onChange: () {
                              if (individualMedicalInsuranceController.heightController.value.text.isNotEmpty && individualMedicalInsuranceController.weightController.value.text.isNotEmpty) {
                                individualMedicalInsuranceController.isShowHWValidationMsg.value = Utils.heightWeightValidation(
                                    height: individualMedicalInsuranceController.heightController.value.text, weight: individualMedicalInsuranceController.weightController.value.text);
                              }
                            },
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                            lable: weight,
                            controller: individualMedicalInsuranceController.weightController.value),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /* if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == noTxt) ...[
          ,
            ],*/
            const SizedBox(height: 20),
            /* CustomDropDownBorder1(
              dropdownTitle: selectchodiseases,
              onchage: (newValue) {
                setState(() {
                  try {
                    GetChronicDiseasesList cdl = individualMedicalInsuranceController.getChronicDiseasesList.firstWhere((element) => element.id == newValue);
                    individualMedicalInsuranceController.selectChronicDiseases.value = cdl;
                  } catch (e) {
                    print(e);
                  }
                });
              },
              items: individualMedicalInsuranceController.getChronicDiseasesList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: individualMedicalInsuranceController.getChronicDiseasesList.any((element) => element.id == individualMedicalInsuranceController.selectChronicDiseases.value.id) ? individualMedicalInsuranceController.selectChronicDiseases.value.id ?? 0 : null,
            ),*/

            AppText(text: doYouAnyChronicDisease, size: 15, txtAlign: TextAlign.start),

            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: individualMedicalInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      individualMedicalInsuranceController.selectedChronicDisease = value!;
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: individualMedicalInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      individualMedicalInsuranceController.selectedChronicDisease = value!;
                      individualMedicalInsuranceController.selectedChronicDiseasesList.value = [];
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),

            if (individualMedicalInsuranceController.selectedChronicDisease == yesTxt) ...[
              MultiSelectDialogField<GetChronicDiseasesList>(
                items: individualMedicalInsuranceController.getChronicDiseasesList.map((e) => MultiSelectItem<GetChronicDiseasesList>(e, e.name ?? '')).toList(),
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
                  setState(() {
                    individualMedicalInsuranceController.selectedChronicDiseasesList.value = selectedValues;
                  });
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      individualMedicalInsuranceController.selectedChronicDiseasesList.remove(value);
                    });
                  },
                ),
                initialValue: individualMedicalInsuranceController.selectedChronicDiseasesList.value,
              ),
            ],

            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: indiq2, size: 15),
                Row(
                  children: <Widget>[
                    Radio(
                      value: yesTxt,
                      groupValue: individualMedicalInsuranceController.selectedPreviousOperationsOption,
                      onChanged: (value) {
                        setState(() {
                          individualMedicalInsuranceController.selectedPreviousOperationsOption = value!;
                        });
                      },
                    ),
                    const Text(yesTxt),
                    Radio(
                      value: noTxt,
                      groupValue: individualMedicalInsuranceController.selectedPreviousOperationsOption,
                      onChanged: (value) {
                        setState(() {
                          individualMedicalInsuranceController.selectedPreviousOperationsOption = value!;
                        });
                      },
                    ),
                    const Text(noTxt),
                  ],
                ),
              ],
            ),
            if (individualMedicalInsuranceController.selectedPreviousOperationsOption == yesTxt) ...[
              AppTextfield(
                hint: indiqnote,
                lable: indiqnote,
                controller: individualMedicalInsuranceController.detailsAboutPreviousOperationsController.value,
              ),
            ],
            const SizedBox(height: 20),
            if (individualMedicalInsuranceController.selectedGender == female && individualMedicalInsuranceController.selectedMaritalStatus == married)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: indiq3, size: 15),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: individualMedicalInsuranceController.selectedPregnantOption,
                        onChanged: (value) {
                          setState(() {
                            individualMedicalInsuranceController.selectedPregnantOption = value!;
                          });
                        },
                      ),
                      const Text(yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: individualMedicalInsuranceController.selectedPregnantOption,
                        onChanged: (value) {
                          setState(() {
                            individualMedicalInsuranceController.selectedPregnantOption = value!;
                          });
                        },
                      ),
                      const Text(noTxt),
                    ],
                  ),
                  if (individualMedicalInsuranceController.selectedPregnantOption == yesTxt) ...[
                    AppText(text: indiq4, size: 15),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomDropDownBorder(
                      onchage: (newValue) {
                        setState(() {
                          individualMedicalInsuranceController.selectmonth = newValue!;
                        });
                      },
                      items: const [month1, month2, month3, month4, month5, month6, month7, month8, month9],
                      selectedValue: individualMedicalInsuranceController.selectmonth,
                      dropdownTitle: selectmonts,
                    ),
                  ],
                  individualMedicalInsuranceController.selectedPregnantOption == yesTxt
                      ? AppText(
                          text: pleaseNoteThatThePregnancyCaseWillNotBeCovered,
                          txtColor: Colors.red,
                          size: 14,
                        )
                      : const SizedBox(),
                ],
              ),
            const SizedBox(height: 12),
            AppText(text: anyDangerousActivities, size: 15),
            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: individualMedicalInsuranceController.selectDangerousActivity,
                  onChanged: (value) {
                    setState(() {
                      individualMedicalInsuranceController.selectDangerousActivity = value!;
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: individualMedicalInsuranceController.selectDangerousActivity,
                  onChanged: (value) {
                    setState(() {
                      individualMedicalInsuranceController.selectDangerousActivity = value!;
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),
            /*individualMedicalInsuranceController.selectDangerousActivity == yesTxt
                ? Column(
                    children: [
                      CustomDropDownBorder1(
                        dropdownTitle: dangerousActivities,
                        onchage: (newValue) {
                          setState(() {
                            try {
                              GetDangerousActivitiesList cdl = individualMedicalInsuranceController.getDangerousActivitiesList.firstWhere((element) => element.id == newValue);
                              individualMedicalInsuranceController.selectDangerousActivitiesList.value = cdl;
                            } catch (e) {
                              print(e);
                            }
                            // profileController.selectNationality = newValue;
                          });
                        },
                        items: individualMedicalInsuranceController.getDangerousActivitiesList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue:
                            individualMedicalInsuranceController.getDangerousActivitiesList.any((element) => element.id == individualMedicalInsuranceController.selectDangerousActivitiesList.value.id) ? individualMedicalInsuranceController.selectDangerousActivitiesList.value.id ?? 0 : null,
                      ),
                    ],
                  )
                : const SizedBox(),*/

            if (individualMedicalInsuranceController.selectDangerousActivity == yesTxt) ...[
              MultiSelectDialogField<GetDangerousActivitiesList>(
                items: individualMedicalInsuranceController.getDangerousActivitiesList.map((e) => MultiSelectItem<GetDangerousActivitiesList>(e, e.name ?? '')).toList(),
                title: const Text(dangerousActivities),
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
                  dangerousActivities,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onConfirm: (List<GetDangerousActivitiesList> selectedValues) {
                  individualMedicalInsuranceController.selectDangerousActivitiesList.value = selectedValues;
                },
                initialValue: individualMedicalInsuranceController.selectDangerousActivitiesList,
              ),
            ],

            const SizedBox(height: 10),
            /*   individualMedicalInsuranceController.selectDangerousActivity == noTxt
                ?*/
            Column(
              children: [
                individualMedicalInsuranceController.selectedIdFrontSide.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectIdFrontSideDocument();
                        },
                        child: ImageUploadWidget(txt: addIDFrontSidePassport, borderColor: skyBlueShade2, isLoading: individualMedicalInsuranceController.isLoadingIdFrontSide.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: iDFrontSidePassportDocuments,
                        selectedDocumentsImg: individualMedicalInsuranceController.selectedIdFrontSide,
                        removeDocumentFunction: (index) {
                          removeIdFrontSideImage(individualMedicalInsuranceController.selectedIdFrontSide[index]);
                        },
                        addDocumentFunction: () {
                          selectIdFrontSideDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: individualMedicalInsuranceController.isLoadingIdFrontSide.value,
                      ),
                individualMedicalInsuranceController.selectedIdBackSide.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectIdBackSideDocument();
                        },
                        child: ImageUploadWidget(txt: addIDBackSidePassport, borderColor: skyBlueShade2, isLoading: individualMedicalInsuranceController.isLoadingIdBackSide.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: iDBackSidePassportDocuments,
                        selectedDocumentsImg: individualMedicalInsuranceController.selectedIdBackSide,
                        removeDocumentFunction: (index) {
                          removeIdBackSideImage(individualMedicalInsuranceController.selectedIdBackSide[index]);
                        },
                        addDocumentFunction: () {
                          selectIdBackSideDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: individualMedicalInsuranceController.isLoadingIdBackSide.value,
                      ),
                individualMedicalInsuranceController.selectedFamilyBook.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectFamilyBookDocument();
                        },
                        child: ImageUploadWidget(txt: addFamilyBookPhotos, borderColor: skyBlueShade2, isLoading: individualMedicalInsuranceController.isLoadingFamilyBook.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: familyBookDocuments,
                        selectedDocumentsImg: individualMedicalInsuranceController.selectedFamilyBook,
                        removeDocumentFunction: (index) {
                          removeFamilyBookImage(individualMedicalInsuranceController.selectedFamilyBook[index]);
                        },
                        addDocumentFunction: () {
                          selectFamilyBookDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: individualMedicalInsuranceController.isLoadingFamilyBook.value,
                      ),
                individualMedicalInsuranceController.selectedPersonalPic.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectPersonalPicDocument();
                        },
                        child: ImageUploadWidget(txt: addPersonalPicture, borderColor: skyBlueShade2, isLoading: individualMedicalInsuranceController.isLoadingPersonalPic.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: personalPictureDocuments,
                        selectedDocumentsImg: individualMedicalInsuranceController.selectedPersonalPic,
                        removeDocumentFunction: (index) {
                          removePersonalPicImage(individualMedicalInsuranceController.selectedPersonalPic[index]);
                        },
                        addDocumentFunction: () {
                          selectPersonalPicDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: individualMedicalInsuranceController.isLoadingPersonalPic.value,
                      ),
                individualMedicalInsuranceController.selectedOtherMembers.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectOtherMembersDocument();
                        },
                        child: ImageUploadWidgetSubText(
                            txt: uploadInsuranceCardForOtherMembersInTheFamilyBookInsuredSomewhereElse,
                            subTxt: noOtherMemberInsurable,
                            borderColor: skyBlueShade2,
                            isLoading: individualMedicalInsuranceController.isLoadingOtherMembers.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: otherMemberDocuments,
                        selectedDocumentsImg: individualMedicalInsuranceController.selectedOtherMembers,
                        removeDocumentFunction: (index) {
                          removeOtherMembersImage(individualMedicalInsuranceController.selectedOtherMembers[index]);
                        },
                        addDocumentFunction: () {
                          selectOtherMembersDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: individualMedicalInsuranceController.isLoadingOtherMembers.value,
                      ),
              ],
            ),
            // : const SizedBox(),
            const SizedBox(height: 20),
            individualMedicalInsuranceController.selectDangerousActivity == yesTxt || individualMedicalInsuranceController.isShowHWValidationMsg.value
                ? AppText(
                    text: sorryYourRequestTypeOfInsuranceCannotBeProcessedDueToTechnicalUnderwritingPleaseContactUsAnyClarification,
                    txtColor: Colors.red,
                    size: 14,
                  )
                : AppBtnWithColorShades(
                    onTap: () {
                      if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAnyExistingMedicalInsurancePolicyOption, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt &&
                          individualMedicalInsuranceController.insuranceCompanyNameController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterInsuranceCompanyName, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt &&
                          individualMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt && individualMedicalInsuranceController.selectedMedicalCard.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadYourMedicalCard, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == noTxt &&
                          individualMedicalInsuranceController.heightController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterHeight, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == noTxt &&
                          individualMedicalInsuranceController.weightController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterWeight, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedChronicDisease == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedChronicDisease == yesTxt && individualMedicalInsuranceController.selectedChronicDiseasesList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedPreviousOperationsOption == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAnyPreviousOperationsOption, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedPreviousOperationsOption == yesTxt &&
                          individualMedicalInsuranceController.detailsAboutPreviousOperationsController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPreviousOperationsDetails, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedGender == female &&
                          individualMedicalInsuranceController.selectedMaritalStatus == married &&
                          individualMedicalInsuranceController.selectedPregnantOption == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAreYouPregnantOption, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectedGender == female &&
                          individualMedicalInsuranceController.selectedMaritalStatus == married &&
                          individualMedicalInsuranceController.selectedPregnantOption == yesTxt &&
                          individualMedicalInsuranceController.selectmonth == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMonth, txtColor: primaryWhite, size: 12)));
                      } else if (individualMedicalInsuranceController.selectDangerousActivity == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesOptions, txtColor: primaryWhite, size: 12)));
                      }
                      /*else if (individualMedicalInsuranceController.selectDangerousActivity == yesTxt && individualMedicalInsuranceController.selectDangerousActivitiesList.value.id == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesList, txtColor: primaryWhite, size: 12)));
                      }*/
                      else if (/*individualMedicalInsuranceController.selectDangerousActivity == noTxt &&*/ individualMedicalInsuranceController.selectedIdFrontSide.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadIdFrontSidePassport, txtColor: primaryWhite, size: 12)));
                      } else if (/*individualMedicalInsuranceController.selectDangerousActivity == noTxt && */ individualMedicalInsuranceController.selectedIdBackSide.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadIdBackSidePassport, txtColor: primaryWhite, size: 12)));
                      } else if (/*individualMedicalInsuranceController.selectDangerousActivity == noTxt &&*/ individualMedicalInsuranceController.selectedFamilyBook.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadFamilyBook, txtColor: primaryWhite, size: 12)));
                      } else if (/*individualMedicalInsuranceController.selectDangerousActivity == noTxt &&*/ individualMedicalInsuranceController.selectedPersonalPic.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPersonalPicture, txtColor: primaryWhite, size: 12)));
                      }
                      /* else if (*/ /*individualMedicalInsuranceController.selectDangerousActivity == noTxt &&*/ /* individualMedicalInsuranceController.selectedOtherMembers.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadInsuranceCardForOtherMembers, txtColor: primaryWhite, size: 12)));
                      }*/
                      else {
                        widget.onNext();
                      }
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
          ],
        ),
      ),
    );
  }

  Future selectMedicalCardDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    individualMedicalInsuranceController.isLoadingMedicalCard.value = true;
    final pickedFile = await individualMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 6);
      individualMedicalInsuranceController.selectedMedicalCard.addAll(imagesUrl);
    }
    individualMedicalInsuranceController.isLoadingMedicalCard.value = false;
    setState(() {});
  }

  void removeMedicalCardImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      individualMedicalInsuranceController.selectedMedicalCard.remove(item);
    }
    setState(() {});
  }

  Future selectIdFrontSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    individualMedicalInsuranceController.isLoadingIdFrontSide.value = true;
    final pickedFile = await individualMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 6);
      individualMedicalInsuranceController.selectedIdFrontSide.addAll(imagesUrl);
    }
    individualMedicalInsuranceController.isLoadingIdFrontSide.value = false;
    setState(() {});
  }

  void removeIdFrontSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      individualMedicalInsuranceController.selectedIdFrontSide.remove(item);
    }
    setState(() {});
  }

  Future selectIdBackSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    individualMedicalInsuranceController.isLoadingIdBackSide.value = true;
    final pickedFile = await individualMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 6);
      individualMedicalInsuranceController.selectedIdBackSide.addAll(imagesUrl);
    }
    individualMedicalInsuranceController.isLoadingIdBackSide.value = false;
    setState(() {});
  }

  void removeIdBackSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      individualMedicalInsuranceController.selectedIdBackSide.remove(item);
    }
    setState(() {});
  }

  Future selectFamilyBookDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    individualMedicalInsuranceController.isLoadingFamilyBook.value = true;
    final pickedFile = await individualMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 6);
      individualMedicalInsuranceController.selectedFamilyBook.addAll(imagesUrl);
    }
    individualMedicalInsuranceController.isLoadingFamilyBook.value = false;
    setState(() {});
  }

  void removeFamilyBookImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      individualMedicalInsuranceController.selectedFamilyBook.remove(item);
    }
    setState(() {});
  }

  Future selectPersonalPicDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    individualMedicalInsuranceController.isLoadingPersonalPic.value = true;
    final pickedFile = await individualMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 6);
      individualMedicalInsuranceController.selectedPersonalPic.addAll(imagesUrl);
    }
    individualMedicalInsuranceController.isLoadingPersonalPic.value = false;
    setState(() {});
  }

  void removePersonalPicImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      individualMedicalInsuranceController.selectedPersonalPic.remove(item);
    }
    setState(() {});
  }

  Future selectOtherMembersDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    individualMedicalInsuranceController.isLoadingOtherMembers.value = true;
    final pickedFile = await individualMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 6);
      individualMedicalInsuranceController.selectedOtherMembers.addAll(imagesUrl);
    }
    individualMedicalInsuranceController.isLoadingOtherMembers.value = false;
    setState(() {});
  }

  void removeOtherMembersImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      individualMedicalInsuranceController.selectedOtherMembers.remove(item);
    }
    setState(() {});
  }

  expiryDate() async {
    /*   if (individualMedicalInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (individualMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null) {
        individualMedicalInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(individualMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        // individualMedicalInsuranceController.initialDate.value = individualMedicalInsuranceController.initialDate.value.add(const Duration(days: 365));
      } else {
        individualMedicalInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      individualMedicalInsuranceController.initialDate.value = DateTime.now();
    }*/

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: individualMedicalInsuranceController.initialDate.value, //get today's date
      firstDate: individualMedicalInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dddd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      individualMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value.text = commonDateFormat(formattedDate);

      setState(() {});
    } else {
      print("Date is not selected");
    }
  }
}
