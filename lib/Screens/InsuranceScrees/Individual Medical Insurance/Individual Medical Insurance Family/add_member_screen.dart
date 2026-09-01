import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/family_medical_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/new_upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

class AddMemberScreen extends StatefulWidget {
  int index;

  AddMemberScreen({super.key, required this.index});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  FamilyMedicalInsuranceController familyMedicalInsuranceController = Get.put(FamilyMedicalInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 20),
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: InkWell(
            onTap: () {
              familyMedicalInsuranceController.memberFirstNameController.removeAt(widget.index);
              familyMedicalInsuranceController.memberSecondNameController.removeAt(widget.index);
              familyMedicalInsuranceController.memberThirdNameController.removeAt(widget.index);
              familyMedicalInsuranceController.memberFamilyNameController.removeAt(widget.index);
              familyMedicalInsuranceController.selectedMemberRelation.removeAt(widget.index);
              familyMedicalInsuranceController.selectNationalityMember.removeAt(widget.index);
              familyMedicalInsuranceController.memberNationPassportNoController.removeAt(widget.index);
              familyMedicalInsuranceController.memberIdOrResidenceNoController.removeAt(widget.index);
              familyMedicalInsuranceController.memberBirthDateController.removeAt(widget.index);
              familyMedicalInsuranceController.selectMemberGender.removeAt(widget.index);
              familyMedicalInsuranceController.memberSelectedMaritalStatus.removeAt(widget.index);
              familyMedicalInsuranceController.selectOccupationMember.removeAt(widget.index);
              familyMedicalInsuranceController.memberHeightController.removeAt(widget.index);
              familyMedicalInsuranceController.memberWeightController.removeAt(widget.index);
              familyMedicalInsuranceController.selectMemberChronicDiseases.removeAt(widget.index);
              familyMedicalInsuranceController.memberSelectedPreviousOperationsOption.removeAt(widget.index);
              familyMedicalInsuranceController.memberChronicOption.removeAt(widget.index);
              familyMedicalInsuranceController.memberPreviousOperationDetailsController.removeAt(widget.index);
              familyMedicalInsuranceController.memberSelectedPregnantOption.removeAt(widget.index);
              familyMedicalInsuranceController.memberSelectMonth.removeAt(widget.index);
              familyMedicalInsuranceController.memberSelectedDangerousActivity.removeAt(widget.index);
              familyMedicalInsuranceController.selectMemberDangerousActivity.removeAt(widget.index);
              familyMedicalInsuranceController.selectedIdFrontSideMember.removeAt(widget.index);
              familyMedicalInsuranceController.selectedIdBackSideMember.removeAt(widget.index);
              familyMedicalInsuranceController.selectedOtherDocumentsMember.removeAt(widget.index);
              familyMedicalInsuranceController.selectedPersonalPicMember.removeAt(widget.index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: skyBlueShade1), borderRadius: BorderRadius.all(Radius.circular(10))),
              child: const Icon(Icons.remove_outlined, color: skyBlueShade1),
            ),
          ),
        ),
        AppText(
          text: "${getTranslated(context, member)} ${widget.index + 1} ${getTranslated(context, detail)}",
          size: 16,
          fontWeight: FontWeight.bold,
          txtAlign: TextAlign.start,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: memberFirstName, lable: memberFirstName, controller: familyMedicalInsuranceController.memberFirstNameController[widget.index]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: memberSecondName, lable: memberSecondName, controller: familyMedicalInsuranceController.memberSecondNameController[widget.index]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: memberThirdName, lable: memberThirdName, controller: familyMedicalInsuranceController.memberThirdNameController[widget.index]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: memberFamilyName, lable: memberFamilyName, controller: familyMedicalInsuranceController.memberFamilyNameController[widget.index]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDropDownBorder(
            onchage: (newValue) {
              familyMedicalInsuranceController.selectedMemberRelation[widget.index] = newValue!;
              setState(() {});
            },
            items: const [wife, husband, son, daughter],
            selectedValue: familyMedicalInsuranceController.selectedMemberRelation[widget.index],
            dropdownTitle: selectrelation,
          ),
        ),
        CustomDropDownBorder1(
          dropdownTitle: selectNationality,
          onchage: (newValue) {
            setState(() {
              try {
                GetNationalityList cdl = familyMedicalInsuranceController.getNationalityList.firstWhere((element) => element.id == newValue);
                familyMedicalInsuranceController.selectNationalityMember[widget.index] = cdl;
              } catch (e) {
                print(e);
              }
              // profileController.selectNationality = newValue;
            });
          },
          items: familyMedicalInsuranceController.getNationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
          selectedValue: familyMedicalInsuranceController.getNationalityList.any((element) => element.id == familyMedicalInsuranceController.selectNationalityMember[widget.index].id) ? familyMedicalInsuranceController.selectNationalityMember[widget.index].id ?? 0 : null,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: nationalnopassport, lable: nationalnopassport, controller: familyMedicalInsuranceController.memberNationPassportNoController[widget.index]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: residenceno, lable: residenceno, controller: familyMedicalInsuranceController.memberIdOrResidenceNoController[widget.index]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(
              width: 10,
              controller: familyMedicalInsuranceController.memberBirthDateController[widget.index],
              hint: birthdate,
              lable: birthdate,
              readOnly: true,
              ontap: () {
                startDateDialog();
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                familyMedicalInsuranceController.selectMemberGender[widget.index] = newValue!;
              });
            },
            items: const [male, female],
            selectedValue: familyMedicalInsuranceController.selectMemberGender[widget.index],
            dropdownTitle: selectgender,
          ),
        ),
        if(familyMedicalInsuranceController.selectMemberGender[widget.index] == female)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: indiq3, size: 15),
            Row(
              children: <Widget>[
                Radio(
                  value: yesTxt,
                  groupValue: familyMedicalInsuranceController.selectedPregnantOptionMember,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedPregnantOptionMember = value!;
                    });
                  },
                ),
                AppText(text: yesTxt, size: 14),
                Radio(
                  value: noTxt,
                  groupValue: familyMedicalInsuranceController.selectedPregnantOptionMember,
                  onChanged: (value) {
                    setState(() {
                      familyMedicalInsuranceController.selectedPregnantOptionMember = value!;
                    });
                  },
                ),
                AppText(text: noTxt, size: 14),
              ],
            ),
            if (familyMedicalInsuranceController.selectedPregnantOptionMember == yesTxt) ...[
              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    familyMedicalInsuranceController.selectmonthMember = newValue!;
                  });
                },
                items: const [month1, month2, month3, month4, month5, month6, month7, month8, month9],
                selectedValue: familyMedicalInsuranceController.selectmonthMember,
                dropdownTitle: indiq4,
              )
            ],
            const SizedBox(height: 8),
            familyMedicalInsuranceController.selectedPregnantOptionMember == yesTxt
                ? AppText(
              text: pleaseNoteThatThePregnancyCaseWillNotBeCovered,
              txtColor: Colors.red,
              size: 14,
            )
                : const SizedBox(),
            const SizedBox(height: 12),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDropDownBorder(
            onchage: (newValue) {
              setState(() {
                familyMedicalInsuranceController.memberSelectedMaritalStatus[widget.index] = newValue!;
              });
            },
            items: const [single, married, divorced, widowed],
            selectedValue: familyMedicalInsuranceController.memberSelectedMaritalStatus[widget.index],
            dropdownTitle: "$select $mrgstatus",
          ),
        ),
        CustomDropDownBorder1(
          onchage: (newValue) {
            setState(() {
              OccuptionList cdl = familyMedicalInsuranceController.occupationListMember.firstWhere((element) => element.id == newValue);
              familyMedicalInsuranceController.selectOccupationMember[widget.index] = cdl;
            });
          },
          items: familyMedicalInsuranceController.occupationListMember.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
          selectedValue: familyMedicalInsuranceController.occupationListMember.any((element) => element.id == familyMedicalInsuranceController.selectOccupationMember[widget.index].id) ? familyMedicalInsuranceController.selectOccupationMember[widget.index].id ?? 0 : null,
          dropdownTitle: occupancy,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: AppTextfield(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                hint: height,
                lable: height,
                controller: familyMedicalInsuranceController.memberHeightController[widget.index],
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: AppTextfield(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                hint: weight,
                lable: weight,
                controller: familyMedicalInsuranceController.memberWeightController[widget.index],
              )),
            ],
          ),
        ),

        AppText(text: doYouAnyChronicDisease, size: 15, txtAlign: TextAlign.start),

        Row(
          children: <Widget>[
            Radio(
              value: yesTxt,
              groupValue: familyMedicalInsuranceController.memberChronicOption[widget.index],
              onChanged: (value) {
                setState(() {
                  familyMedicalInsuranceController.memberChronicOption[widget.index] = value!;
                });
              },
            ),
            AppText(text: yesTxt, size: 14),
            Radio(
              value: noTxt,
              groupValue: familyMedicalInsuranceController.memberChronicOption[widget.index],
              onChanged: (value) {
                setState(() {
                  familyMedicalInsuranceController.memberChronicOption[widget.index] = value!;
                  familyMedicalInsuranceController.selectMemberChronicDiseases[widget.index] = <GetChronicDiseasesList>[];
                  familyMedicalInsuranceController.selectMemberChronicDiseases.refresh();
                });
              },
            ),
            AppText(text: noTxt, size: 14),
          ],
        ),
        if (familyMedicalInsuranceController.memberChronicOption[widget.index] == yesTxt)MultiSelectDialogField<GetChronicDiseasesList>(
          items: familyMedicalInsuranceController.getChronicDiseasesListMember
              .map((e) => MultiSelectItem<GetChronicDiseasesList>(e, getTranslated(context, e.name ?? '')))
              .toList(),
          title: Text(getTranslated(context, selectchodiseases)),
          confirmText: Text(getTranslated(context, "OK"), style: const TextStyle(color: blueShade1)),
          cancelText: Text(getTranslated(context, "CANCEL"), style: const TextStyle(color: blueShade1)),
          selectedColor: blueShade1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: skyBlueShade1),
          ),
          buttonIcon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.black,
          ),

          buttonText: Text(
            getTranslated(context, selectchodiseases),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          onConfirm: (List<GetChronicDiseasesList> selectedValues) {
            setState(() {
              familyMedicalInsuranceController.selectMemberChronicDiseases[widget.index] = selectedValues;
              familyMedicalInsuranceController.selectMemberChronicDiseases.refresh();
            });
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              setState(() {
                (familyMedicalInsuranceController.selectMemberChronicDiseases[widget.index] as List).remove(value);
                familyMedicalInsuranceController.selectMemberChronicDiseases.refresh();
              });
            },
          ),
          initialValue: familyMedicalInsuranceController.selectMemberChronicDiseases[widget.index],
        ),

      /*  CustomDropDownBorder1(
          dropdownTitle: selectchodiseases,
          onchage: (newValue) {
            setState(() {
              try {
                GetChronicDiseasesList cdl = familyMedicalInsuranceController.getChronicDiseasesListMember.firstWhere((element) => element.id == newValue);
                familyMedicalInsuranceController.selectMemberChronicDiseases[widget.index] = cdl;
              } catch (e) {
                print(e);
              }
            });
          },
          items: familyMedicalInsuranceController.getChronicDiseasesListMember.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
          selectedValue: familyMedicalInsuranceController.getChronicDiseasesListMember.any((element) => element.id == familyMedicalInsuranceController.selectMemberChronicDiseases[widget.index].id) ? familyMedicalInsuranceController.selectMemberChronicDiseases[widget.index].id ?? 0 : null,
        ),*/
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(alignment: Alignment.topLeft, child: AppText(text: indiq2, size: 15)),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[widget.index],
                        onChanged: (value) {
                          setState(() {
                            familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[widget.index] = value!;
                          });
                        },
                      ),
                      AppText(text: yesTxt, size: 14),
                      Radio(
                        value: noTxt,
                        groupValue: familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[widget.index],
                        onChanged: (value) {
                          setState(() {
                            familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[widget.index] = value!;
                          });
                        },
                      ),
                      AppText(text: noTxt, size: 14),
                    ],
                  ),
                ],
              ),
              if (familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[widget.index] == yesTxt)
                AppTextfield(
                  hint: indiqnote,
                  lable: indiqnote,
                  controller: familyMedicalInsuranceController.memberPreviousOperationDetailsController[widget.index],
                ),
              const SizedBox(height: 20),
              if (familyMedicalInsuranceController.selectMemberGender[widget.index] == female && familyMedicalInsuranceController.memberSelectedMaritalStatus[widget.index] == married)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: indiq3, size: 15),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: familyMedicalInsuranceController.memberSelectedPregnantOption[widget.index],
                          onChanged: (value) {
                            setState(() {
                              familyMedicalInsuranceController.memberSelectedPregnantOption[widget.index] = value!;
                            });
                          },
                        ),
                        AppText(text: yesTxt, size: 14),
                        Radio(
                          value: noTxt,
                          groupValue: familyMedicalInsuranceController.memberSelectedPregnantOption[widget.index],
                          onChanged: (value) {
                            setState(() {
                              familyMedicalInsuranceController.memberSelectedPregnantOption[widget.index] = value!;
                            });
                          },
                        ),
                        AppText(text: noTxt, size: 14),
                      ],
                    ),
                    if (familyMedicalInsuranceController.memberSelectedPregnantOption[widget.index] == yesTxt) ...[
                      AppText(text: indiq4, size: 15),
                      const SizedBox(height: 8),
                      DropdownButtonFormField(
                        value: familyMedicalInsuranceController.memberSelectMonth[widget.index],
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        hint: const Text(month1),
                        onChanged: (newValue) {
                          setState(() {
                            familyMedicalInsuranceController.memberSelectMonth[widget.index] = newValue!;
                          });
                        },
                        items: [month1, month2, month3, month4, month5, month6, month7, month8, month9]
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                      ),
                    ],
                    familyMedicalInsuranceController.memberSelectedPregnantOption[widget.index] == yesTxt
                        ? AppText(
                            text: pleaseNoteThatThePregnancyCaseWillNotBeCovered,
                            txtColor: Colors.red,
                            size: 14,
                          )
                        : const SizedBox(),
                  ],
                ),
              const SizedBox(
                height: 12,
              ),
              AppText(text: anyDangerousActivities, size: 15),
              Row(
                children: <Widget>[
                  Radio(
                    value: yesTxt,
                    groupValue: familyMedicalInsuranceController.memberSelectedDangerousActivity[widget.index],
                    onChanged: (value) {
                      setState(() {
                        familyMedicalInsuranceController.memberSelectedDangerousActivity[widget.index] = value!;
                        familyMedicalInsuranceController.showMessage();
                      });
                    },
                  ),
                  AppText(text: yesTxt, size: 14),
                  Radio(
                    value: noTxt,
                    groupValue: familyMedicalInsuranceController.memberSelectedDangerousActivity[widget.index],
                    onChanged: (value) {
                      setState(() {
                        familyMedicalInsuranceController.memberSelectedDangerousActivity[widget.index] = value!;
                        familyMedicalInsuranceController.showMessage();
                      });
                    },
                  ),
                  AppText(text: noTxt, size: 14),
                ],
              ),
              familyMedicalInsuranceController.memberSelectedDangerousActivity[widget.index] == yesTxt
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: AppText(text: dangerousActivities, size: 14),
                          ),
                        ),
                        CustomDropDownBorder1(
                          dropdownTitle: dangerousActivities,
                          onchage: (newValue) {
                            setState(() {
                              try {
                                GetDangerousActivitiesList cdl = familyMedicalInsuranceController.getDangerousActivitiesMemberList.firstWhere((element) => element.id == newValue);
                                familyMedicalInsuranceController.selectMemberDangerousActivity[widget.index] = cdl;
                              } catch (e) {
                                print(e);
                              }
                              // profileController.selectNationality = newValue;
                            });
                          },
                          items: familyMedicalInsuranceController.getDangerousActivitiesMemberList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: familyMedicalInsuranceController.getDangerousActivitiesMemberList.any((element) => element.id == familyMedicalInsuranceController.selectMemberDangerousActivity[widget.index].id)
                              ? familyMedicalInsuranceController.selectMemberDangerousActivity[widget.index].id ?? 0
                              : null,
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              /*familyMedicalInsuranceController.memberSelectedDangerousActivity[widget.index] == 'Yes'
                  ? AppText(
                      text: sorryYourRequestTypeOfInsuranceCannotBeProcessedDueToTechnicalUnderwritingPleaseContactUsAnyClarification,
                      txtColor: Colors.red,
                      size: 14,
                    )
                  : const SizedBox(),*/
              familyMedicalInsuranceController.memberSelectedDangerousActivity[widget.index] == noTxt
                  ? Column(
                      children: [
                        familyMedicalInsuranceController.selectedIdFrontSideMember[widget.index].isEmpty
                            ? InkWell(
                                onTap: () {
                                  selectIdFrontSideDocument();
                                },
                                child: ImageUploadWidget(txt: addIDFrontSidePassport, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingIdFrontSideMember.value))
                            : NewUploadDocumentsCommonScreen(
                                documentNameText: iDFrontSidePassportDocuments,
                                selectedDocumentsImg: familyMedicalInsuranceController.selectedIdFrontSideMember[widget.index],
                                removeDocumentFunction: (index) {
                                  removeIdFrontSideImage(familyMedicalInsuranceController.selectedIdFrontSideMember[widget.index][index]);
                                },
                                addDocumentFunction: () {
                                  selectIdFrontSideDocument();
                                },
                                addDocText: addDocuments,
                                isLoading: familyMedicalInsuranceController.isLoadingIdFrontSideMember.value,
                              ),
                        familyMedicalInsuranceController.selectedIdBackSideMember[widget.index].isEmpty
                            ? InkWell(
                                onTap: () {
                                  selectIdBackSideDocument();
                                },
                                child: ImageUploadWidget(txt: addIDBackSidePassport, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingIdBackSideMember.value))
                            : NewUploadDocumentsCommonScreen(
                                documentNameText: iDBackSidePassportDocuments,
                                selectedDocumentsImg: familyMedicalInsuranceController.selectedIdBackSideMember[widget.index],
                                removeDocumentFunction: (index) {
                                  removeIdBackSideImage(familyMedicalInsuranceController.selectedIdBackSideMember[widget.index][index]);
                                },
                                addDocumentFunction: () {
                                  selectIdBackSideDocument();
                                },
                                addDocText: addDocuments,
                                isLoading: familyMedicalInsuranceController.isLoadingIdBackSideMember.value,
                              ),
                        familyMedicalInsuranceController.selectedPersonalPicMember[widget.index].isEmpty
                            ? InkWell(
                                onTap: () {
                                  selectPersonalPicDocument();
                                },
                                child: ImageUploadWidget(txt: addPersonalPicture, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingPersonalPicMember.value))
                            : NewUploadDocumentsCommonScreen(
                                documentNameText: personalPictureDocuments,
                                selectedDocumentsImg: familyMedicalInsuranceController.selectedPersonalPicMember[widget.index],
                                removeDocumentFunction: (index) {
                                  removePersonalPicImage(familyMedicalInsuranceController.selectedPersonalPicMember[widget.index][index]);
                                },
                                addDocumentFunction: () {
                                  selectPersonalPicDocument();
                                },
                                addDocText: addDocuments,
                                isLoading: familyMedicalInsuranceController.isLoadingPersonalPicMember.value,
                              ),
                        familyMedicalInsuranceController.selectedOtherDocumentsMember[widget.index].isEmpty
                            ? InkWell(
                                onTap: () {
                                  selectOtherDocumentsDocument();
                                },
                                child: ImageUploadWidget(txt: addOtherDocuments, borderColor: skyBlueShade2, isLoading: familyMedicalInsuranceController.isLoadingOtherDocumentsMember.value))
                            : NewUploadDocumentsCommonScreen(
                                documentNameText: otherDocuments,
                                selectedDocumentsImg: familyMedicalInsuranceController.selectedOtherDocumentsMember[widget.index],
                                removeDocumentFunction: (index) {
                                  removeOtherDocumentsImage(familyMedicalInsuranceController.selectedOtherDocumentsMember[widget.index][index]);
                                },
                                addDocumentFunction: () {
                                  selectOtherDocumentsDocument();
                                },
                                addDocText: addDocuments,
                                isLoading: familyMedicalInsuranceController.isLoadingOtherDocumentsMember.value,
                              ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        )
      ],
    );
  }

  startDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(1901), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      familyMedicalInsuranceController.memberBirthDateController[widget.index].text = commonDateFormat(formattedDate);
      setState(() {});
    } else {
      print("Date is not selected");
    }
  }

  Future selectIdFrontSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingIdFrontSideMember.value = true;
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
      familyMedicalInsuranceController.selectedIdFrontSideMember[widget.index].addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingIdFrontSideMember.value = false;
    setState(() {});
  }

  void removeIdFrontSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedIdFrontSideMember[widget.index].remove(item);
    }
    setState(() {});
  }

  Future selectIdBackSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingIdBackSideMember.value = true;
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
      familyMedicalInsuranceController.selectedIdBackSideMember[widget.index].addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingIdBackSideMember.value = false;
    setState(() {});
  }

  void removeIdBackSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedIdBackSideMember[widget.index].remove(item);
    }
    setState(() {});
  }

  Future selectOtherDocumentsDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingOtherDocumentsMember.value = true;
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
      familyMedicalInsuranceController.selectedOtherDocumentsMember[widget.index].addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingOtherDocumentsMember.value = false;
    setState(() {});
  }

  void removeOtherDocumentsImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedOtherDocumentsMember[widget.index].remove(item);
    }
    setState(() {});
  }

  Future selectPersonalPicDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    familyMedicalInsuranceController.isLoadingPersonalPicMember.value = true;
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
      familyMedicalInsuranceController.selectedPersonalPicMember[widget.index].addAll(imagesUrl);
    }
    familyMedicalInsuranceController.isLoadingPersonalPicMember.value = false;
    setState(() {});
  }

  void removePersonalPicImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      familyMedicalInsuranceController.selectedPersonalPicMember[widget.index].remove(item);
    }
    setState(() {});
  }
}
