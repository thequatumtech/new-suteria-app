import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_controller.dart';
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

class PetInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  PetInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<PetInsuranceSecondScreen> createState() => _PetInsuranceSecondScreenState();
}

class _PetInsuranceSecondScreenState extends State<PetInsuranceSecondScreen> {
  PetInsuranceController petInsuranceController = Get.put(PetInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    petInsuranceController.apiMethod(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return petInsuranceController.isLoading.value
          ? const Padding(
              padding: EdgeInsets.only(top: 200),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextfield(
                      width: 10,
                      hint: petname,
                      lable: petname,
                      controller: petInsuranceController.petNameController.value,
                    ),
                    const SizedBox(height: 10),
                    AppTextfield(
                      width: 10,
                      hint: petbirthdate,
                      lable: petbirthdate,
                      ontap: petBirthDateDialog,
                      readOnly: true,
                      controller: petInsuranceController.petBirthDateController.value,
                    ),
                    const SizedBox(height: 10),
            
                    CustomDropDownBorder(
                      onchage: (newValue) {
                        setState(() {
                          petInsuranceController.selectGender = newValue!;
                        });
                      },
                      items: const [male, female],
                      selectedValue: petInsuranceController.selectGender,
                      dropdownTitle: selectPetgender,
                    ),
                    CustomDropDownBorder(
                      onchage: (newValue) {
                        setState(() {
                          petInsuranceController.selectBreed = newValue!;
                        });
                      },
                      items: const [pure, mixed],
                      selectedValue: petInsuranceController.selectBreed,
                      dropdownTitle: selectPettype,
                    ),
                    CustomDropDownBorder(
                      onchage: (newValue) {
                        setState(() {
                          petInsuranceController.selectedBreedName = newValue!;
                          petInsuranceController.petBreedNameController.value.text = newValue;
                        });
                      },
                      items: petInsuranceController.petBreedsList.map((e) => e.breed ?? '').where((b) => b.isNotEmpty).toList(),
                      selectedValue: petInsuranceController.selectedBreedName ?? (petInsuranceController.petBreedNameController.value.text.isNotEmpty ? petInsuranceController.petBreedNameController.value.text : null),
                      dropdownTitle: selectPetBreed,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(text: petq1, size: 15, txtAlign: TextAlign.start),
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: petInsuranceController.selectedPreExistingConditions,
                          onChanged: (value) {
                            setState(() {
                              petInsuranceController.selectedPreExistingConditions = value!;
                            });
                          },
                        ),
                        AppText(text: yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: petInsuranceController.selectedPreExistingConditions,
                          onChanged: (value) {
                            setState(() {
                              petInsuranceController.selectedPreExistingConditions = value!;
                            });
                          },
                        ),
                        AppText(text: noTxt),
                      ],
                    ),
                    if (petInsuranceController.selectedPreExistingConditions == yesTxt)
                      AppTextfield(
                        hint: pleaseWriteInDetailsThePreExistingConditionOfThePet,
                        lable: pleaseWriteInDetailsThePreExistingConditionOfThePet,
                        controller: petInsuranceController.preExistingController.value,
                      ),



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            InsuranceLimitListData cdl = petInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                            petInsuranceController.selectedInsuranceLimit.value = cdl;
                            petInsuranceController.insurancePlanList.clear();
                            petInsuranceController.insurancePlanList.addAll(cdl.planName ?? []);
                          },
                          items: petInsuranceController.insuranceLimitList.map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: petInsuranceController.insuranceLimitList.any((element) => element.limit == petInsuranceController.selectedInsuranceLimit.value.limit) ? petInsuranceController.selectedInsuranceLimit.value.limit ?? 0 : null,
                          dropdownTitle: '$selectYour $insurancelimit',
                        ),
                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              PlanName cdl = petInsuranceController.insurancePlanList.firstWhere((element) => element.planName == newValue);
                              petInsuranceController.selectedInsurancePlan.value = cdl;
                              petInsuranceController.updateExpireDate();
                            });
                          },
                          items: petInsuranceController.insurancePlanList.map((item) => DropdownMenuItem(value: item.planName ?? '', child: Text(item.planName.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                          selectedValue: petInsuranceController.insurancePlanList.any((element) => element.planName == petInsuranceController.selectedInsurancePlan.value.planName) ? petInsuranceController.selectedInsurancePlan.value.planName ?? 0 : null,
                          dropdownTitle: '$selectYour $linsuranceplan',
                        ),


                        
                        AppTextfield(
                            readOnly: true,
                            hint: inceptiondate,
                            lable: inceptiondate,
                            controller: petInsuranceController.inceptionDateController.value,
                            ontap: () {
                              inceptionDateDialog();
                            }),
                        const SizedBox(
                          height: 25,
                        ),
                        AppTextfield(
                            readOnly: true,
                            hint: expiredaate,
                            lable: expiredaate,
                            controller: petInsuranceController.expiryDateController.value,
                           ),
                      ],
                    ),
                    /* if (_selectedOption == 'No')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: insurancelimit,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: DropdownButtonFormField(
                      value: selectedpatientCoverageAmount,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                      hint: Text(inPatientDeductible),
                      onChanged: (newValue) {
                        setState(() {
                          selectedpatientCoverageAmount = newValue!;
                        });
                      },
                      items: ['Select', 'item1', 'item2', 'item3', 'item4']
                          .map((gender) => DropdownMenuItem(
                                child: Text(gender),
                                value: gender,
                              ))
                          .toList(),
                    ),
                  ),
                  AppText(
                    text: linsuranceplan,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: DropdownButtonFormField(
                      value: selectedpatientCoverageAmount,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                      hint: Text(inPatientDeductible),
                      onChanged: (newValue) {
                        setState(() {
                          selectedpatientCoverageAmount = newValue!;
                        });
                      },
                      items: ['Select', 'item1', 'item2', 'item3', 'item4']
                          .map((gender) => DropdownMenuItem(
                                child: Text(gender),
                                value: gender,
                              ))
                          .toList(),
                    ),
                  ),
                  AppTextfield(
                      readOnly: true,
                      hint: inceptiondate,
                      lable: inceptiondate,
                      controller: startDateController,
                      ontap: () {
                        startDateDialog();
                      }),
                  SizedBox(
                    height: 25,
                  ),
                  AppTextfield(
                      readOnly: true,
                      hint: expiredaate,
                      lable: expiredaate,
                      controller: startDateController,
                      ontap: () {
                        startDateDialog();
                      }),
                ],
              ),*/
                    const SizedBox(height: 20),
                    petInsuranceController.selectedVaccineDocuments.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectVaccineBookDocument();
                            },
                            child: ImageUploadWidget(txt: addVaccineBook, borderColor: skyBlueShade2, isLoading: petInsuranceController.isLoadingVaccineDocuments.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: vaccineDocuments,
                            selectedDocumentsImg: petInsuranceController.selectedVaccineDocuments,
                            removeDocumentFunction: (index) {
                              removeVaccineDocument(petInsuranceController.selectedVaccineDocuments[index]);
                            },
                            addDocumentFunction: () {
                              selectVaccineBookDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: petInsuranceController.isLoadingVaccineDocuments.value,
                          ),
                    petInsuranceController.selectedPetsImgDocuments.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectPetsImgDocument();
                            },
                            child: ImageUploadWidget(txt: addPetPicture, borderColor: skyBlueShade2, isLoading: petInsuranceController.isLoadingPetsImgDocuments.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: petsPicture,
                            selectedDocumentsImg: petInsuranceController.selectedPetsImgDocuments,
                            removeDocumentFunction: (index) {
                              removePetsImgDocument(petInsuranceController.selectedPetsImgDocuments[index]);
                            },
                            addDocumentFunction: () {
                              selectPetsImgDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: petInsuranceController.isLoadingPetsImgDocuments.value,
                          ),
                    petInsuranceController.selectedPetsPassportDocuments.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectPetsPassportDocument();
                            },
                            child: ImageUploadWidget(txt: addPetPassport, borderColor: skyBlueShade2, isLoading: petInsuranceController.isLoadingPetsPassportDocuments.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: petsPassportDocuments,
                            selectedDocumentsImg: petInsuranceController.selectedPetsPassportDocuments,
                            removeDocumentFunction: (index) {
                              removePetsPassportDocument(petInsuranceController.selectedPetsPassportDocuments[index]);
                            },
                            addDocumentFunction: () {
                              selectPetsPassportDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: petInsuranceController.isLoadingPetsPassportDocuments.value,
                          ),
                    petInsuranceController.selectedPetsPermitDocuments.isEmpty
                        ? InkWell(
                            onTap: () {
                              selectPetsPermitDocument();
                            },
                            child: ImageUploadWidget(txt: addPetPermit, borderColor: skyBlueShade2, isLoading: petInsuranceController.isLoadingPetsPermitDocuments.value))
                        : NewUploadDocumentsCommonScreen(
                            documentNameText: petsPermitDocuments,
                            selectedDocumentsImg: petInsuranceController.selectedPetsPermitDocuments,
                            removeDocumentFunction: (index) {
                              removePetsPermitDocument(petInsuranceController.selectedPetsPermitDocuments[index]);
                            },
                            addDocumentFunction: () {
                              selectPetsPermitDocument();
                            },
                            addDocText: addDocuments,
                            isLoading: petInsuranceController.isLoadingPetsPermitDocuments.value,
                          ),
                    AppBtnWithColorShades(
                      onTap: () {
                        if (petInsuranceController.petNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterYourPetName, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.petBirthDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterYourPetBirthDate, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.selectGender == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectGender, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.selectBreed == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectTypeOfPet, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.petBreedNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectPetBreed, txtColor: primaryWhite, size: 12)));
                        } else if (preExistingValidation()) {
                          print("object");
                        } else if (petInsuranceController.selectedInsuranceLimit.value.limit == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceLimit, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.selectedInsurancePlan.value.planName == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsurancePlan, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.inceptionDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInceptionDate, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.expiryDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.selectedVaccineDocuments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectVaccineBookDocuments, txtColor: primaryWhite, size: 12)));
                        } else if (petInsuranceController.selectedPetsImgDocuments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectPetsPicturesDocuments, txtColor: primaryWhite, size: 12)));
                        }
                        /*else if (petInsuranceController.selectedPetsPassportDocuments.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "Please select pets passport documents", txtColor: primaryWhite, size: 12)));
                } else if (petInsuranceController.selectedPetsPermitDocuments.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "Please select pets permit documents", txtColor: primaryWhite, size: 12)));
                }*/
                        else {
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
              ),
            );
    });
  }

  Future selectVaccineBookDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    petInsuranceController.isLoadingVaccineDocuments.value = true;
    final pickedFile = await petInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    setState(() {});
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 8);
      petInsuranceController.selectedVaccineDocuments.addAll(imagesUrl);
    }
    petInsuranceController.isLoadingVaccineDocuments.value = false;
    setState(() {});
  }

  void removeVaccineDocument(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      petInsuranceController.selectedVaccineDocuments.remove(item);
    }
    setState(() {});
  }

  Future selectPetsImgDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    petInsuranceController.isLoadingPetsImgDocuments.value = true;
    final pickedFile = await petInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 8);
      petInsuranceController.selectedPetsImgDocuments.addAll(imagesUrl);
    }
    petInsuranceController.isLoadingPetsImgDocuments.value = false;
    setState(() {});
  }

  void removePetsImgDocument(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      petInsuranceController.selectedPetsImgDocuments.remove(item);
    }
    setState(() {});
  }

  Future selectPetsPassportDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    petInsuranceController.isLoadingPetsPassportDocuments.value = true;
    final pickedFile = await petInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 8);
      petInsuranceController.selectedPetsPassportDocuments.addAll(imagesUrl);
    }
    petInsuranceController.isLoadingPetsPassportDocuments.value = false;
    setState(() {});
  }

  void removePetsPassportDocument(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      petInsuranceController.selectedPetsPassportDocuments.remove(item);
    }
    setState(() {});
  }

  Future selectPetsPermitDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    petInsuranceController.isLoadingPetsPermitDocuments.value = true;
    final pickedFile = await petInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 8);
      petInsuranceController.selectedPetsPermitDocuments.addAll(imagesUrl);
    }
    petInsuranceController.isLoadingPetsPermitDocuments.value = false;
    setState(() {});
  }

  void removePetsPermitDocument(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      petInsuranceController.selectedPetsPermitDocuments.remove(item);
    }
    setState(() {});
  }

  petBirthDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now().subtract(const Duration(days: 3 * 30)), //get today's date
      firstDate: DateTime.now().subtract(const Duration(days: 15 * 365)), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now().subtract(const Duration(days: 3 * 30)),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      setState(() {
        petInsuranceController.petBirthDateController.value.text = commonDateFormat(formattedDate); //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  inceptionDateDialog() async {
   /* if (petInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (petInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        petInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(petInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        petInsuranceController.initialDate.value = petInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        petInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      petInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: petInsuranceController.initialDate.value, //get today's date
      firstDate: petInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      print(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      petInsuranceController.inceptionDateController.value.text = commonDateFormat(formattedDate);
      petInsuranceController.updateExpireDate(pickedDate);
      setState(() {});
    } else {
      print("Date is not selected");
    }
  }

  bool preExistingValidation() {
    if (petInsuranceController.selectedPreExistingConditions == yesTxt) {
      if (petInsuranceController.preExistingController.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseWriteInDetailsThePreExistingConditionOfThePet, txtColor: primaryWhite, size: 12)));
        return true;
      }
      return false;
    }
    return false;
  }
}
