import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/new_upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';

class OfficeInsuranceThirdScreen extends StatefulWidget {
  Function onNext;

  OfficeInsuranceThirdScreen({super.key, required this.onNext});

  @override
  State<OfficeInsuranceThirdScreen> createState() => _OfficeInsuranceThirdScreenState();
}

class _OfficeInsuranceThirdScreenState extends State<OfficeInsuranceThirdScreen> {
  OfficeInsuranceController officeInsuranceController = Get.put(OfficeInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return officeInsuranceController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: mariq1, size: 15, txtAlign: TextAlign.start),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: officeInsuranceController.selectedPartnerInTheCompany,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedPartnerInTheCompany = value!;
                            });
                          },
                        ),
                        const Text(yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: officeInsuranceController.selectedPartnerInTheCompany,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedPartnerInTheCompany = value!;
                            });
                          },
                        ),
                        const Text(noTxt),
                      ],
                    ),
                    AppText(text: mariq2, size: 15, txtAlign: TextAlign.start),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: officeInsuranceController.selectedAuthorizedToIssue,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedAuthorizedToIssue = value!;
                            });
                          },
                        ),
                        const Text(yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: officeInsuranceController.selectedAuthorizedToIssue,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedAuthorizedToIssue = value!;
                            });
                          },
                        ),
                        const Text(noTxt),
                      ],
                    ),
                    if (officeInsuranceController.selectedAuthorizedToIssue == yesTxt)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(text: marinq3, size: 15, txtAlign: TextAlign.start),
                          AppTextfield(
                            controller: officeInsuranceController.authorizedPositionController.value,
                            hint: authorizedPosition,
                            lable: authorizedPosition,
                          ),
                        ],
                      ),
                    SizedBox(height: 12),
                    AppText(text: mariq5, size: 15, txtAlign: TextAlign.start),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: officeInsuranceController.selectedPreviousInsurancePolicy,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedPreviousInsurancePolicy = value!;
                            });
                          },
                        ),
                        const Text(yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: officeInsuranceController.selectedPreviousInsurancePolicy,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedPreviousInsurancePolicy = value!;
                            });
                          },
                        ),
                        const Text(noTxt),
                      ],
                    ),
                    if (officeInsuranceController.selectedPreviousInsurancePolicy == yesTxt)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          AppText(text: marinq6, size: 15, txtAlign: TextAlign.start),
                          officeInsuranceController.selectedDocument.isEmpty
                              ? InkWell(
                                  onTap: () {
                                    selectPhotosDocument();
                                  },
                                  child: ImageUploadWidget(borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingSelectedDocument.value))
                              : NewUploadDocumentsCommonScreen(
                                  documentNameText: documents,
                                  selectedDocumentsImg: officeInsuranceController.selectedDocument,
                                  removeDocumentFunction: (index) {
                                    removePhotosImage(officeInsuranceController.selectedDocument[index]);
                                  },
                                  addDocumentFunction: () {
                                    selectPhotosDocument();
                                  },
                                  addDocText: addDocuments,
                                  isLoading: officeInsuranceController.isLoadingSelectedDocument.value,
                                ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(text: anyPreviousInsurancePolicy, size: 15, txtAlign: TextAlign.start),
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: officeInsuranceController.selectedAuthorizedIsStated,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedAuthorizedIsStated = value!;
                            });
                          },
                        ),
                        const Text(yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: officeInsuranceController.selectedAuthorizedIsStated,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedAuthorizedIsStated = value!;
                            });
                          },
                        ),
                        const Text(noTxt),
                      ],
                    ),
                    if (officeInsuranceController.selectedAuthorizedIsStated == yesTxt) AppTextfield(controller: officeInsuranceController.previousInsurancePolicyController.value, hint: homen1, lable: homen1),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: AppText(
                        text: officeq1,
                        size: 15,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: officeInsuranceController.selectedOfficeInsurancePolicyBefore,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedOfficeInsurancePolicyBefore = value!;
                            });
                          },
                        ),
                        const Text(yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: officeInsuranceController.selectedOfficeInsurancePolicyBefore,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedOfficeInsurancePolicyBefore = value!;
                            });
                          },
                        ),
                        const Text(noTxt),
                      ],
                    ),
                    if (officeInsuranceController.selectedOfficeInsurancePolicyBefore == yesTxt)
                      Column(
                        children: [
                          AppTextfield(
                            maxLine: 2,
                            controller: officeInsuranceController.companyDeclinedIssueController.value,
                            hint: pleaseWriteAnInsuranceCompany,
                            lable: pleaseWriteAnInsuranceCompany,
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: AppText(
                        text: homeq3,
                        size: 15,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: officeInsuranceController.selectedClaimsAndAccidentsYears,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedClaimsAndAccidentsYears = value!;
                            });
                          },
                        ),
                        const Text(yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: officeInsuranceController.selectedClaimsAndAccidentsYears,
                          onChanged: (value) {
                            setState(() {
                              officeInsuranceController.selectedClaimsAndAccidentsYears = value!;
                            });
                          },
                        ),
                        Text(noTxt),
                      ],
                    ),
                    if (officeInsuranceController.selectedClaimsAndAccidentsYears == yesTxt)
                      Column(children: [
                        AppTextfield(
                          controller: officeInsuranceController.claimsAndAccidentsController.value,
                          hint: homen3,
                          lable: homen3,
                        ),
                      ]),

                    /*   CustomDropDownBorder1(
              onchage: (newValue) {
                setState(() {
                  ProtectionSystemList cdl = officeInsuranceController.protectionSystemList.firstWhere((element) => element.id == newValue);
                  officeInsuranceController.selectProtectionSystem.value = cdl;
                });
              },
              items: officeInsuranceController.protectionSystemList
                  .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style:  TextStyle(fontSize: 15, color: primaryBlack))))
                  .toList(),
              selectedValue:officeInsuranceController.protectionSystemList.any((element) => element.id == officeInsuranceController.selectProtectionSystem.value.id)
                  ? officeInsuranceController.selectProtectionSystem.value.id ?? 0
                  : null,
              dropdownTitle: officespace,
            ),*/
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: AppText(
                        text: officespace,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MultiSelectDropDown<int>(
                      onOptionSelected: (List<ValueItem<int>> selectedOptions) {
                        officeInsuranceController.selectProtectionSystemList = selectedOptions;
                        setState(() {}); // Keeps UI updated while on the same screen
                      },
                      options: officeInsuranceController.protectionSystemListDrop,
                      selectedOptions: officeInsuranceController.selectProtectionSystemList, // 👈 Add this line
                      focusedBorderColor: skyBlueShade1,
                      borderColor: skyBlueShade1,
                      borderWidth: 1,
                      selectionType: SelectionType.multi,
                      hint: pleaseChooseFromTheList,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 200,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    /* MultiSelectDropDown<int>(
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        officeInsuranceController.selectProtectionSystemList = selectedOptions;
                        setState(() {});
                      },
                      options: officeInsuranceController.protectionSystemListDrop,
                      focusedBorderColor: skyBlueShade1,
                      borderColor: skyBlueShade1,
                      borderWidth: 1,
                      selectionType: SelectionType.multi,
                      hint: pleaseChooseFromTheList,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 200,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),*/
                    const SizedBox(height: 20),
                    AppBtnWithColorShades(
                      onTap: () {
                        if (officeInsuranceController.selectedAuthorizedToIssue == yesTxt && officeInsuranceController.authorizedPositionController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterAuthorizedPosition, txtColor: primaryWhite, size: 12)));
                        }if (officeInsuranceController.selectedPreviousInsurancePolicy == yesTxt && officeInsuranceController.selectedDocument.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadAuthDoc, txtColor: primaryWhite, size: 12)));
                        }

                        else if (officeInsuranceController.selectedPreviousInsurancePolicy == yesTxt && officeInsuranceController.selectedDocument.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadAuthorizationDocument, txtColor: primaryWhite, size: 12)));
                        } else if (officeInsuranceController.selectedAuthorizedIsStated == yesTxt && officeInsuranceController.previousInsurancePolicyController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPreviousPolicy, txtColor: primaryWhite, size: 12)));
                        } else if (officeInsuranceController.selectedOfficeInsurancePolicyBefore == yesTxt && officeInsuranceController.companyDeclinedIssueController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterInsuranceCompanyDeclinedToIssue, txtColor: primaryWhite, size: 12)));
                        } else if (officeInsuranceController.selectedClaimsAndAccidentsYears == yesTxt && officeInsuranceController.claimsAndAccidentsController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterClaimAccidentDetails, txtColor: primaryWhite, size: 12)));
                        } else if (officeInsuranceController.selectProtectionSystemList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseChoseProtectionSystem, txtColor: primaryWhite, size: 12)));
                        } else {
                          widget.onNext();
                        }
                      },
                      btnTxt: next,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
      },
    );
  }

  Future selectPhotosDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingSelectedDocument.value = true;
    final pickedFile = await officeInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 2);
      officeInsuranceController.selectedDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingSelectedDocument.value = false;
    setState(() {});
  }

  void removePhotosImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedDocument.remove(item);
    }
    setState(() {});
  }
}
