import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_controller.dart';
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

class DentalInsuranceThirdScreen extends StatefulWidget {
  Function onNext;

  DentalInsuranceThirdScreen({super.key, required this.onNext});

  @override
  State<DentalInsuranceThirdScreen> createState() => _DentalInsuranceThirdScreenState();
}

class _DentalInsuranceThirdScreenState extends State<DentalInsuranceThirdScreen> {
  DentalInsuranceController dentalInsuranceController = Get.put(DentalInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    dentalInsuranceController.getInsuranceLimit(context, '9');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return dentalInsuranceController.isLoading.value
          ? const Padding(
              padding: EdgeInsets.only(top: 140),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              InsuranceLimitListData cdl = dentalInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                              dentalInsuranceController.selectedInsuranceLimit.value = cdl;
                              dentalInsuranceController.insurancePlanList.clear();
                              dentalInsuranceController.insurancePlanList.addAll(cdl.planName ?? []);
                            });
                          },
                          items: dentalInsuranceController.insuranceLimitList
                              .map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack))))
                              .toList(),
                          selectedValue: dentalInsuranceController.insuranceLimitList.any((element) => element.limit == dentalInsuranceController.selectedInsuranceLimit.value.limit)
                              ? dentalInsuranceController.selectedInsuranceLimit.value.limit ?? 0
                              : null,
                          dropdownTitle: '$selectYour $insurancelimit',
                        ),
                        CustomDropDownBorder1(
                            onchage: (newValue) {
                              setState(() {
                                PlanName cdl = dentalInsuranceController.insurancePlanList.firstWhere((element) => element.planName == newValue);
                                dentalInsuranceController.selectedInsurancePlan.value = cdl;
                                dentalInsuranceController.updateExpireDate();
                              });
                            },
                          items: dentalInsuranceController.insurancePlanList
                              .map((item) => DropdownMenuItem(value: item.planName ?? '', child: Text(item.planName.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack))))
                              .toList(),
                          selectedValue: dentalInsuranceController.insurancePlanList.any((element) => element.planName == dentalInsuranceController.selectedInsurancePlan.value.planName)
                              ? dentalInsuranceController.selectedInsurancePlan.value.planName ?? 0
                              : null,
                          dropdownTitle: '$selectYour $linsuranceplan',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextfield(
                            readOnly: true,
                            hint: effectiveDate,
                            lable: effectiveDate,
                            controller: dentalInsuranceController.effectiveDateController.value,
                            ontap: () {
                              effectiveDateDialog();
                            }),
                        const SizedBox(height: 25),
                        AppTextfield(
                          readOnly: true,
                          hint: expiredaate,
                          lable: expiredaate,
                          controller: dentalInsuranceController.expiryDateController.value,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: AppText(
                        text: uploadDocumentUpTo10,
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    dentalInsuranceController.photoDoc.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectPhotosDocument();
                            },
                            child: ImageUploadWidget(txt: addDocumentsPhotos, borderColor: skyBlueShade2, isLoading: dentalInsuranceController.isLoadingPhotoDoc.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: "I.D., Personal Photo, any other documents.",
                            selectedDocumentsImg: dentalInsuranceController.photoDoc,
                            removeDocumentFunction: (index) {
                              removePhotosImage(dentalInsuranceController.photoDoc[index]);
                            },
                            addDocumentFunction: () {
                              selectPhotosDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: dentalInsuranceController.isLoadingPhotoDoc.value,
                          ),
                    /* InkWell(
              onTap: () => widget.onNext(),
              child: Image.asset(nextImg),
            ),*/
                    AppBtnWithColorShades(
                      onTap: () {
                        if (dentalInsuranceController.selectedInsuranceLimit.value.limit == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectYourInsuranceLimit, txtColor: primaryWhite, size: 12)));
                        } else if (dentalInsuranceController.selectedInsurancePlan.value.planName == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectYourInsurancePlan, txtColor: primaryWhite, size: 12)));
                        } else if (dentalInsuranceController.effectiveDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEffectiveDate, txtColor: primaryWhite, size: 12)));
                        } else if (dentalInsuranceController.expiryDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
                        } else if (dentalInsuranceController.photoDoc.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDocuments, txtColor: primaryWhite, size: 12)));
                        } else {
                          widget.onNext();
                        }
                      },
                      btnTxt: "Next",
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                    SizedBox(height: 20), //
                    // Added space
                  ],
                ),
              ),
            );
    });
  }

  Future selectPhotosDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    dentalInsuranceController.isLoadingPhotoDoc.value = true;
    final pickedFile = await dentalInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 9);
      dentalInsuranceController.photoDoc.addAll(imagesUrl);
    }
    dentalInsuranceController.isLoadingPhotoDoc.value = false;
    setState(() {});
  }

  void removePhotosImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      dentalInsuranceController.photoDoc.remove(item);
    }
    setState(() {});
  }

  effectiveDateDialog() async {
    /*if (dentalInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (dentalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        dentalInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(dentalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        dentalInsuranceController.initialDate.value = dentalInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        dentalInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      dentalInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: dentalInsuranceController.initialDate.value, //get today's date
      firstDate: dentalInsuranceController.initialDate.value /*DateTime.now()*/, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      dentalInsuranceController.initialDate.value = pickedDate;
      setState(() {
        dentalInsuranceController.effectiveDateController.value.text = commonDateFormat(formattedDate);
        dentalInsuranceController.updateExpireDate(pickedDate);
      });
    } else {
      print("Date is not selected");
    }
  }
}
