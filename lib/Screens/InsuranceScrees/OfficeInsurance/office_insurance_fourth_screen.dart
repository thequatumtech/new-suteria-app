import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_controller.dart';
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
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class OfficeInsuranceFourthScreen extends StatefulWidget {
  Function onNext;

  OfficeInsuranceFourthScreen({super.key, required this.onNext});

  @override
  State<OfficeInsuranceFourthScreen> createState() => _OfficeInsuranceFourthScreenState();
}

class _OfficeInsuranceFourthScreenState extends State<OfficeInsuranceFourthScreen> {
  OfficeInsuranceController officeInsuranceController = Get.put(OfficeInsuranceController());
  ImageController imageController = Get.put(ImageController());

  TextEditingController startDateController = TextEditingController();

  @override
  void initState() {
    officeInsuranceController.getInsuranceLimit(context, '2');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return officeInsuranceController.isLoadingInsuranceLimit.value
          ? const Padding(
              padding: EdgeInsets.only(top: 120),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        InsuranceLimitListData cdl = officeInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                        officeInsuranceController.selectedInsuranceLimit.value = cdl;
                        officeInsuranceController.insurancePlanList.clear();
                        officeInsuranceController.insurancePlanList.addAll(cdl.planName ?? []);
                      });
                    },
                    items: officeInsuranceController.insuranceLimitList.map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: officeInsuranceController.insuranceLimitList.any((element) => element.limit == officeInsuranceController.selectedInsuranceLimit.value.limit) ? officeInsuranceController.selectedInsuranceLimit.value.limit ?? 0 : null,
                    dropdownTitle: insuranceLimitCoverageAmount,
                  ),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        PlanName cdl = officeInsuranceController.insurancePlanList.firstWhere((element) => element.planName == newValue);
                        officeInsuranceController.selectedInsurancePlan.value = cdl;
                      });
                    },
                    items: officeInsuranceController.insurancePlanList.map((item) => DropdownMenuItem(value: item.planName ?? '', child: Text(item.planName.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: officeInsuranceController.insurancePlanList.any((element) => element.planName == officeInsuranceController.selectedInsurancePlan.value.planName) ? officeInsuranceController.selectedInsurancePlan.value.planName ?? 0 : null,
                    dropdownTitle: linsuranceplan,
                  ),
                  AppTextfield(
                      readOnly: true,
                      hint: inceptiondate,
                      lable: inceptiondate,
                      controller: officeInsuranceController.inceptionDateController.value,
                      ontap: () {
                        inceptionDateDialog();
                      }),
                  const SizedBox(height: 20),
                  AppTextfield(
                      readOnly: true,
                      hint: expiredaate,
                      lable: expiredaate,
                      controller: officeInsuranceController.inceptionExpiryDate1Controller.value,
                   ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Image.asset(uploadlogo, height: 28, width: 28),
                      const SizedBox(width: 8),
                      AppText(text: uploadPhotosUpTo20, size: 14, fontWeight: FontWeight.bold),
                    ],
                  ),
                  officeInsuranceController.selectedRentDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectRentDocument();
                          },
                          child: ImageUploadWidget(txt: documentOfTheRentContractOwnership, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingRentDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: rentOwnershipDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedRentDocument,
                          removeDocumentFunction: (index) {
                            removeRentImage(officeInsuranceController.selectedRentDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectRentDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingRentDocument.value,
                        ),
                  officeInsuranceController.selectedPropertyDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectPropertyDocument();
                          },
                          child: ImageUploadWidget(txt: photosOfTheProperty, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingPropertyDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: propertyDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedPropertyDocument,
                          removeDocumentFunction: (index) {
                            removePropertyImage(officeInsuranceController.selectedPropertyDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectPropertyDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingPropertyDocument.value,
                        ),
                  officeInsuranceController.selectedContentsDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectContentsDocument();
                          },
                          child: ImageUploadWidget(txt: photosOfTheContents, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingContentsDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: contentsDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedContentsDocument,
                          removeDocumentFunction: (index) {
                            removeContentsImage(officeInsuranceController.selectedContentsDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectContentsDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingContentsDocument.value,
                        ),
                  officeInsuranceController.selectedAuthorizationDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectAuthorizationDocument();
                          },
                          child: ImageUploadWidget(txt: policyIssuerAuthorizationDocument, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingAuthorizationDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: authorizationDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedAuthorizationDocument,
                          removeDocumentFunction: (index) {
                            removeAuthorizationImage(officeInsuranceController.selectedAuthorizationDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectAuthorizationDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingAuthorizationDocument.value,
                        ),
                  officeInsuranceController.selectedRegistrationDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectRegistrationDocument();
                          },
                          child: ImageUploadWidget(txt: companyRegistrationOwnershipDocument, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingRegistrationDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: registrationOwnershipDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedRegistrationDocument,
                          removeDocumentFunction: (index) {
                            removeRegistrationImage(officeInsuranceController.selectedRegistrationDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectRegistrationDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingRegistrationDocument.value,
                        ),
                  officeInsuranceController.selectedLicenseDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectLicenseDocument();
                          },
                          child: ImageUploadWidget(txt: careerMunicipalityLicense, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingLicenseDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: careerMunicipalityLicenseDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedLicenseDocument,
                          removeDocumentFunction: (index) {
                            removeLicenseImage(officeInsuranceController.selectedLicenseDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectLicenseDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingLicenseDocument.value,
                        ),
                  officeInsuranceController.selectedOwnersIdDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectOwnersIdDocument();
                          },
                          child: ImageUploadWidget(txt: ownerIdDocument, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingOwnersIdDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: ownersIDDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedOwnersIdDocument,
                          removeDocumentFunction: (index) {
                            removeOwnersIdImage(officeInsuranceController.selectedOwnersIdDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectOwnersIdDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingOwnersIdDocument.value,
                        ),
                  officeInsuranceController.selectedPracticeCertificateDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectPracticeCertificateDocument();
                          },
                          child: ImageUploadWidget(txt: practiceCertificate, borderColor: skyBlueShade2, isLoading: officeInsuranceController.isLoadingPracticeCertificateDocument.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: practiceCertificateDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedPracticeCertificateDocument,
                          removeDocumentFunction: (index) {
                            removePracticeCertificateImage(officeInsuranceController.selectedPracticeCertificateDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectPracticeCertificateDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingPracticeCertificateDocument.value,
                        ),
                  officeInsuranceController.selectedCompanyTaxCertificateDocument.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectCompanyTaxCertificateDocument();
                          },
                          child: ImageUploadWidget(txt: companyTaxCertificate, borderColor: skyBlueShade2))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: companyTaxCertificateDocuments,
                          selectedDocumentsImg: officeInsuranceController.selectedCompanyTaxCertificateDocument,
                          removeDocumentFunction: (index) {
                            removeCompanyTaxCertificateImage(officeInsuranceController.selectedCompanyTaxCertificateDocument[index]);
                          },
                          addDocumentFunction: () {
                            selectCompanyTaxCertificateDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: officeInsuranceController.isLoadingCompanyTaxCertificateDocument.value,
                        ),
                  officeInsuranceController.selectedAuthorizedToIssue == noTxt
                      ? AppText(
                          text: youDontHaveAuthorisationToIssueAnInsurancePolicy,
                          size: 14,
                          txtColor: Colors.red,
                        )
                      : AppBtnWithColorShades(
                          onTap: () {
                            if (officeInsuranceController.selectedInsuranceLimit.value.limit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceLimit, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedInsurancePlan.value.planName == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsurancePlan, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.inceptionDateController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInceptionDate, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedRentDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadRentContractOwnershipDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedPropertyDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPropertyDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedContentsDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadContentsDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedAuthorizationDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPolicyIssueAuthorizationDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedRegistrationDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadCompanyRegistrationOwnershipDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedLicenseDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadCareerMunicipalityLicenseDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedOwnersIdDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadOwnerIdDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedPracticeCertificateDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPracticeCertificateDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (officeInsuranceController.selectedCompanyTaxCertificateDocument.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadCompanyTaxCertificateDocuments, txtColor: primaryWhite, size: 12)));
                            } else {
                              widget.onNext();
                            }
                          },
                          btnTxt: continuE,
                          color1: darkBlue2,
                          color2: darkBlue1,
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            );
    });
  }

  Future selectRentDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingRentDocument.value = true;
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
      officeInsuranceController.selectedRentDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingRentDocument.value = false;
    setState(() {});
  }

  void removeRentImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedRentDocument.remove(item);
    }
    setState(() {});
  }

  Future selectPropertyDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingPropertyDocument.value = true;
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
      officeInsuranceController.selectedPropertyDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingPropertyDocument.value = false;
    setState(() {});
  }

  void removePropertyImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedPropertyDocument.remove(item);
    }
    setState(() {});
  }

  Future selectContentsDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingContentsDocument.value = true;
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
      officeInsuranceController.selectedContentsDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingContentsDocument.value = false;
    setState(() {});
  }

  void removeContentsImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedContentsDocument.remove(item);
    }
    setState(() {});
  }

  Future selectAuthorizationDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingAuthorizationDocument.value = true;
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
      officeInsuranceController.selectedAuthorizationDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingAuthorizationDocument.value = false;
    setState(() {});
  }

  void removeAuthorizationImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedAuthorizationDocument.remove(item);
    }
    setState(() {});
  }

  Future selectRegistrationDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingRegistrationDocument.value = true;
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
      officeInsuranceController.selectedRegistrationDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingRegistrationDocument.value = false;
    setState(() {});
  }

  void removeRegistrationImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedRegistrationDocument.remove(item);
    }
    setState(() {});
  }

  Future selectLicenseDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingLicenseDocument.value = true;
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
      officeInsuranceController.selectedLicenseDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingLicenseDocument.value = false;
    setState(() {});
  }

  void removeLicenseImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedLicenseDocument.remove(item);
    }
    setState(() {});
  }

  Future selectOwnersIdDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingOwnersIdDocument.value = true;
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
      officeInsuranceController.selectedOwnersIdDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingOwnersIdDocument.value = false;
    setState(() {});
  }

  void removeOwnersIdImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedOwnersIdDocument.remove(item);
    }
    setState(() {});
  }

  Future selectPracticeCertificateDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingPracticeCertificateDocument.value = true;
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
      officeInsuranceController.selectedPracticeCertificateDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingPracticeCertificateDocument.value = false;
    setState(() {});
  }

  void removePracticeCertificateImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedPracticeCertificateDocument.remove(item);
    }
    setState(() {});
  }

  Future selectCompanyTaxCertificateDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    officeInsuranceController.isLoadingCompanyTaxCertificateDocument.value = true;
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
      officeInsuranceController.selectedCompanyTaxCertificateDocument.addAll(imagesUrl);
    }
    officeInsuranceController.isLoadingCompanyTaxCertificateDocument.value = false;
    setState(() {});
  }

  void removeCompanyTaxCertificateImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      officeInsuranceController.selectedCompanyTaxCertificateDocument.remove(item);
    }
    setState(() {});
  }

  inceptionDateDialog() async {
   /* if (officeInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (officeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        officeInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(officeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        officeInsuranceController.initialDate.value = officeInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        officeInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      officeInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate:  officeInsuranceController.initialDate.value, //get today's date
      firstDate:  officeInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      setState(() {
        officeInsuranceController.inceptionDateController.value.text = commonDateFormat(formattedDate);
        officeInsuranceController.inceptionExpiryDate1Controller.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(pickedDate)).add(const Duration(days: 364)).toString())));
      });
    } else {
      print("Date is not selected");
    }
  }
}
