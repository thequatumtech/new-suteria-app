import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_illness_insurance_controller.dart';
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
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class CriticalInsuranceFourthScreen extends StatefulWidget {
  Function onNext;

  CriticalInsuranceFourthScreen({super.key, required this.onNext});

  @override
  State<CriticalInsuranceFourthScreen> createState() => _CriticalInsuranceFourthScreenState();
}

class _CriticalInsuranceFourthScreenState extends State<CriticalInsuranceFourthScreen> {
  CriticalIllnessInsuranceController criticalIllnessInsuranceController = Get.put(CriticalIllnessInsuranceController());
  ImageController imageController = Get.put(ImageController());

  TextEditingController startDateController = TextEditingController();

  @override
  void initState() {
    criticalIllnessInsuranceController.getInsuranceLimit(context, '4');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return criticalIllnessInsuranceController.isLoading.value
          ? const Padding(
              padding: EdgeInsets.only(top: 140),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          AppText(
                            text: criticalq2,
                            size: 15,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: yesTxt,
                            groupValue: criticalIllnessInsuranceController.selectedOption1,
                            onChanged: (value) {
                              setState(() {
                                criticalIllnessInsuranceController.selectedOption1 = value!;
                              });
                            },
                          ),
                          const Text(yesTxt),
                          Radio(
                            value: noTxt,
                            groupValue: criticalIllnessInsuranceController.selectedOption1,
                            onChanged: (value) {
                              setState(() {
                                criticalIllnessInsuranceController.selectedOption1 = value!;
                              });
                            },
                          ),
                          const Text(noTxt),
                        ],
                      ),
                    ],
                  ),
                  if (criticalIllnessInsuranceController.selectedOption1 == yesTxt)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextfield(controller: criticalIllnessInsuranceController.previousInsurancePolicyDetailsController.value, hint: homen1, lable: homen1),
                    ),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        InsuranceLimitListData cdl = criticalIllnessInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                        criticalIllnessInsuranceController.selectedInsuranceLimit.value = cdl;
                        criticalIllnessInsuranceController.insurancePlanList.clear();
                        criticalIllnessInsuranceController.insurancePlanList.addAll(cdl.planName ?? []);
                      });
                    },
                    items: criticalIllnessInsuranceController.insuranceLimitList
                        .map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack))))
                        .toList(),
                    selectedValue: criticalIllnessInsuranceController.insuranceLimitList.any((element) => element.limit == criticalIllnessInsuranceController.selectedInsuranceLimit.value.limit)
                        ? criticalIllnessInsuranceController.selectedInsuranceLimit.value.limit ?? 0
                        : null,
                    dropdownTitle: insuranceLimitCoverageAmount,
                  ),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        PlanName cdl = criticalIllnessInsuranceController.insurancePlanList.firstWhere((element) => element.planName == newValue);
                        criticalIllnessInsuranceController.selectedInsurancePlan.value = cdl;
                        criticalIllnessInsuranceController.updateExpireDate();
                      });
                    },
                    items: criticalIllnessInsuranceController.insurancePlanList
                        .map((item) => DropdownMenuItem(value: item.planName ?? '', child: Text(item.planName.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack))))
                        .toList(),
                    selectedValue: criticalIllnessInsuranceController.insurancePlanList.any((element) => element.planName == criticalIllnessInsuranceController.selectedInsurancePlan.value.planName)
                        ? criticalIllnessInsuranceController.selectedInsurancePlan.value.planName ?? ''
                        : null,
                    dropdownTitle: linsuranceplan,
                  ),
                  AppTextfield(
                      readOnly: true,
                      hint: inceptiondate,
                      lable: inceptiondate,
                      controller: criticalIllnessInsuranceController.inceptionDateController.value,
                      ontap: () {
                        inceptionDateDialog();
                      }),
                  const SizedBox(height: 25),
                  AppTextfield(
                    readOnly: true,
                    hint: expiredaate,
                    lable: expiredaate,
                    controller: criticalIllnessInsuranceController.expireDateController.value,
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: uploaddocument,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  criticalIllnessInsuranceController.passportIdDocuments.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectPhotosDocument();
                          },
                          child: ImageUploadWidget(txt: addIdPassport, borderColor: skyBlueShade2, isLoading: criticalIllnessInsuranceController.isLoadingPassportIdDocuments.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: iDPassport,
                          selectedDocumentsImg: criticalIllnessInsuranceController.passportIdDocuments,
                          removeDocumentFunction: (index) {
                            removePhotosImage(criticalIllnessInsuranceController.passportIdDocuments[index]);
                          },
                          addDocumentFunction: () {
                            selectPhotosDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: criticalIllnessInsuranceController.isLoadingPassportIdDocuments.value,
                        ),
                  criticalIllnessInsuranceController.insuredDocuments.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectDocument();
                          },
                          child: ImageUploadWidget(txt: addPhotoOfTheInsured, borderColor: skyBlueShade2, isLoading: criticalIllnessInsuranceController.isLoadingInsuredDocuments.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: photoOfTheInsured,
                          selectedDocumentsImg: criticalIllnessInsuranceController.insuredDocuments,
                          removeDocumentFunction: (index) {
                            removeImage(criticalIllnessInsuranceController.insuredDocuments[index]);
                          },
                          addDocumentFunction: () {
                            selectDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: criticalIllnessInsuranceController.isLoadingInsuredDocuments.value,
                        ),
                  /*InkWell(onTap: () => widget.onNext(), child: Image.asset(buttonImg)),*/
                  criticalIllnessInsuranceController.isShowHWValidationMsg.value
                      ? AppText(
                          text: sorryYourRequestTypeOfInsuranceCannotBeProcessedDueToTechnicalUnderwritingPleaseContactUsAnyClarification,
                          txtColor: Colors.red,
                          size: 14,
                        )
                      : AppBtnWithColorShades(
                          onTap: () {
                            if (criticalIllnessInsuranceController.selectedOption1 == '') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectAnyPreviousPolicy, txtColor: primaryWhite, size: 12)));
                            } else if (criticalIllnessInsuranceController.selectedOption1 == yesTxt && criticalIllnessInsuranceController.previousInsurancePolicyDetailsController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterPreviousInsurancePolicyDetails, txtColor: primaryWhite, size: 12)));
                            } else if (criticalIllnessInsuranceController.selectedInsuranceLimit.value.limit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceLimitCoverageAmount, txtColor: primaryWhite, size: 12)));
                            } else if (criticalIllnessInsuranceController.selectedInsurancePlan.value.planName == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsurancePlan, txtColor: primaryWhite, size: 12)));
                            } else if (criticalIllnessInsuranceController.inceptionDateController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInceptionDate, txtColor: primaryWhite, size: 12)));
                            } else if (criticalIllnessInsuranceController.expireDateController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
                            } else if (criticalIllnessInsuranceController.passportIdDocuments.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDocuments, txtColor: primaryWhite, size: 12)));
                            } else if (criticalIllnessInsuranceController.insuredDocuments.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDocuments, txtColor: primaryWhite, size: 12)));
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

  Future selectPhotosDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    criticalIllnessInsuranceController.isLoadingPassportIdDocuments.value = true;
    final pickedFile = await criticalIllnessInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 4);
      criticalIllnessInsuranceController.passportIdDocuments.addAll(imagesUrl);
    }
    criticalIllnessInsuranceController.isLoadingPassportIdDocuments.value = false;
    setState(() {});
  }

  void removePhotosImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      criticalIllnessInsuranceController.passportIdDocuments.remove(item);
    }
    setState(() {});
  }

  Future selectDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    criticalIllnessInsuranceController.isLoadingInsuredDocuments.value = true;
    final pickedFile = await criticalIllnessInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 4);
      criticalIllnessInsuranceController.insuredDocuments.addAll(imagesUrl);
    }
    criticalIllnessInsuranceController.isLoadingInsuredDocuments.value = false;
    setState(() {});
  }

  void removeImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      criticalIllnessInsuranceController.insuredDocuments.remove(item);
    }
    setState(() {});
  }

  inceptionDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: criticalIllnessInsuranceController.initialDate.value, //get today's date
      firstDate: criticalIllnessInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      setState(() {
        criticalIllnessInsuranceController.inceptionDateController.value.text = commonDateFormat(formattedDate);
        criticalIllnessInsuranceController.updateExpireDate(pickedDate);
      });
    } else {
      print("Date is not selected");
    }
  }
}
