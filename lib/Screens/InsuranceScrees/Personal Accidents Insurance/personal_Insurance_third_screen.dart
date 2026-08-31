import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_insurance_controller.dart';
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
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_insurance_period_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class PersonalInsuranceThirdScreen extends StatefulWidget {
  Function onNext;

  PersonalInsuranceThirdScreen({super.key, required this.onNext});

  @override
  State<PersonalInsuranceThirdScreen> createState() => _PersonalInsuranceThirdScreenState();
}

class _PersonalInsuranceThirdScreenState extends State<PersonalInsuranceThirdScreen> {
  PersonalInsuranceController personalInsuranceController = Get.put(PersonalInsuranceController());
  ImageController imageController = Get.put(ImageController());

/*  @override
  void initState() {
    personalInsuranceController.init(context);
    super.initState();
  }*/

  void removeFirstImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      personalInsuranceController.documents1.remove(item);
    }
    setState(() {});
  }

  void removeSecondImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      personalInsuranceController.documents2.remove(item);
    }
    setState(() {});
  }

  void removeThirdImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      personalInsuranceController.documents3.remove(item);
    }
    setState(() {});
  }

  void removeFourImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      personalInsuranceController.documents4.remove(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => personalInsuranceController.isLoading.value
            ? const Padding(
                padding: EdgeInsets.only(top: 140),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* CustomDropDownBorder(
              onchage: (newValue) {
                setState(() {
                  personalInsuranceController.selectInsuranceAmount = newValue!;
                });
              },
              items: ['1000', '2000', '3000'],
              selectedValue: personalInsuranceController.selectInsuranceAmount,
              dropdownTitle: "Insurance Amount / Coverage amount",
            ),*/

                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        InsuranceLimitListData cdl = personalInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                        personalInsuranceController.selectedInsuranceLimit.value = cdl;
                      });
                    },
                    items: personalInsuranceController.insuranceLimitList
                        .map((e) => e.limit)
                        .where((e) => e != null && e!.trim().isNotEmpty)
                        .toSet() // remove duplicate planName
                        .map((name) => DropdownMenuItem(
                              value: name,
                              child: Text(name!, style: const TextStyle(fontSize: 15, color: primaryBlack)),
                            ))
                        .toList(),
                    /* items: personalInsuranceController.insuranceLimitList.map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  */
                    selectedValue: personalInsuranceController.insuranceLimitList.any((element) => element.limit == personalInsuranceController.selectedInsuranceLimit.value.limit)
                        ? personalInsuranceController.selectedInsuranceLimit.value.limit ?? 0
                        : null,
                    dropdownTitle: insuranceLimitCoverageAmount,
                  ),
                  SizedBox(height: 20),
                  AppText(text: anyDangerousActivities, size: 15),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: yesTxt,
                        groupValue: personalInsuranceController.selectedDangerousActivity,
                        onChanged: (value) {
                          setState(() {
                            personalInsuranceController.selectedDangerousActivity = value!;
                          });
                        },
                      ),
                      AppText(text: yesTxt),
                      Radio(
                        value: noTxt,
                        groupValue: personalInsuranceController.selectedDangerousActivity,
                        onChanged: (value) {
                          setState(() {
                            personalInsuranceController.selectedDangerousActivity = value!;
                          });
                        },
                      ),
                      AppText(text: noTxt),
                    ],
                  ),
                  personalInsuranceController.selectedDangerousActivity == yesTxt
                      ? MultiSelectDialogField<GetDangerousActivitiesList>(
                          items: personalInsuranceController.getDangerousActivitiesList.map((e) => MultiSelectItem<GetDangerousActivitiesList>(e, e.name ?? '')).toList(),
                          title: const Text(selectDangerousAc),
                          selectedColor: blueShade1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: blueShade1),
                          ),
                          buttonIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          buttonText: const Text(
                            selectDangerousAc,
                            style: TextStyle(fontSize: 16, color: primaryBlack),
                          ),
                          onConfirm: (List<GetDangerousActivitiesList> selectedValues) {
                            personalInsuranceController.selectedDangerousActivitiesList.value = selectedValues;
                          },
                          initialValue: personalInsuranceController.selectedDangerousActivitiesList.value,
                        )
                      : const SizedBox(),
                  SizedBox(height: 20),
                  AppTextfield(
                      readOnly: true,
                      hint: inceptiondate,
                      lable: inceptiondate,
                      controller: personalInsuranceController.inceptionDateController.value,
                      ontap: () {
                        startDateDialog();
                      }),
                  const SizedBox(height: 20),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        GetInsurancePeriod cdl = personalInsuranceController.insurancePeriodList.firstWhere((element) => element.id == newValue);
                        personalInsuranceController.selectInsurancePeriod.value = cdl;
                      });
                    },
                    items: personalInsuranceController.insurancePeriodList
                        .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack))))
                        .toList(),
                    selectedValue: personalInsuranceController.insurancePeriodList.any((element) => element.id == personalInsuranceController.selectInsurancePeriod.value.id)
                        ? personalInsuranceController.selectInsurancePeriod.value.id ?? 0
                        : null,
                    dropdownTitle: inceptionperiod,
                  ),
                  const SizedBox(height: 25),
                  AppTextfield(
                    controller: personalInsuranceController.occupancyController.value,
                    readOnly: true,
                    hint: occupancy,
                    lable: occupancy,
                    /*ontap: () {
                  startDateDialog();
                }*/
                  ),
                  const SizedBox(height: 25),
                  AppText(
                    text: uploaddocument,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  personalInsuranceController.documents1.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectFistMultipleImg();
                          },
                          child: ImageUploadWidget(txt: fontSideId, borderColor: skyBlueShade2, isLoading: personalInsuranceController.isLoadingDocuments1.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: firstDocument,
                          selectedDocumentsImg: personalInsuranceController.documents1,
                          removeDocumentFunction: (index) {
                            removeFirstImage(personalInsuranceController.documents1[index]);
                          },
                          addDocumentFunction: () {
                            selectFistMultipleImg();
                          },
                          addDocText: addDocuments,
                          isLoading: personalInsuranceController.isLoadingDocuments1.value,
                        ),
                  personalInsuranceController.documents2.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectSecondMultipleImg();
                          },
                          child: ImageUploadWidget(txt: backSideId, borderColor: skyBlueShade2, isLoading: personalInsuranceController.isLoadingDocuments2.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: secondDocument,
                          selectedDocumentsImg: personalInsuranceController.documents2,
                          removeDocumentFunction: (index) {
                            removeSecondImage(personalInsuranceController.documents2[index]);
                          },
                          addDocumentFunction: () {
                            selectSecondMultipleImg();
                          },
                          addDocText: addDocuments,
                          isLoading: personalInsuranceController.isLoadingDocuments2.value,
                        ),
                  personalInsuranceController.documents3.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectThirdMultipleImg();
                          },
                          child: ImageUploadWidget(txt: proofOfOccupation, borderColor: skyBlueShade2, isLoading: personalInsuranceController.isLoadingDocuments3.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: thirdDocument,
                          selectedDocumentsImg: personalInsuranceController.documents3,
                          removeDocumentFunction: (index) {
                            removeThirdImage(personalInsuranceController.documents3[index]);
                          },
                          addDocumentFunction: () {
                            selectThirdMultipleImg();
                          },
                          addDocText: addDocuments,
                          isLoading: personalInsuranceController.isLoadingDocuments3.value,
                        ),
                  personalInsuranceController.documents4.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectFourMultipleImg();
                          },
                          child: ImageUploadWidget(txt: additionalDocument, borderColor: skyBlueShade2, isLoading: personalInsuranceController.isLoadingDocuments4.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: thirdDocument,
                          selectedDocumentsImg: personalInsuranceController.documents4,
                          removeDocumentFunction: (index) {
                            removeFourImage(personalInsuranceController.documents4[index]);
                          },
                          addDocumentFunction: () {
                            selectFourMultipleImg();
                          },
                          addDocText: addDocuments,
                          isLoading: personalInsuranceController.isLoadingDocuments4.value,
                        ),
                  AppBtnWithColorShades(
                    onTap: () {
                      if (personalInsuranceController.selectedInsuranceLimit.value.limit == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceLimitCoverageAmount, txtColor: primaryWhite, size: 12)));
                      } else if (personalInsuranceController.selectedDangerousActivity == null || personalInsuranceController.selectedDangerousActivity!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesList, txtColor: primaryWhite, size: 12)));
                      } else if (personalInsuranceController.selectedDangerousActivity == yesTxt && personalInsuranceController.selectedDangerousActivitiesList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesOptions, txtColor: primaryWhite, size: 12)));
                      } else if (personalInsuranceController.inceptionDateController.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInceptionDate, txtColor: primaryWhite, size: 12)));
                      } else if (personalInsuranceController.selectInsurancePeriod.value.id == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsurancePeriod, txtColor: primaryWhite, size: 12)));
                      } else if (personalInsuranceController.documents1.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectFrontSideIdDocument, txtColor: primaryWhite, size: 12)));
                      } else if (personalInsuranceController.documents2.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectBackSideIdDocument, txtColor: primaryWhite, size: 12)));
                      } else if (personalInsuranceController.documents3.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectOccupationalDocument, txtColor: primaryWhite, size: 12)));
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
      ),
    );
  }

  Future selectFistMultipleImg() async {
    RxList<String> selectedImg = <String>[].obs;
    personalInsuranceController.isLoadingDocuments1.value = true;
    final pickedFile = await personalInsuranceController.picker1.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 5);
      personalInsuranceController.documents1.addAll(imagesUrl);
    }
    personalInsuranceController.isLoadingDocuments1.value = false;
    setState(() {});
  }

  Future selectSecondMultipleImg() async {
    RxList<String> selectedImg = <String>[].obs;
    personalInsuranceController.isLoadingDocuments2.value = true;
    final pickedFile = await personalInsuranceController.picker1.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 5);
      personalInsuranceController.documents2.addAll(imagesUrl);
    }
    personalInsuranceController.isLoadingDocuments2.value = false;
    setState(() {});
  }

  Future selectThirdMultipleImg() async {
    RxList<String> selectedImg = <String>[].obs;
    personalInsuranceController.isLoadingDocuments3.value = true;
    final pickedFile = await personalInsuranceController.picker1.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 5);
      personalInsuranceController.documents3.addAll(imagesUrl);
    }
    personalInsuranceController.isLoadingDocuments3.value = false;
    setState(() {});
  }

  Future selectFourMultipleImg() async {
    RxList<String> selectedImg = <String>[].obs;
    personalInsuranceController.isLoadingDocuments4.value = true;
    final pickedFile = await personalInsuranceController.picker1.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 5);
      personalInsuranceController.documents4.addAll(imagesUrl);
    }
    personalInsuranceController.isLoadingDocuments4.value = false;
    setState(() {});
  }

  startDateDialog() async {
    /*   if (personalInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (personalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        personalInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(personalInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        personalInsuranceController.initialDate.value = personalInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        personalInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      personalInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: personalInsuranceController.initialDate.value, //get today's date
      firstDate: personalInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      setState(() {
        personalInsuranceController.inceptionDateController.value.text = commonDateFormat(formattedDate); //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
