import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/add_member_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/family_medical_insurance_controller.dart';
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
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class IndividualFamilyInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  IndividualFamilyInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<IndividualFamilyInsuranceSecondScreen> createState() => _IndividualFamilyInsuranceSecondScreenState();
}

class _IndividualFamilyInsuranceSecondScreenState extends State<IndividualFamilyInsuranceSecondScreen> {
  FamilyMedicalInsuranceController familyMedicalInsuranceController = Get.put(FamilyMedicalInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: indiq1, size: 15),
            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption = value!;
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption = value!;
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),
            if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextfield(
                    controller: familyMedicalInsuranceController.insuranceCompanyNameController.value,
                    width: 10,
                    hint: insurancecompnyname,
                    lable: insurancecompnyname,
                  ),
                  const SizedBox(height: 20),
                  AppTextfield(
                    controller: familyMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value,
                    width: 10,
                    hint: expiredaate,
                    readOnly: true,
                    ontap: () {
                      expiryDate();
                    },
                    lable: expiredaate,
                  ),
                  const SizedBox(height: 20),
                  familyMedicalInsuranceController.selectedMedicalCard.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectMedicalCardDocument();
                          },
                          child: ImageUploadWidget(txt: uploadYourMedicalCard, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingMedicalCard.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: documents,
                          selectedDocumentsImg: familyMedicalInsuranceController.selectedMedicalCard,
                          removeDocumentFunction: (index) {
                            removeMedicalCardImage(familyMedicalInsuranceController.selectedMedicalCard[index]);
                          },
                          addDocumentFunction: () {
                            selectMedicalCardDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: familyMedicalInsuranceController.isLoadingMedicalCard.value,
                        ),
                ],
              ),
            /*  if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == noTxt)*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              controller: familyMedicalInsuranceController.heightController.value,
                              onChange: () {
                                familyMedicalInsuranceController.isShowHWValidationMsg.value = Utils.heightWeightValidation(
                                    height: familyMedicalInsuranceController.heightController.value.text, weight: familyMedicalInsuranceController.weightController.value.text);
                              },
                              hint: height,
                              lable: height,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))])),
                      const SizedBox(width: 60),
                      SizedBox(
                        width: 120,
                        child: AppTextfield(
                            controller: familyMedicalInsuranceController.weightController.value,
                            onChange: () {
                              familyMedicalInsuranceController.isShowHWValidationMsg.value = Utils.heightWeightValidation(height: familyMedicalInsuranceController.heightController.value.text, weight: familyMedicalInsuranceController.weightController.value.text);
                            },
                            hint: weight,
                            lable: weight,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppText(text: doYouAnyChronicDisease, size: 15, txtAlign: TextAlign.start),

            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: familyMedicalInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedChronicDisease = value!;
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: familyMedicalInsuranceController.selectedChronicDisease,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedChronicDisease = value!;
                      familyMedicalInsuranceController.selectedChronicDiseasesList.value = [];
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),

            if (familyMedicalInsuranceController.selectedChronicDisease == yesTxt) ...[
              MultiSelectDialogField<GetChronicDiseasesList>(
                items: familyMedicalInsuranceController.getChronicDiseasesList.map((e) => MultiSelectItem<GetChronicDiseasesList>(e, e.name ?? '')).toList(),
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
                    familyMedicalInsuranceController.selectedChronicDiseasesList.value = selectedValues;
                  });
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedChronicDiseasesList.remove(value);
                    });
                  },
                ),
                initialValue: familyMedicalInsuranceController.selectedChronicDiseasesList.value,
              ),
            ],

            /* CustomDropDownBorder1(
              dropdownTitle: selectchodiseases,
              onchage: (newValue) {
                setState(() {
                  try {
                    GetChronicDiseasesList cdl = familyMedicalInsuranceController.getChronicDiseasesList.firstWhere((element) => element.id == newValue);
                    familyMedicalInsuranceController.selectChronicDiseases.value = cdl;
                  } catch (e) {
                    print(e);
                  }
                  // profileController.selectNationality = newValue;
                });
              },
              items: familyMedicalInsuranceController.getChronicDiseasesList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
              selectedValue: familyMedicalInsuranceController.getChronicDiseasesList.any((element) => element.id == familyMedicalInsuranceController.selectChronicDiseases.value.id) ? familyMedicalInsuranceController.selectChronicDiseases.value.id ?? 0 : null,
            ),*/
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topLeft, child: AppText(text: indiq2, size: 15)),
                Row(
                  children: <Widget>[
                    Radio(
                      value: yesTxt,
                      groupValue: familyMedicalInsuranceController.selectedPreviousOperationsOption,
                      onChanged: (value) {
                        setState(() {
                          familyMedicalInsuranceController.selectedPreviousOperationsOption = value!;
                        });
                      },
                    ),
                    const Text(yesTxt),
                    Radio(
                      value: noTxt,
                      groupValue: familyMedicalInsuranceController.selectedPreviousOperationsOption,
                      onChanged: (value) {
                        setState(() {
                          familyMedicalInsuranceController.selectedPreviousOperationsOption = value!;
                        });
                      },
                    ),
                    const Text(noTxt),
                  ],
                ),
              ],
            ),
            if (familyMedicalInsuranceController.selectedPreviousOperationsOption == yesTxt)
              AppTextfield(controller: familyMedicalInsuranceController.detailsAboutPreviousOperationsController.value, hint: indiqnote, lable: indiqnote),
            const SizedBox(height: 20),
            if (familyMedicalInsuranceController.selectedGender == female && familyMedicalInsuranceController.selectedMaritalStatus == married)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: indiq3, size: 15),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: familyMedicalInsuranceController.selectedPregnantOption,
                        onChanged: (value) {
                          setState(() {
                            familyMedicalInsuranceController.selectedPregnantOption = value!;
                          });
                        },
                      ),
                      const Text(yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: familyMedicalInsuranceController.selectedPregnantOption,
                        onChanged: (value) {
                          setState(() {
                            familyMedicalInsuranceController.selectedPregnantOption = value!;
                          });
                        },
                      ),
                      const Text(noTxt),
                    ],
                  ),
                  if (familyMedicalInsuranceController.selectedPregnantOption == yesTxt) ...[
                    CustomDropDownBorder(
                      onchage: (newValue) {
                        setState(() {
                          familyMedicalInsuranceController.selectmonth = newValue!;
                        });
                      },
                      items: const [month1, month2, month3, month4, month5, month6, month7, month8, month9],
                      selectedValue: familyMedicalInsuranceController.selectmonth,
                      dropdownTitle: indiq4,
                    )
                  ],
                  const SizedBox(height: 8),
                  familyMedicalInsuranceController.selectedPregnantOption == yesTxt
                      ? AppText(
                          text: pleaseNoteThatThePregnancyCaseWillNotBeCovered,
                          txtColor: Colors.red,
                          size: 14,
                        )
                      : const SizedBox(),
                  const SizedBox(height: 12),
                ],
              ),
            AppText(text: anyDangerousActivities, size: 15),
            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: familyMedicalInsuranceController.selectedDangerousActivity,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedDangerousActivity = value!;
                      familyMedicalInsuranceController.showMessage();
                    });
                  },
                ),
                const Text(yesTxt),
                Radio(
                  value: noTxt,
                  groupValue: familyMedicalInsuranceController.selectedDangerousActivity,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedDangerousActivity = value!;
                      familyMedicalInsuranceController.showMessage();
                    });
                  },
                ),
                const Text(noTxt),
              ],
            ),

            if (familyMedicalInsuranceController.selectedDangerousActivity == yesTxt) ...[
              MultiSelectDialogField<GetDangerousActivitiesList>(
                items: familyMedicalInsuranceController.getDangerousActivitiesList.map((e) => MultiSelectItem<GetDangerousActivitiesList>(e, e.name ?? '')).toList(),
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
                  familyMedicalInsuranceController.selectDangerousActivitiesList.value = selectedValues;
                },
                initialValue: familyMedicalInsuranceController.selectDangerousActivitiesList,
              ),
            ],

            /*familyMedicalInsuranceController.selectedDangerousActivity == yesTxt
                ? CustomDropDownBorder1(
                    dropdownTitle: dangerousActivities,
                    onchage: (newValue) {
                      setState(() {
                        try {
                          GetDangerousActivitiesList cdl = familyMedicalInsuranceController.getDangerousActivitiesList.firstWhere((element) => element.id == newValue);
                          familyMedicalInsuranceController.selectDangerousActivitiesList.value = cdl;
                        } catch (e) {
                          print(e);
                        }
                        // profileController.selectNationality = newValue;
                      });
                    },
                    items: familyMedicalInsuranceController.getDangerousActivitiesList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: familyMedicalInsuranceController.getDangerousActivitiesList.any((element) => element.id == familyMedicalInsuranceController.selectDangerousActivitiesList.value.id) ? familyMedicalInsuranceController.selectDangerousActivitiesList.value.id ?? 0 : null,
                  )
                : const SizedBox(),*/
            const SizedBox(height: 10),
            /*familyMedicalInsuranceController.selectedDangerousActivity == noTxt
                ?*/
            Column(
              children: [
                familyMedicalInsuranceController.selectedIdFrontSide.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectIdFrontSideDocument();
                        },
                        child: ImageUploadWidget(txt: addIDFrontSidePassport, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingIdFrontSide.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: iDFrontSidePassportDocuments,
                        selectedDocumentsImg: familyMedicalInsuranceController.selectedIdFrontSide,
                        removeDocumentFunction: (index) {
                          removeIdFrontSideImage(familyMedicalInsuranceController.selectedIdFrontSide[index]);
                        },
                        addDocumentFunction: () {
                          selectIdFrontSideDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: familyMedicalInsuranceController.isLoadingIdFrontSide.value,
                      ),
                familyMedicalInsuranceController.selectedIdBackSide.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectIdBackSideDocument();
                        },
                        child: ImageUploadWidget(txt: addIDBackSidePassport, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingIdBackSide.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: iDBackSidePassportDocuments,
                        selectedDocumentsImg: familyMedicalInsuranceController.selectedIdBackSide,
                        removeDocumentFunction: (index) {
                          removeIdBackSideImage(familyMedicalInsuranceController.selectedIdBackSide[index]);
                        },
                        addDocumentFunction: () {
                          selectIdBackSideDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: familyMedicalInsuranceController.isLoadingIdBackSide.value,
                      ),
                familyMedicalInsuranceController.selectedFamilyBook.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectFamilyBookDocument();
                        },
                        child: ImageUploadWidget(txt: addFamilyBookPhotos, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingFamilyBook.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: familyBookDocuments,
                        selectedDocumentsImg: familyMedicalInsuranceController.selectedFamilyBook,
                        removeDocumentFunction: (index) {
                          removeFamilyBookImage(familyMedicalInsuranceController.selectedFamilyBook[index]);
                        },
                        addDocumentFunction: () {
                          selectFamilyBookDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: familyMedicalInsuranceController.isLoadingFamilyBook.value,
                      ),
                familyMedicalInsuranceController.selectedPersonalPic.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectPersonalPicDocument();
                        },
                        child: ImageUploadWidget(txt: addPersonalPicture, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingPersonalPic.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: personalPictureDocuments,
                        selectedDocumentsImg: familyMedicalInsuranceController.selectedPersonalPic,
                        removeDocumentFunction: (index) {
                          removePersonalPicImage(familyMedicalInsuranceController.selectedPersonalPic[index]);
                        },
                        addDocumentFunction: () {
                          selectPersonalPicDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: familyMedicalInsuranceController.isLoadingPersonalPic.value,
                      ),
                familyMedicalInsuranceController.selectedOtherMembers.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectOtherMembersDocument();
                        },
                        child: ImageUploadWidgetSubText(
                            txt: uploadInsuranceCardForOtherMembersInTheFamilyBookInsuredSomewhereElse,
                            subTxt: noOtherMemberInsurable,
                            borderColor: skyBlueShade2,
                            isLoading: familyMedicalInsuranceController.isLoadingOtherMembers.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: otherMemberDocuments,
                        selectedDocumentsImg: familyMedicalInsuranceController.selectedOtherMembers,
                        removeDocumentFunction: (index) {
                          removeOtherMembersImage(familyMedicalInsuranceController.selectedOtherMembers[index]);
                        },
                        addDocumentFunction: () {
                          selectOtherMembersDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: familyMedicalInsuranceController.isLoadingOtherMembers.value,
                      ),
                familyMedicalInsuranceController.selectedOtherDocuments.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectOtherDocument();
                        },
                        child: ImageUploadWidget(txt: uploadAnyOtherDocuments, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingOtherDocuments.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: otherDocuments,
                        selectedDocumentsImg: familyMedicalInsuranceController.selectedOtherDocuments,
                        removeDocumentFunction: (index) {
                          removeOtherDocumentsImage(familyMedicalInsuranceController.selectedOtherDocuments[index]);
                        },
                        addDocumentFunction: () {
                          selectOtherDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: familyMedicalInsuranceController.isLoadingOtherDocuments.value,
                      ),
              ],
            ),
            // : const SizedBox(),
            for (int i = 0; i < familyMedicalInsuranceController.memberFirstNameController.length; i++) AddMemberScreen(index: i),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  familyMedicalInsuranceController.memberFirstNameController.add(TextEditingController());
                  familyMedicalInsuranceController.memberSecondNameController.add(TextEditingController());
                  familyMedicalInsuranceController.memberThirdNameController.add(TextEditingController());
                  familyMedicalInsuranceController.memberFamilyNameController.add(TextEditingController());
                  familyMedicalInsuranceController.selectedMemberRelation.add(wife);
                  familyMedicalInsuranceController.selectNationalityMember.add(GetNationalityList());
                  familyMedicalInsuranceController.memberNationPassportNoController.add(TextEditingController());
                  familyMedicalInsuranceController.memberIdOrResidenceNoController.add(TextEditingController());
                  familyMedicalInsuranceController.memberBirthDateController.add(TextEditingController());
                  familyMedicalInsuranceController.selectMemberGender.add(male);
                  familyMedicalInsuranceController.memberSelectedMaritalStatus.add(single);
                  familyMedicalInsuranceController.selectOccupationMember.add(OccuptionList());
                  familyMedicalInsuranceController.memberHeightController.add(TextEditingController());
                  familyMedicalInsuranceController.memberWeightController.add(TextEditingController());
                  familyMedicalInsuranceController.selectMemberChronicDiseases.add(<GetChronicDiseasesList>[]);
                  familyMedicalInsuranceController.memberSelectedPreviousOperationsOption.add('');
                  familyMedicalInsuranceController.memberChronicOption.add('');
                  familyMedicalInsuranceController.memberPreviousOperationDetailsController.add(TextEditingController());
                  familyMedicalInsuranceController.memberSelectedPregnantOption.add('');
                  familyMedicalInsuranceController.memberSelectMonth.add(month1);
                  familyMedicalInsuranceController.memberSelectedDangerousActivity.add('');
                  familyMedicalInsuranceController.selectMemberDangerousActivity.add(GetDangerousActivitiesList());
                  familyMedicalInsuranceController.selectedIdFrontSideMember.add([]);
                  familyMedicalInsuranceController.selectedIdBackSideMember.add([]);
                  familyMedicalInsuranceController.selectedOtherDocumentsMember.add([]);
                  familyMedicalInsuranceController.selectedPersonalPicMember.add([]);
                  setState(() {});
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: AppText(
                    text: addAnotherMember,
                    fontWeight: FontWeight.bold,
                    size: 15,
                  )),
                ),
              ),
            ),
            familyMedicalInsuranceController.isShowHWValidationMsg.value || familyMedicalInsuranceController.isShowMessage.value
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppText(
                      text: sorryYourRequestTypeOfInsuranceCannotBeProcessedDueToTechnicalUnderwritingPleaseContactUsAnyClarification,
                      txtColor: Colors.red,
                      size: 14,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: AppBtnWithColorShades(
                      onTap: () {
                        if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAnyExistingMedicalInsurancePolicyOption, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt &&
                            familyMedicalInsuranceController.insuranceCompanyNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterInsuranceCompanyName, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt &&
                            familyMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == yesTxt && familyMedicalInsuranceController.selectedMedicalCard.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadYourMedicalCard, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == noTxt && familyMedicalInsuranceController.heightController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterHeight, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == noTxt && familyMedicalInsuranceController.weightController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterWeight, txtColor: primaryWhite, size: 12)));
                        }
                        /* else if (familyMedicalInsuranceController.selectedChronicDiseasesList == []) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                        }*/

                        else if (familyMedicalInsuranceController.selectedChronicDisease == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedChronicDisease == yesTxt && familyMedicalInsuranceController.selectedChronicDiseasesList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedPreviousOperationsOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAnyPreviousOperationsOption, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedPreviousOperationsOption == yesTxt &&
                            familyMedicalInsuranceController.detailsAboutPreviousOperationsController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPreviousOperationsDetails, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedGender == female &&
                            familyMedicalInsuranceController.selectedMaritalStatus == married &&
                            familyMedicalInsuranceController.selectedPregnantOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAreYouPregnantOption, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedGender == female &&
                            familyMedicalInsuranceController.selectedMaritalStatus == married &&
                            familyMedicalInsuranceController.selectedPregnantOption == "Yes" &&
                            familyMedicalInsuranceController.selectmonth == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMonth, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedDangerousActivity == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesOptions, txtColor: primaryWhite, size: 12)));
                        } else if (familyMedicalInsuranceController.selectedDangerousActivity == yesTxt && familyMedicalInsuranceController.selectDangerousActivitiesList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesList, txtColor: primaryWhite, size: 12)));
                        }
                        else if (/*familyMedicalInsuranceController.selectedDangerousActivity == noTxt &&*/ familyMedicalInsuranceController.selectedIdFrontSide.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadIdFrontSidePassport, txtColor: primaryWhite, size: 12)));
                        } else if (/*familyMedicalInsuranceController.selectedDangerousActivity == noTxt &&*/ familyMedicalInsuranceController.selectedIdBackSide.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadIdBackSidePassport, txtColor: primaryWhite, size: 12)));
                        } else if (/*familyMedicalInsuranceController.selectedDangerousActivity == noTxt &&*/ familyMedicalInsuranceController.selectedFamilyBook.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadFamilyBook, txtColor: primaryWhite, size: 12)));
                        } else if (/*familyMedicalInsuranceController.selectedDangerousActivity == noTxt && */ familyMedicalInsuranceController.selectedPersonalPic.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPersonalPicture, txtColor: primaryWhite, size: 12)));
                        }
                        /*else if (*/ /*familyMedicalInsuranceController.selectedDangerousActivity == noTxt &&*/ /* familyMedicalInsuranceController.selectedOtherMembers.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadInsuranceCardForOtherMembers, txtColor: primaryWhite, size: 12)));
                        } */ /*else if (*/ /*familyMedicalInsuranceController.selectedDangerousActivity == noTxt &&*/ /* familyMedicalInsuranceController.selectedOtherDocuments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadOtherDocuments, txtColor: primaryWhite, size: 12)));
                        }*/
                        else if (memberValidation()) {
                          print("objectobjectobjectobject");
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
        ),
      ),
    );
  }

  expiryDate() async {
    /*if (familyMedicalInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (familyMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null) {
        familyMedicalInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(familyMedicalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        // familyMedicalInsuranceController.initialDate.value = familyMedicalInsuranceController.initialDate.value.add(const Duration(days: 365));
      } else {
        familyMedicalInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      familyMedicalInsuranceController.initialDate.value = DateTime.now();
    }*/

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: familyMedicalInsuranceController.initialDate.value, //get today's date
      firstDate: familyMedicalInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dddd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      familyMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value.text = commonDateFormat(formattedDate);

      setState(() {});
    } else {
      print("Date is not selected");
    }
  }

  Future selectMedicalCardDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingMedicalCard.value = true;
    final pickedFile = await familyMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 7);
      familyMedicalInsuranceController.selectedMedicalCard.addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingMedicalCard.value = false;
    setState(() {});
  }

  void removeMedicalCardImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedMedicalCard.remove(item);
    }
    setState(() {});
  }

  Future selectIdFrontSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingIdFrontSide.value = true;
    final pickedFile = await familyMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 7);
      familyMedicalInsuranceController.selectedIdFrontSide.addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingIdFrontSide.value = false;
    setState(() {});
  }

  void removeIdFrontSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedIdFrontSide.remove(item);
    }
    setState(() {});
  }

  Future selectIdBackSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingIdBackSide.value = true;
    final pickedFile = await familyMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 7);
      familyMedicalInsuranceController.selectedIdBackSide.addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingIdBackSide.value = false;
    setState(() {});
  }

  void removeIdBackSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedIdBackSide.remove(item);
    }
    setState(() {});
  }

  Future selectFamilyBookDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingFamilyBook.value = true;
    final pickedFile = await familyMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 7);
      familyMedicalInsuranceController.selectedFamilyBook.addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingFamilyBook.value = false;
    setState(() {});
  }

  void removeFamilyBookImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedFamilyBook.remove(item);
    }
    setState(() {});
  }

  Future selectPersonalPicDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingPersonalPic.value = true;
    final pickedFile = await familyMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 7);
      familyMedicalInsuranceController.selectedPersonalPic.addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingPersonalPic.value = false;
    setState(() {});
  }

  void removePersonalPicImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedPersonalPic.remove(item);
    }
    setState(() {});
  }

  Future selectOtherMembersDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingOtherMembers.value = true;
    final pickedFile = await familyMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 7);
      familyMedicalInsuranceController.selectedOtherMembers.addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingOtherMembers.value = false;
    setState(() {});
  }

  void removeOtherMembersImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedOtherMembers.remove(item);
    }
    setState(() {});
  }

  Future selectOtherDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingOtherDocuments.value = true;
    final pickedFile = await familyMedicalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 7);
      familyMedicalInsuranceController.selectedOtherDocuments.addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingOtherDocuments.value = false;
    setState(() {});
  }

  void removeOtherDocumentsImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedOtherDocuments.remove(item);
    }
    setState(() {});
  }

  bool memberValidation() {
    // if (familyMedicalInsuranceController.addDetails.value != 0) {
    for (int i = 0; i < familyMedicalInsuranceController.memberFirstNameController.length; i++) {
      if (familyMedicalInsuranceController.memberFirstNameController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersFirstName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSecondNameController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersSecondName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberThirdNameController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersThirdName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberFamilyNameController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersFamilyName, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.selectedMemberRelation[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectRelation, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.selectNationalityMember[i].id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersNationality, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberNationPassportNoController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersNationalOrPassportNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberIdOrResidenceNoController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersIdOrResidenceNo, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberBirthDateController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersBirthDate, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.selectMemberGender[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersGender, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSelectedMaritalStatus[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersMaritalStatus, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.selectOccupationMember[i].id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersOccupancyTypeOfWork, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberHeightController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersHeight, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberWeightController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersWeight, txtColor: primaryWhite, size: 12)));
        return true;
      }
      else if (familyMedicalInsuranceController.memberChronicOption[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersChronicDiseases, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberChronicOption[i] == yesTxt &&
          (familyMedicalInsuranceController.selectMemberChronicDiseases[i] == null ||
           (familyMedicalInsuranceController.selectMemberChronicDiseases[i] is List && (familyMedicalInsuranceController.selectMemberChronicDiseases[i] as List).isEmpty))) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersChronicDiseases, txtColor: primaryWhite, size: 12)));
        return true;
      }
      else if (familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersPreviousOperationsOption, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[i] == yesTxt && familyMedicalInsuranceController.memberPreviousOperationDetailsController[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMembersPreviousOperationsDetails, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.selectMemberGender[i] == female &&
          familyMedicalInsuranceController.memberSelectedMaritalStatus[i] == married &&
          familyMedicalInsuranceController.memberSelectedPregnantOption[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersAreYouPregnantOption, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.selectMemberGender[i] == female &&
          familyMedicalInsuranceController.memberSelectedMaritalStatus[i] == married &&
          familyMedicalInsuranceController.memberSelectedPregnantOption[i] == yesTxt &&
          familyMedicalInsuranceController.memberSelectMonth[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersMonth, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSelectedDangerousActivity[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersDangerousActivitiesOptions, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == yesTxt && familyMedicalInsuranceController.selectMemberDangerousActivity[i].id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMembersDangerousActivitiesList, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == noTxt && familyMedicalInsuranceController.selectedIdFrontSideMember[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadMembersIdFrontSidePassport, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == noTxt && familyMedicalInsuranceController.selectedIdBackSideMember[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadMembersIdBackSidePassport, txtColor: primaryWhite, size: 12)));
        return true;
      } else if (familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == noTxt && familyMedicalInsuranceController.selectedPersonalPicMember[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadMembersPersonalPicture, txtColor: primaryWhite, size: 12)));
        return true;
      } /*else if (familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == noTxt && familyMedicalInsuranceController.selectedOtherDocumentsMember[i].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadMembersOtherDocuments, txtColor: primaryWhite, size: 12)));
        return true;
      }*/
    }
    // }
    return false;
  }
}
