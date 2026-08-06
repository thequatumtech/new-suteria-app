
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_controller.dart';
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

class HomeScreensixeth extends StatefulWidget {
  Function onNext;

  HomeScreensixeth({super.key, required this.onNext});

  @override
  State<HomeScreensixeth> createState() => _HomeScreensixethState();
}

class _HomeScreensixethState extends State<HomeScreensixeth> {
  HomeInsuranceController homeInsuranceController = Get.put(HomeInsuranceController());
  ImageController imageController = Get.put(ImageController());

  String? selectdistrict;
  String? selectddistrict;
  TextEditingController startDateController = TextEditingController();

  @override
  void initState() {
    homeInsuranceController.getInsuranceLimit(context, '1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return homeInsuranceController.isLoading.value
          ? const Padding(
        padding: EdgeInsets.only(top: 140),
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
                        InsuranceLimitListData cdl = homeInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                        homeInsuranceController.selectedInsuranceLimit.value = cdl;
                        homeInsuranceController.insurancePlanList.clear();
                        homeInsuranceController.insurancePlanList.addAll(cdl.planName ?? []);
                      });
                    },
                    items: homeInsuranceController.insuranceLimitList
                        .map((e) => e.limit)
                        .where((e) => e != null && e!.trim().isNotEmpty)
                        .toSet()  // remove duplicate planName
                        .map((name) => DropdownMenuItem(
                      value: name,
                      child: Text(name!, style: const TextStyle(fontSize: 15, color: primaryBlack)),
                    ))
                        .toList(),
                    /* items: homeInsuranceController.insuranceLimitList.map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  */  selectedValue: homeInsuranceController.insuranceLimitList.any((element) => element.limit == homeInsuranceController.selectedInsuranceLimit.value.limit) ? homeInsuranceController.selectedInsuranceLimit.value.limit ?? 0 : null,
                    dropdownTitle: insuranceLimitCoverageAmount,
                  ),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        PlanName cdl = homeInsuranceController.insurancePlanList.firstWhere((element) => element.planName == newValue);
                        homeInsuranceController.selectedInsurancePlan.value = cdl;
                      });
                    },
                    items: homeInsuranceController.insurancePlanList.map((item) => DropdownMenuItem(value: item.planName ?? '', child: Text(item.planName.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: homeInsuranceController.insurancePlanList.any((element) => element.planName == homeInsuranceController.selectedInsurancePlan.value.planName) ? homeInsuranceController.selectedInsurancePlan.value.planName ?? 0 : null,
                    dropdownTitle: linsuranceplan,
                  ),
                  AppTextfield(
                      readOnly: true,
                      hint: effectivedaate,
                      lable: effectivedaate,
                      controller: homeInsuranceController.effectiveDateController.value,
                      ontap: () {
                        effectiveDateDialog();
                      }),
                  const SizedBox(height: 20),
                  AppTextfield(
                      readOnly: true,
                      hint: expiredaate,
                      lable: expiredaate,
                      controller: homeInsuranceController.expiryDateController.value,
                      ontap: () {
                        // expiryDateDialog();
                      }),
                  const SizedBox(height: 25),
                  AppText(
                    text: uploaddocument,
                    size: 16,
                    fontWeight: FontWeight.bold,
                    txtColor: deepBluedark,
                  ),
                  Row(
                    children: [
                      Image.asset(uploadlogo, height: 28, width: 28),
                      const SizedBox(
                        width: 8,
                      ),
                      AppText(text: uploadPhotosUpTo20, size: 14),
                    ],
                  ),
                  homeInsuranceController.rentContractDoc.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectFistMultipleImg();
                          },
                          child: ImageUploadWidget(txt: documentOfTheRentContractOwnership, borderColor: skyBlueShade2, isLoading: homeInsuranceController.isLoadingRentContractDoc.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: rentDocument,
                          selectedDocumentsImg: homeInsuranceController.rentContractDoc,
                          removeDocumentFunction: (index) {
                            removeRentImage(homeInsuranceController.rentContractDoc[index]);
                          },
                          addDocumentFunction: () {
                            selectFistMultipleImg();
                          },
                          addDocText: addDocuments,
                          isLoading: homeInsuranceController.isLoadingRentContractDoc.value,
                        ),
                  homeInsuranceController.propertyDoc.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectSecondMultipleImg();
                          },
                          child: ImageUploadWidget(txt: photosOfTheProperty, borderColor: skyBlueShade2, isLoading: homeInsuranceController.isLoadingPropertyDoc.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: propertyDocument,
                          selectedDocumentsImg: homeInsuranceController.propertyDoc,
                          removeDocumentFunction: (index) {
                            removePropertyImage(homeInsuranceController.propertyDoc[index]);
                          },
                          addDocumentFunction: () {
                            selectSecondMultipleImg();
                          },
                          addDocText: addDocuments,
                          isLoading: homeInsuranceController.isLoadingPropertyDoc.value,
                        ),
                  homeInsuranceController.contentsDoc.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectThirdMultipleImg();
                          },
                          child: ImageUploadWidget(txt: photosOfTheContents, borderColor: skyBlueShade2, isLoading: homeInsuranceController.isLoadingContentsDoc.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: contentDocument,
                          selectedDocumentsImg: homeInsuranceController.contentsDoc,
                          removeDocumentFunction: (index) {
                            removeContentImage(homeInsuranceController.contentsDoc[index]);
                          },
                          addDocumentFunction: () {
                            selectThirdMultipleImg();
                          },
                          addDocText: addDocuments,
                          isLoading: homeInsuranceController.isLoadingContentsDoc.value,
                        ),
                  AppBtnWithColorShades(
                    onTap: () {
                      if (homeInsuranceController.selectedInsuranceLimit.value.limit == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceLimitCoverageAmount, txtColor: primaryWhite, size: 12)));
                      } else if (homeInsuranceController.selectedInsurancePlan.value.planName == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsurancePlan, txtColor: primaryWhite, size: 12)));
                      } else if (homeInsuranceController.effectiveDateController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEffectiveDate, txtColor: primaryWhite, size: 12)));
                      } else if (homeInsuranceController.expiryDateController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
                      } else if (homeInsuranceController.rentContractDoc.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: documentOfTheRentContractOwnershipAnyDocuments, txtColor: primaryWhite, size: 12)));
                      } else if (homeInsuranceController.propertyDoc.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: photosOfThePropertyAnyDocuments, txtColor: primaryWhite, size: 12)));
                      } else if (homeInsuranceController.contentsDoc.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: photosOfTheContentsAnyDocuments, txtColor: primaryWhite, size: 12)));
                      }
                      /*else if(homeInsuranceController.selectedImages.length<20){
showToast("Upload Photos: (Up to 20)", context);
              }*/
                      else {
                        //   homeInsuranceController.postHomeInsurance(context);
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

  effectiveDateDialog() async {
   /* if (homeInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (homeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        homeInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(homeInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        homeInsuranceController.initialDate.value = homeInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        homeInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      homeInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: homeInsuranceController.initialDate.value, //get today's date
      firstDate: homeInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      homeInsuranceController.initialDate.value=pickedDate;
      setState(() {
        homeInsuranceController.effectiveDateController.value.text = commonDateFormat(formattedDate);
        homeInsuranceController.expiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(pickedDate)).add(const Duration(days: 364)).toString())));
      });
    } else {
      print("Date is not selected");
    }
  }

  Future selectFistMultipleImg() async {
    RxList<String> selectedImg = <String>[].obs;
    homeInsuranceController.isLoadingRentContractDoc.value = true;
    final pickedFile = await homeInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 1);
      homeInsuranceController.rentContractDoc.addAll(imagesUrl);
    }
    homeInsuranceController.isLoadingRentContractDoc.value = false;
    setState(() {});
  }

  void removeRentImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      homeInsuranceController.rentContractDoc.remove(item);
    }
    setState(() {});
  }

  Future selectSecondMultipleImg() async {
    RxList<String> selectedImg = <String>[].obs;
    homeInsuranceController.isLoadingPropertyDoc.value = true;
    final pickedFile = await homeInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 1);
      homeInsuranceController.propertyDoc.addAll(imagesUrl);
    }
    homeInsuranceController.isLoadingPropertyDoc.value = false;
    setState(() {});
  }

  void removePropertyImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      homeInsuranceController.propertyDoc.remove(item);
    }
    setState(() {});
  }

  Future selectThirdMultipleImg() async {
    RxList<String> selectedImg = <String>[].obs;
    homeInsuranceController.isLoadingContentsDoc.value = true;
    final pickedFile = await homeInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 1);
      homeInsuranceController.contentsDoc.addAll(imagesUrl);
    }
    homeInsuranceController.isLoadingContentsDoc.value = false;
    setState(() {});
  }

  void removeContentImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      homeInsuranceController.contentsDoc.remove(item);
    }
    setState(() {});
  }
}
