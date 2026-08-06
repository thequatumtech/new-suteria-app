
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/new_upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';

class MarineInsuranceSecondScreen extends StatefulWidget {
  Function onNext;
  bool selectedOptin;

  MarineInsuranceSecondScreen({super.key, required this.onNext, required this.selectedOptin});

  @override
  State<MarineInsuranceSecondScreen> createState() => _MarineInsuranceSecondScreenState();
}

class _MarineInsuranceSecondScreenState extends State<MarineInsuranceSecondScreen> {
  MarineInsuranceController marineInsuranceController = Get.put(MarineInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(uploadlogo, height: 28, width: 28),
              const SizedBox(
                width: 8,
              ),
              AppText(text: uploadPhotosUpTo20, size: 14),
            ],
          ),
          marineInsuranceController.individual.value
              ? Column(
                  children: [
                    marineInsuranceController.selectedBillOfLadingDocuments.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectBillOfLadingDocument();
                            },
                            child: ImageUploadWidget(txt: documentOfBillBillOfLading, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingBillOfLadingDocuments.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: billOfLadingDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedBillOfLadingDocuments,
                            removeDocumentFunction: (index) {
                              removeBillOfLadingImage(marineInsuranceController.selectedBillOfLadingDocuments[index]);
                            },
                            addDocumentFunction: () {
                              selectBillOfLadingDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingBillOfLadingDocuments.value,
                          ),
                    marineInsuranceController.selectedCopyOfInvoice.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectCopyOfInvoiceDocument();
                            },
                            child: ImageUploadWidget(txt: copyOfInvoice, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingCopyOfInvoice.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: copyOfInvoiceDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedCopyOfInvoice,
                            removeDocumentFunction: (index) {
                              removeCopyOfInvoiceImage(marineInsuranceController.selectedCopyOfInvoice[index]);
                            },
                            addDocumentFunction: () {
                              selectCopyOfInvoiceDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingCopyOfInvoice.value,
                          ),
                    marineInsuranceController.selectedInsuredsId.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectInsuredsIdDocument();
                            },
                            child: ImageUploadWidget(txt: insuredIdDocument, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingInsuredsId.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: insuredsIDDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedInsuredsId,
                            removeDocumentFunction: (index) {
                              removeInsuredsIdImage(marineInsuranceController.selectedInsuredsId[index]);
                            },
                            addDocumentFunction: () {
                              selectInsuredsIdDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingInsuredsId.value,
                          ),
                  ],
                )
              : Column(
                  children: [
                    marineInsuranceController.selectedPolicyIssuerAuthorization.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectPolicyIssuerAuthorizationDocument();
                            },
                            child: ImageUploadWidget(txt: policyIssuerAuthorizationDocument, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingPolicyIssuerAuthorization.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: policyIssuerAuthorizationDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedPolicyIssuerAuthorization,
                            removeDocumentFunction: (index) {
                              removePolicyIssuerAuthorizationImage(marineInsuranceController.selectedPolicyIssuerAuthorization[index]);
                            },
                            addDocumentFunction: () {
                              selectPolicyIssuerAuthorizationDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingPolicyIssuerAuthorization.value,
                          ),
                    marineInsuranceController.selectedCompanyRegistrationOwnership.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectCompanyRegistrationOwnershipDocument();
                            },
                            child: ImageUploadWidget(txt: companyRegistrationOwnershipDocument, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingCompanyRegistrationOwnership.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: companyRegistrationOwnershipDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedCompanyRegistrationOwnership,
                            removeDocumentFunction: (index) {
                              removeCompanyRegistrationOwnershipImage(marineInsuranceController.selectedCompanyRegistrationOwnership[index]);
                            },
                            addDocumentFunction: () {
                              selectCompanyRegistrationOwnershipDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingCompanyRegistrationOwnership.value,
                          ),
                    marineInsuranceController.selectedCareerMunicipalityLicense.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectCareerMunicipalityLicenseDocument();
                            },
                            child: ImageUploadWidget(txt: careerMunicipalityLicense, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingCareerMunicipalityLicense.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: careerMunicipalityLicenseDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedCareerMunicipalityLicense,
                            removeDocumentFunction: (index) {
                              removeCareerMunicipalityLicenseImage(marineInsuranceController.selectedCareerMunicipalityLicense[index]);
                            },
                            addDocumentFunction: () {
                              selectCareerMunicipalityLicenseDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingCareerMunicipalityLicense.value,
                          ),
                    marineInsuranceController.selectedCompanyTaxCertificate.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectCompanyTaxCertificateDocument();
                            },
                            child: ImageUploadWidget(txt: companyTaxCertificate, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingCompanyTaxCertificate.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: companyTaxCertificateDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedCompanyTaxCertificate,
                            removeDocumentFunction: (index) {
                              removeCompanyTaxCertificateImage(marineInsuranceController.selectedCompanyTaxCertificate[index]);
                            },
                            addDocumentFunction: () {
                              selectCompanyTaxCertificateDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingCompanyTaxCertificate.value,
                          ),
                    marineInsuranceController.selectedPracticeCertificate.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectPracticeCertificateDocument();
                            },
                            child: ImageUploadWidget(txt: practiceCertificate, borderColor: skyBlueShade2, isLoading: marineInsuranceController.isLoadingPracticeCertificate.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: practiceCertificateDocuments,
                            selectedDocumentsImg: marineInsuranceController.selectedPracticeCertificate,
                            removeDocumentFunction: (index) {
                              removePracticeCertificateImage(marineInsuranceController.selectedPracticeCertificate[index]);
                            },
                            addDocumentFunction: () {
                              selectPracticeCertificateDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: marineInsuranceController.isLoadingPracticeCertificate.value,
                          ),
                  ],
                ),
          if (widget.selectedOptin) AppText(text: youCanNotProceedFurther, size: 16, txtColor: Colors.red),
          const SizedBox(height: 20),
          AppBtnWithColorShades(
            onTap: () {
              if (marineInsuranceController.individual.value && marineInsuranceController.selectedBillOfLadingDocuments.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadBillBillOfLoadingDocuments, txtColor: primaryWhite, size: 12)));
              } else if (marineInsuranceController.individual.value && marineInsuranceController.selectedCopyOfInvoice.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadCopyOfInvoiceDocuments, txtColor: primaryWhite, size: 12)));
              } else if (marineInsuranceController.individual.value && marineInsuranceController.selectedInsuredsId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadInsuredsIdDocuments, txtColor: primaryWhite, size: 12)));
              } else if (!marineInsuranceController.individual.value && marineInsuranceController.selectedPolicyIssuerAuthorization.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPolicyIssuerAuthorizationDocuments, txtColor: primaryWhite, size: 12)));
              } else if (!marineInsuranceController.individual.value && marineInsuranceController.selectedCompanyRegistrationOwnership.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadCompanyRegistrationOwnershipDocuments, txtColor: primaryWhite, size: 12)));
              } else if (!marineInsuranceController.individual.value && marineInsuranceController.selectedCareerMunicipalityLicense.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadCareerMunicipalityLicenseDocuments, txtColor: primaryWhite, size: 12)));
              } else if (!marineInsuranceController.individual.value && marineInsuranceController.selectedCompanyTaxCertificate.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadCompanyTaxCertificateDocuments, txtColor: primaryWhite, size: 12)));
              } else if (!marineInsuranceController.individual.value && marineInsuranceController.selectedPracticeCertificate.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPracticeCertificateDocuments, txtColor: primaryWhite, size: 12)));
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
  }

  Future selectBillOfLadingDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingBillOfLadingDocuments.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedBillOfLadingDocuments.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingBillOfLadingDocuments.value = false;
    setState(() {});
  }

  void removeBillOfLadingImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedBillOfLadingDocuments.remove(item);
    }
    setState(() {});
  }

  Future selectCopyOfInvoiceDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingCopyOfInvoice.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedCopyOfInvoice.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingCopyOfInvoice.value = false;
    setState(() {});
  }

  void removeCopyOfInvoiceImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedCopyOfInvoice.remove(item);
    }
    setState(() {});
  }

  Future selectInsuredsIdDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingInsuredsId.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedInsuredsId.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingInsuredsId.value = false;
    setState(() {});
  }

  void removeInsuredsIdImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedInsuredsId.remove(item);
    }
    setState(() {});
  }

  Future selectPolicyIssuerAuthorizationDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingPolicyIssuerAuthorization.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedPolicyIssuerAuthorization.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingPolicyIssuerAuthorization.value = false;
    setState(() {});
  }

  void removePolicyIssuerAuthorizationImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedPolicyIssuerAuthorization.remove(item);
    }
    setState(() {});
  }

  Future selectCompanyRegistrationOwnershipDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingCompanyRegistrationOwnership.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedCompanyRegistrationOwnership.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingCompanyRegistrationOwnership.value = false;
    setState(() {});
  }

  void removeCompanyRegistrationOwnershipImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedCompanyRegistrationOwnership.remove(item);
    }
    setState(() {});
  }

  Future selectCareerMunicipalityLicenseDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingCareerMunicipalityLicense.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedCareerMunicipalityLicense.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingCareerMunicipalityLicense.value = false;
    setState(() {});
  }

  void removeCareerMunicipalityLicenseImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedCareerMunicipalityLicense.remove(item);
    }
    setState(() {});
  }

  Future selectCompanyTaxCertificateDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingCompanyTaxCertificate.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedCompanyTaxCertificate.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingCompanyTaxCertificate.value = false;
    setState(() {});
  }

  void removeCompanyTaxCertificateImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedCompanyTaxCertificate.remove(item);
    }
    setState(() {});
  }

  Future selectPracticeCertificateDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    marineInsuranceController.isLoadingPracticeCertificate.value = true;
    final pickedFile = await marineInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 11);
      marineInsuranceController.selectedPracticeCertificate.addAll(imagesUrl);
    }
    marineInsuranceController.isLoadingPracticeCertificate.value = false;
    setState(() {});
  }

  void removePracticeCertificateImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      marineInsuranceController.selectedPracticeCertificate.remove(item);
    }
    setState(() {});
  }
}
