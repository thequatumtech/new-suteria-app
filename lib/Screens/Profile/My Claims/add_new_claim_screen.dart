import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/claim_controller.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/get_policy_details_model.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';
import 'package:soperia_user/model_class/get_claims_list_model.dart';

class AddNewClaimsScreen extends StatefulWidget {
  PolicyData? data;
  ClaimsListData? editData;
  bool isEdit;

  AddNewClaimsScreen({super.key, required this.isEdit, this.data,this.editData});

  @override
  State<AddNewClaimsScreen> createState() => _AddNewClaimsScreenState();
}

class _AddNewClaimsScreenState extends State<AddNewClaimsScreen> with SingleTickerProviderStateMixin {
  ClaimController claimController = Get.put(ClaimController());

  @override
  void initState() {
    claimController.clearData(widget.isEdit,widget.editData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText(text: widget.isEdit ? editClaim : addNewClaim, size: 18, fontWeight: FontWeight.bold)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: primaryWhite,
                      borderRadius: BorderRadius.circular(10),
                      /* boxShadow: [
                      BoxShadow(
                        color: primaryGray.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        // offset: const Offset(0, 0),
                      ),
                    ],*/
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 10),
                          decoration: const BoxDecoration(
                            color: deepBluedark,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                          child: AppText(text: '$policyNo ${widget.data!=null ? widget.data!.policyNo ?? '' :widget.editData!.claimNo ?? ''}', txtColor: primaryWhite, size: 16, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 12, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(text: policyType, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                    const SizedBox(height: 2),
                                    AppText(text: widget.data!=null ? widget.data!.policyType ?? '' : widget.editData!.policyType ?? '', size: 15, fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(text: insuranceCompany, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                    const SizedBox(height: 2),
                                    AppText(text:widget.data!=null ? widget.data!.companyName ?? '' : widget.editData!.companyName ?? '', size: 15, fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            AppTextfield(
                              controller: claimController.claimNoteController.value,
                              enabledBorderColor: skyBlueShade2,
                              maxLine: 5,
                              maxLength: 300,
                              hint: '',
                              lable: writeYourTextHere,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${claimController.claimNoteController.value.text.length}/${claimController.maxLength}",
                                style: const TextStyle(color: primaryGrey),
                              ),
                            ),
                          ],
                        ),
                        claimController.selectedPropertyContract.isEmpty
                            ? InkWell(
                                onTap: () {
                                  selectPropertyContractDocument();
                                },
                                child: SizedBox(height: 160, child: ImageUploadWidget(txt: uploadYourPropertyContractHere, borderColor: skyBlueShade2)))
                            : UploadDocumentsCommonScreen(
                                documentNameText: documents,
                                selectedDocumentsImg: claimController.selectedPropertyContract,
                                removeDocumentFunction: (index) {
                                  removeInsuredsIdImage(claimController.selectedPropertyContract[index]);
                                },
                                addDocumentFunction: () {
                                  selectPropertyContractDocument();
                                }, addDocText: addHomeOfficeImages,
                              ),
                        const SizedBox(height: 40),
                        AppBtnWithColorShades(
                          isLoad: claimController.isLoadingAddClaim.value,
                          onTap: () {
                            if (claimController.claimNoteController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterClaimNote, txtColor: primaryWhite, size: 12)));
                            } else if (claimController.selectedPropertyContract.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadDocuments, txtColor: primaryWhite, size: 12)));
                            } else {
                              if (!widget.isEdit) {
                                claimController.addClaimsApi(context, widget.data!);
                              }else{
                                claimController.editClaimsApi(context, widget.editData!);
                              }
                            }
                          },
                          btnTxt: widget.isEdit ? editClaim : addClaim,
                          color1: darkBlue2,
                          color2: darkBlue1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future selectPropertyContractDocument() async {
    final pickedFile = await claimController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        claimController.selectedPropertyContract.add(File(xFilePick[i].path));
      }
    }
    setState(() {});
  }

  void removeInsuredsIdImage(File item) {
    claimController.selectedPropertyContract.remove(item);
    setState(() {});
  }
}
