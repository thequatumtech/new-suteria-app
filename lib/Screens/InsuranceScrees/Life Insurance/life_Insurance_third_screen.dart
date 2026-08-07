import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Life%20Insurance/life_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/new_upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';
import 'package:soperia_user/app_utils/utils.dart';
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';
import 'package:soperia_user/model_class/get_insurance_period_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

import 'insurance_perioad_years_model.dart';

class LifeInsuranceThirdScreen extends StatefulWidget {
  Function onNext;

  LifeInsuranceThirdScreen({super.key, required this.onNext});

  @override
  State<LifeInsuranceThirdScreen> createState() => _LifeInsuranceThirdScreenState();
}

class _LifeInsuranceThirdScreenState extends State<LifeInsuranceThirdScreen> {
  LifeInsuranceController lifeInsuranceController = Get.put(LifeInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    lifeInsuranceController.getInsuranceLimit(context, '3');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return lifeInsuranceController.isLoading.value
          ? const Padding(
              padding: EdgeInsets.only(top: 140),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: heightcm, size: 12),
                                const SizedBox(height: 8),
                                SizedBox(
                                    width: 120,
                                    child: AppTextfield(
                                      onChange: () {
                                        lifeInsuranceController.isShowHWValidationMsg.value =
                                            Utils.heightWeightValidation(height: lifeInsuranceController.heightController.value.text, weight: lifeInsuranceController.weightController.value.text);
                                      },
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                      hint: height,
                                      lable: height,
                                      controller: lifeInsuranceController.heightController.value,
                                    )),
                              ],
                            ),
                            const SizedBox(width: 60),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: weightkg, size: 12),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 120,
                                  child: AppTextfield(
                                      onChange: () {
                                        lifeInsuranceController.isShowHWValidationMsg.value =
                                            Utils.heightWeightValidation(height: lifeInsuranceController.heightController.value.text, weight: lifeInsuranceController.weightController.value.text);
                                      },
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                      hint: weight,
                                      lable: weight,
                                      controller: lifeInsuranceController.weightController.value),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /* Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomDropDownBorder1(
                      dropdownTitle: selectchodiseases,
                      onchage: (newValue) {
                        setState(() {
                          try {
                            GetChronicDiseasesList cdl = lifeInsuranceController.getChronicDiseasesList.firstWhere((element) => element.id == newValue);
                            lifeInsuranceController.selectChronicDiseases.value = cdl;
                          } catch (e) {
                            print(e);
                          }
                          // profileController.selectNationality = newValue;
                        });
                      },
                      items: lifeInsuranceController.getChronicDiseasesList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                      selectedValue: lifeInsuranceController.getChronicDiseasesList.any((element) => element.id == lifeInsuranceController.selectChronicDiseases.value.id) ? lifeInsuranceController.selectChronicDiseases.value.id ?? 0 : null,
                    ),
                  ),*/

                  const SizedBox(height: 20),
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
                        groupValue: lifeInsuranceController.selectedChronicDisease,
                        onChanged: (value) {
                          setState(() {
                            lifeInsuranceController.selectedChronicDisease = value!;
                          });
                        },
                      ),
                      const Text(yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: lifeInsuranceController.selectedChronicDisease,
                        onChanged: (value) {
                          setState(() {
                            lifeInsuranceController.selectedChronicDisease = value!;
                            lifeInsuranceController.selectedChronicDiseasesList.value = [];
                          });
                        },
                      ),
                      const Text(noTxt),
                    ],
                  ),
                  if (lifeInsuranceController.selectedChronicDisease != null && lifeInsuranceController.selectedChronicDisease == yesTxt) ...[
                    MultiSelectDialogField<GetChronicDiseasesList>(
                      items: lifeInsuranceController.getChronicDiseasesList.map((e) => MultiSelectItem<GetChronicDiseasesList>(e, e.name ?? '')).toList(),
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
                          lifeInsuranceController.selectedChronicDiseasesList.value = selectedValues;
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            lifeInsuranceController.selectedChronicDiseasesList.remove(value);
                          });
                        },
                      ),
                      initialValue: lifeInsuranceController.selectedChronicDiseasesList.value,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 8),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.topLeft, child: AppText(text: indiq2, size: 15)),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: yesTxt,
                              groupValue: lifeInsuranceController.selectedAnyOperation,
                              onChanged: (value) {
                                setState(() {
                                  lifeInsuranceController.selectedAnyOperation = value!;
                                });
                              },
                            ),
                            const Text(yesTxt),
                            Radio(
                              value: noTxt,
                              groupValue: lifeInsuranceController.selectedAnyOperation,
                              onChanged: (value) {
                                setState(() {
                                  lifeInsuranceController.selectedAnyOperation = value!;
                                });
                              },
                            ),
                            const Text(noTxt),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (lifeInsuranceController.selectedAnyOperation == yesTxt)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                      child: AppTextfield(controller: lifeInsuranceController.previousOperationDetailsController.value, hint: indiqnote, lable: indiqnote),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.topLeft, child: AppText(text: lifeq3, size: 15)),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: yesTxt,
                              groupValue: lifeInsuranceController.selectedDescline,
                              onChanged: (value) {
                                setState(() {
                                  lifeInsuranceController.selectedDescline = value!;
                                });
                              },
                            ),
                            const Text(yesTxt),
                            Radio(
                              value: noTxt,
                              groupValue: lifeInsuranceController.selectedDescline,
                              onChanged: (value) {
                                setState(() {
                                  lifeInsuranceController.selectedDescline = value!;
                                });
                              },
                            ),
                            const Text(noTxt),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (lifeInsuranceController.selectedDescline == yesTxt)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                      child: AppTextfield(controller: lifeInsuranceController.companyDeclinedIssueController.value, maxLine: 2, hint: lifeqnote1, lable: lifeqnote1),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.topLeft, child: AppText(text: lifeq4, size: 15)),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: yesTxt,
                              groupValue: lifeInsuranceController.selectedNowAnyPolicy,
                              onChanged: (value) {
                                setState(() {
                                  lifeInsuranceController.selectedNowAnyPolicy = value!;
                                });
                              },
                            ),
                            const Text(yesTxt),
                            Radio(
                              value: noTxt,
                              groupValue: lifeInsuranceController.selectedNowAnyPolicy,
                              onChanged: (value) {
                                setState(() {
                                  lifeInsuranceController.selectedNowAnyPolicy = value!;
                                });
                              },
                            ),
                            const Text(noTxt),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (lifeInsuranceController.selectedNowAnyPolicy == yesTxt)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: AppTextfield(controller: lifeInsuranceController.existingLifeInsuranceController.value, maxLine: 2, hint: lifeqnote1, lable: lifeqnote1),
                    ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              InsuranceLimitListData cdl = lifeInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                              lifeInsuranceController.selectedInsuranceLimit.value = cdl;
                            });
                          },
                          items: lifeInsuranceController.insuranceLimitList
                              .map((e) => e.limit)
                              .where((e) => e != null && e!.trim().isNotEmpty)
                              .toSet() // remove duplicate planName
                              .map((name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(name!, style: const TextStyle(fontSize: 15, color: primaryBlack)),
                                  ))
                              .toList(),
                          /* items: lifeInsuranceController.insuranceLimitList.map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        */
                          selectedValue: lifeInsuranceController.insuranceLimitList.any((element) => element.limit == lifeInsuranceController.selectedInsuranceLimit.value.limit)
                              ? lifeInsuranceController.selectedInsuranceLimit.value.limit ?? 0
                              : null,
                          dropdownTitle: insuranceLimitCoverageAmount,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: AppTextfield(
                          width: 10,
                          hint: effectiveDate,
                          lable: effectiveDate,
                          readOnly: true,
                          controller: lifeInsuranceController.effectiveDateController.value,
                          ontap: () {
                            effectiveDateDialog();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Obx(() => CustomDropDownBorder1(
                              onchage: (newValue) {
                                InsurancePeriodModel cdl = lifeInsuranceController.insurancePeriodList.firstWhere((element) => element.id == newValue);
                                lifeInsuranceController.selectInsurancePeriod.value = cdl;
                              },
                              items: lifeInsuranceController.insurancePeriodList
                                  .map((item) => DropdownMenuItem(
                                        value: item.id ?? 0,
                                        child: Text(
                                          item.name ?? '',
                                          style: const TextStyle(fontSize: 15, color: primaryBlack),
                                        ),
                                      ))
                                  .toList(),
                              selectedValue: lifeInsuranceController.insurancePeriodList.any((element) => element.id == lifeInsuranceController.selectInsurancePeriod.value?.id)
                                  ? lifeInsuranceController.selectInsurancePeriod.value?.id ?? 0
                                  : null,
                              dropdownTitle: '$selectYour $insurancePeriod',
                            )),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.topLeft,
                        child: AppText(
                          text: uploaddocument,
                          size: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(uploadlogo, height: 28, width: 28),
                          const SizedBox(width: 8),
                          AppText(text: uploadPhotosUpTo20, size: 16),
                        ],
                      ),
                      lifeInsuranceController.photoDoc.isEmpty
                          ? InkWell(
                              onTap: () {
                                selectPhotosDocument();
                              },
                              child: ImageUploadWidget(txt: iDPassportCopy, borderColor: skyBlueShade2, isLoading: lifeInsuranceController.isLoadingPhotoDoc.value))
                          : NewUploadDocumentsCommonScreen(
                              documentNameText: iDPassportCopy,
                              selectedDocumentsImg: lifeInsuranceController.photoDoc,
                              removeDocumentFunction: (index) {
                                removePhotosImage(lifeInsuranceController.photoDoc[index]);
                              },
                              addDocumentFunction: () {
                                selectPhotosDocument();
                              },
                              addDocText: addDocuments,
                              isLoading: lifeInsuranceController.isLoadingPhotoDoc.value,
                            ),
                      lifeInsuranceController.familyBookDoc.isEmpty
                          ? InkWell(
                              onTap: () {
                                selectFamilyDocument();
                              },
                              child: ImageUploadWidget(txt: recentPersonalPicture, borderColor: skyBlueShade2, isLoading: lifeInsuranceController.isLoadingFamilyBookDoc.value))
                          : NewUploadDocumentsCommonScreen(
                              documentNameText: recentPersonalPicture,
                              selectedDocumentsImg: lifeInsuranceController.familyBookDoc,
                              removeDocumentFunction: (index) {
                                removeFamilyImage(lifeInsuranceController.familyBookDoc[index]);
                              },
                              addDocumentFunction: () {
                                selectFamilyDocument();
                              },
                              addDocText: addDocuments,
                              isLoading: lifeInsuranceController.isLoadingFamilyBookDoc.value,
                            ),
                      lifeInsuranceController.insuredDoc.isEmpty
                          ? InkWell(
                              onTap: () {
                                selectInsuranceDocument();
                              },
                              child: ImageUploadWidget(txt: medicalReportsAvailable, borderColor: skyBlueShade2, isLoading: lifeInsuranceController.isLoadingInsuredDoc.value))
                          : NewUploadDocumentsCommonScreen(
                              documentNameText: medicalReportsAvailable,
                              selectedDocumentsImg: lifeInsuranceController.insuredDoc,
                              removeDocumentFunction: (index) {
                                removeInsuranceImage(lifeInsuranceController.insuredDoc[index]);
                              },
                              addDocumentFunction: () {
                                selectInsuranceDocument();
                              },
                              addDocText: addDocuments,
                              isLoading: lifeInsuranceController.isLoadingInsuredDoc.value,
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: lifeInsuranceController.isShowHWValidationMsg.value
                        ? lifeInsuranceController.weightController.value.text.isEmpty
                            ? AppText(
                                text: plsFillWeight,
                                txtColor: Colors.red,
                                size: 14,
                              )
                            : AppText(
                                text: sorryYourRequestTypeOfInsuranceCannotBeProcessedDueToTechnicalUnderwritingPleaseContactUsAnyClarification,
                                txtColor: Colors.red,
                                size: 14,
                              )
                        : AppBtnWithColorShades(
                            onTap: () {
                              if (lifeInsuranceController.heightController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterHeight, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.weightController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterWeight, txtColor: primaryWhite, size: 12)));
                              } else if ((lifeInsuranceController.selectedChronicDisease ?? '').isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.selectedChronicDisease == yesTxt && lifeInsuranceController.selectedChronicDiseasesList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectChronicDiseases, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.selectedAnyOperation == '') {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectPreviousOperationsOption, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.selectedAnyOperation == yesTxt && lifeInsuranceController.previousOperationDetailsController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPreviousOperationDetails, txtColor: primaryWhite, size: 12)));
                              } else if (/*lifeInsuranceController.selectedAnyOperation == 'No' &&*/ lifeInsuranceController.selectedDescline == '') {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCompanyDeclinedIssueOption, txtColor: primaryWhite, size: 12)));
                              } else if (/*lifeInsuranceController.selectedAnyOperation == 'No' &&*/ lifeInsuranceController.selectedDescline == yesTxt &&
                                  lifeInsuranceController.companyDeclinedIssueController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCompanyDeclinedIssuesDetails, txtColor: primaryWhite, size: 12)));
                              } else if (/*lifeInsuranceController.selectedAnyOperation == 'No' && lifeInsuranceController.selectedDescline == 'No' && */ lifeInsuranceController
                                      .selectedNowAnyPolicy ==
                                  '') {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExistingLifeInsuranceOption, txtColor: primaryWhite, size: 12)));
                              } else if (/*lifeInsuranceController.selectedAnyOperation == 'No' && lifeInsuranceController.selectedDescline == 'No' && */ lifeInsuranceController
                                          .selectedNowAnyPolicy ==
                                      yesTxt &&
                                  lifeInsuranceController.existingLifeInsuranceController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterExistingLifeInsuranceDetails, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.selectedInsuranceLimit.value.limit == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceLimitCoverageAmount, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.effectiveDateController.value.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEffectiveDate, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.selectInsurancePeriod.value?.id == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsurancePeriod1, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.photoDoc.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadFrontAndBackSideOfPassport, txtColor: primaryWhite, size: 12)));
                              } else if (lifeInsuranceController.familyBookDoc.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectRecentPersonalPhoto, txtColor: primaryWhite, size: 12)));
                              }
                              /*else if (lifeInsuranceController.insuredDoc.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceDocument, txtColor: primaryWhite, size: 12)));
                              }*/
                              else {
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
            );
    });
  }

  Future selectPhotosDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    lifeInsuranceController.isLoadingPhotoDoc.value = true;
    final pickedFile = await lifeInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImg.add(xfilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 3);
      lifeInsuranceController.photoDoc.addAll(imagesUrl);
    }
    lifeInsuranceController.isLoadingPhotoDoc.value = false;
    setState(() {});
  }

  void removePhotosImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      lifeInsuranceController.photoDoc.remove(item);
    }
    setState(() {});
  }

  Future selectFamilyDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    lifeInsuranceController.isLoadingFamilyBookDoc.value = true;
    final pickedFile = await lifeInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImg.add(xfilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 3);
      lifeInsuranceController.familyBookDoc.addAll(imagesUrl);
    }
    lifeInsuranceController.isLoadingFamilyBookDoc.value = false;
    setState(() {});
  }

  void removeFamilyImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      lifeInsuranceController.familyBookDoc.remove(item);
    }
    setState(() {});
  }

  Future selectInsuranceDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    lifeInsuranceController.isLoadingInsuredDoc.value = true;
    final pickedFile = await lifeInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImg.add(xfilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 3);
      lifeInsuranceController.insuredDoc.addAll(imagesUrl);
    }
    lifeInsuranceController.isLoadingInsuredDoc.value = false;
    setState(() {});
  }

  void removeInsuranceImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      lifeInsuranceController.insuredDoc.remove(item);
    }
    setState(() {});
  }

  effectiveDateDialog() async {
    /*if (lifeInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (lifeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        lifeInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(lifeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        lifeInsuranceController.initialDate.value = lifeInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        lifeInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      lifeInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: lifeInsuranceController.initialDate.value, //get today's date
      firstDate: lifeInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      lifeInsuranceController.initialDate.value = pickedDate;
      setState(() {
        lifeInsuranceController.effectiveDateController.value.text = commonDateFormat(formattedDate);
      });
    } else {
      print("Date is not selected");
    }
  }
}
