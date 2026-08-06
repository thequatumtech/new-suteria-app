import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Travel%20Insurance/travel_inurance_controller.dart';
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
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';

class TraveInsuranceFirstScreen extends StatefulWidget {
  Function onNext;

  TraveInsuranceFirstScreen({super.key, required this.onNext});

  @override
  State<TraveInsuranceFirstScreen> createState() => _TraveInsuranceFirstScreenState();
}

class _TraveInsuranceFirstScreenState extends State<TraveInsuranceFirstScreen> {
  TravelInsuranceController travelInsuranceController = Get.put(TravelInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    travelInsuranceController.init(context);
    if(!travelInsuranceController.isSelfType.value){
      deleteSelfData();
    }
    super.initState();
  }

  void deleteSelfData(){
    travelInsuranceController.memberFirstNameController.clear();
    travelInsuranceController.memberSecondNameController.clear();
    travelInsuranceController.memberThirdNameController.clear();
    travelInsuranceController.memberFamilyNameController.clear();
    travelInsuranceController.selectedRelation.clear();
    travelInsuranceController.selectNationalityMember.clear();
    travelInsuranceController.memberNationPassportNoController.clear();
    travelInsuranceController.memberIdOrResidenceNoController.clear();
    travelInsuranceController.memberBirthDateController.clear();
    travelInsuranceController.selectMemberGender.clear();
    travelInsuranceController.memberSelectPlaceResidence.clear();
    travelInsuranceController.selectedMembers.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return travelInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    readOnly: true,
                    hint: policyHolderFirstName,
                    lable: policyHolderFirstName,
                    controller: travelInsuranceController.policyHolderFirstNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    readOnly: true,
                    hint: policyHolderSecondName,
                    lable: policyHolderSecondName,
                    controller: travelInsuranceController.policyHolderSecondNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(
                    width: 10,
                    readOnly: true,
                    hint: policyHolderThirdName,
                    lable: policyHolderThirdName,
                    controller: travelInsuranceController.policyHolderThirdNameController.value,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: policyHolderFamilyName, lable: policyHolderFamilyName, controller: travelInsuranceController.policyHolderFamilyNameController.value),
                  const SizedBox(height: 10),

                  CustomDropDownBorderDisable(
                    onchage: (newValue) {
                      setState(() {
                        GetNationalityList cdl = travelInsuranceController.nationalityList.firstWhere((element) => element.id == newValue);
                        travelInsuranceController.selectNationality.value = cdl;
                      });
                    },
                    items: travelInsuranceController.nationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: travelInsuranceController.nationalityList.any((element) => element.id == travelInsuranceController.selectNationality.value.id) ? travelInsuranceController.selectNationality.value.id ?? 0 : null,
                    dropdownTitle: nationality,
                  ),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: nationalnopassport, lable: nationalnopassport, controller: travelInsuranceController.nationPassportNoController.value),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: residenceno, lable: residenceno, controller: travelInsuranceController.idOrResidenceNoController.value),
                  const SizedBox(height: 10),
                  AppTextfield(width: 10, readOnly: true, hint: birthdate, lable: birthdate, controller: travelInsuranceController.birthDateController.value),
                  const SizedBox(height: 10),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        travelInsuranceController.selectedGender = newValue!;
                      });
                    },
                    items: travelInsuranceController.genderList,
                    selectedValue: travelInsuranceController.selectedGender,
                    dropdownTitle: selectgender,
                  ),
                  CustomDropDownBorderStringDisable(
                    onchage: (newValue) {
                      setState(() {
                        travelInsuranceController.selectedMaritalStatus = newValue!;
                      });
                    },
                    items: travelInsuranceController.maritalStatusList,
                    selectedValue: travelInsuranceController.selectedMaritalStatus,
                    dropdownTitle: mrgstatus,
                  ),
                  CustomDropDownBorder1(
                    onchage: (newValue) {
                      setState(() {
                        GetCountryList cdl = travelInsuranceController.placeResidenceList.firstWhere((element) => element.id == newValue);
                        travelInsuranceController.selectPlaceResidence.value = cdl;
                      });
                    },
                    items: travelInsuranceController.placeResidenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                    selectedValue: travelInsuranceController.placeResidenceList.any((element) => element.id == travelInsuranceController.selectPlaceResidence.value.id) ? travelInsuranceController.selectPlaceResidence.value.id ?? 0 : null,
                    dropdownTitle: placeofresidence,
                  ),
                  travelInsuranceController.selectedPassport.isEmpty
                      ? InkWell(
                          onTap: () {
                            selectPassportDocument();
                          },
                          child: ImageUploadWidget(txt: passport, borderColor: skyBlueShade2, isLoading: travelInsuranceController.isLoadingPassport.value))
                      : NewUploadDocumentsCommonScreen(
                          documentNameText: passportDocuments,
                          selectedDocumentsImg: travelInsuranceController.selectedPassport,
                          removeDocumentFunction: (index) {
                            removePassportDocuments(travelInsuranceController.selectedPassport[index]);
                          },
                          addDocumentFunction: () {
                            selectPassportDocument();
                          },
                          addDocText: addDocuments,
                          isLoading: travelInsuranceController.isLoadingPassport.value,
                        ),


                 if(!travelInsuranceController.isSelfType.value) for (int i = 0; i < travelInsuranceController.memberFirstNameController.length; i++)
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0,top: 10),
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: InkWell(
                              onTap: () {
                                travelInsuranceController.memberFirstNameController.removeAt(i);
                                travelInsuranceController.memberSecondNameController.removeAt(i);
                                travelInsuranceController.memberThirdNameController.removeAt(i);
                                travelInsuranceController.memberFamilyNameController.removeAt(i);
                                travelInsuranceController.selectedRelation.removeAt(i);
                                travelInsuranceController.selectNationalityMember.removeAt(i);
                                travelInsuranceController.memberNationPassportNoController.removeAt(i);
                                travelInsuranceController.memberIdOrResidenceNoController.removeAt(i);
                                travelInsuranceController.memberBirthDateController.removeAt(i);
                                travelInsuranceController.selectMemberGender.removeAt(i);
                                travelInsuranceController.memberSelectPlaceResidence.removeAt(i);
                                travelInsuranceController.selectedMembers.removeAt(i);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(border: Border.all(color: skyBlueShade1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                child: const Icon(Icons.remove_outlined, color: skyBlueShade1),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: AppText(
                            text: "$member ${i + 1} $detail",
                            size: 16,
                            fontWeight: FontWeight.bold,
                            txtAlign: TextAlign.start,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextfield(width: 10, hint: memberFirstName, lable: memberFirstName, controller: travelInsuranceController.memberFirstNameController[i]),
                              const SizedBox(height: 10),
                              AppTextfield(width: 10, hint: memberSecondName, lable: memberSecondName, controller: travelInsuranceController.memberSecondNameController[i]),
                              const SizedBox(height: 10),
                              AppTextfield(width: 10, hint:memberThirdName, lable: memberThirdName, controller: travelInsuranceController.memberThirdNameController[i]),
                              const SizedBox(height: 10),
                              AppTextfield(width: 10, hint: memberFamilyName, lable: memberFamilyName, controller: travelInsuranceController.memberFamilyNameController[i]),
                              const SizedBox(height: 10),
                              CustomDropDownBorder(
                                onchage: (newValue) {
                                  travelInsuranceController.selectedRelation[i] = newValue;
                                  print(travelInsuranceController.selectedRelation);
                                  setState(() {});
                                },
                                items: const [wife, husband, son, daughter,mother,grandFather,grandMother,niece,nephew,grandSon,grandDaughter,brother,sister],
                                selectedValue: travelInsuranceController.selectedRelation[i],
                                dropdownTitle: selectrelation,
                              ),
                              const SizedBox(height: 10),

                              CustomDropDownBorder1(
                                dropdownTitle: selectNationality,
                                onchage: (newValue) {
                                  setState(() {
                                    try {
                                      GetNationalityList cdl = travelInsuranceController.getNationalityList.firstWhere((element) => element.id == newValue);
                                      travelInsuranceController.selectNationalityMember[i] = cdl;
                                    } catch (e) {
                                      print(e);
                                    }
                                  });
                                },
                                items: travelInsuranceController.getNationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: travelInsuranceController.getNationalityList.any((element) => element.id == travelInsuranceController.selectNationalityMember[i].id) ? travelInsuranceController.selectNationalityMember[i].id ?? 0 : null,
                              ),
                              const SizedBox(height: 10),
                              AppTextfield(width: 10, hint: nationalnopassport, lable: nationalnopassport, controller: travelInsuranceController.memberNationPassportNoController[i]),
                              const SizedBox(height: 10),
                              AppTextfield(width: 10, hint: residenceno, lable: residenceno, controller: travelInsuranceController.memberIdOrResidenceNoController[i]),
                              const SizedBox(height: 10),
                              AppTextfield(
                                  width: 10,
                                  hint: birthdate,
                                  lable: birthdate,
                                  controller: travelInsuranceController.memberBirthDateController[i],
                                  readOnly: true,
                                  ontap: () {
                                    memberBirthDateDialog(i);
                                  }),
                              const SizedBox(height: 10),
                              CustomDropDownBorder(
                                onchage: (newValue) {
                                  setState(() {
                                    travelInsuranceController.selectMemberGender[i] = newValue!;
                                  });
                                },
                                items: const [male, female],
                                selectedValue: travelInsuranceController.selectMemberGender[i],
                                dropdownTitle: selectgender,
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownBorder1(
                                onchage: (newValue) {
                                  setState(() {
                                    GetCountryList cdl = travelInsuranceController.placeResidenceList.firstWhere((element) => element.id == newValue);
                                    travelInsuranceController.memberSelectPlaceResidence[i] = cdl;
                                  });
                                },
                                items: travelInsuranceController.placeResidenceList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                                selectedValue: travelInsuranceController.placeResidenceList.any((element) => element.id == travelInsuranceController.memberSelectPlaceResidence[i].id) ? travelInsuranceController.memberSelectPlaceResidence[i].id ?? 0 : null,
                                dropdownTitle: placeofresidence,
                              ),
                              const SizedBox(height: 10),
                              travelInsuranceController.selectedMembers[i].isEmpty
                                  ? InkWell(
                                  onTap: () {
                                    selectMemberDocument(i);
                                  },
                                  child: ImageUploadWidget(txt: passport, borderColor: skyBlueShade2, isLoading: travelInsuranceController.isLoadingMembers.value))
                                  : NewUploadDocumentsCommonScreen(
                                documentNameText: memberDocuments,
                                selectedDocumentsImg: travelInsuranceController.selectedMembers[i],
                                removeDocumentFunction: (index) {
                                  removeMemberDocuments(travelInsuranceController.selectedMembers[i][index], i);
                                },
                                addDocumentFunction: () {
                                  selectMemberDocument(i);
                                },
                                addDocText: addDocuments,
                                isLoading: travelInsuranceController.isLoadingMembers.value,
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),

                  const SizedBox(height: 10),
                  !travelInsuranceController.isSelfType.value? InkWell(
                    onTap: () {
                      setState(() {
                        // travelInsuranceController.addDetails++;
                        travelInsuranceController.memberFirstNameController.add(TextEditingController());
                        travelInsuranceController.memberSecondNameController.add(TextEditingController());
                        travelInsuranceController.memberThirdNameController.add(TextEditingController());
                        travelInsuranceController.memberFamilyNameController.add(TextEditingController());
                        travelInsuranceController.selectedRelation.add(wife);
                        travelInsuranceController.selectNationalityMember.add(GetNationalityList());
                        travelInsuranceController.memberNationPassportNoController.add(TextEditingController());
                        travelInsuranceController.memberIdOrResidenceNoController.add(TextEditingController());
                        travelInsuranceController.memberBirthDateController.add(TextEditingController());
                        travelInsuranceController.selectMemberGender.add(male);
                        travelInsuranceController.memberSelectPlaceResidence.add(GetCountryList());
                        travelInsuranceController.selectedMembers.add([]);
                      });
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: AppText(
                        text: addAnotherMember,
                        fontWeight: FontWeight.bold,
                        size: 15,
                      )),
                    ),
                  ):const SizedBox(),
                  const SizedBox(height: 20),
                  AppBtnWithColorShades(
                    onTap: () {
                      if (memberValidation()) {

                      } else if (travelInsuranceController.selectedPassport.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectPassportDocuments, txtColor: primaryWhite, size: 12)));
                      } else {
                        widget.onNext();
                      }
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                ],
              ),
            );
    });
  }

  Future selectPassportDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    travelInsuranceController.isLoadingPassport.value = true;
    final pickedFile = await travelInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 10);
      travelInsuranceController.selectedPassport.addAll(imagesUrl);
    }
    travelInsuranceController.isLoadingPassport.value = false;
    setState(() {});
  }

  void removePassportDocuments(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      travelInsuranceController.selectedPassport.remove(item);
    }
    setState(() {});
  }

  Future selectMemberDocument(int index) async {
    RxList<String> selectedImg = <String>[].obs;
    travelInsuranceController.isLoadingMembers.value = true;
    final pickedFile = await travelInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 10);
      travelInsuranceController.selectedMembers[index].addAll(imagesUrl);
    }
    travelInsuranceController.isLoadingMembers.value = false;
    setState(() {});
  }

  void removeMemberDocuments(String item, int index) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      travelInsuranceController.selectedMembers[index].remove(item);
    }
    setState(() {});
  }

  bool memberValidation() {
    // if (travelInsuranceController.addDetails.value != 0) {
    if(!travelInsuranceController.isSelfType.value){
      for (int i = 0; i < travelInsuranceController.memberFirstNameController.length; i++) {
        if (travelInsuranceController.memberFirstNameController[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMembersFirstName, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.memberSecondNameController[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMembersSecondName, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.memberThirdNameController[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMembersThirdName, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.memberFamilyNameController[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMembersFamilyName, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.selectedRelation[i].isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: AppText(text: pleaseSelectRelation, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.selectNationalityMember[i].id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMemberNationality, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.memberNationPassportNoController[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: AppText(text: pleaseEnterMembersNationalOrPassportNo, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.memberIdOrResidenceNoController[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMembersIdOrResidenceNo, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.memberBirthDateController[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMembersBirthDate, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.selectMemberGender[i].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseSelectMembersGender, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.memberSelectPlaceResidence[i].id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseEnterMemberPlaceOfResidence, txtColor: primaryWhite, size: 12)));
          return true;
        } else if (travelInsuranceController.selectedMembers[i].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: pleaseSelectMemberDocuments, txtColor: primaryWhite, size: 12)));
          return true;
        }
      }
    }
    // }
    return false;
  }

  memberBirthDateDialog(int i) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(1901), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

      travelInsuranceController.memberBirthDateController[i].text = commonDateFormat(formattedDate); //set foratted date to TextField value.
      setState(() {});
    } else {
      print("Date is not selected");
    }
  }
}
