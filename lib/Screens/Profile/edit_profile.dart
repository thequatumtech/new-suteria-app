import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Profile/work_detail_profile_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';
import 'package:soperia_user/model_class/get_occupation_modelClass.dart';

import 'package:soperia_user/app_utils/utils.dart';

import 'profile_controller/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    // profileController.getNationalityApi(context);
    profileController.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(editprofile)),
      body: Obx(
        () => profileController.isLoadingEdit.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /*  DropdownButtonFormField(
                        value: editProfileController.selectLanguage,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        hint: Text('Select language'),
                        onChanged: (newValue) {
                          setState(() {
                            editProfileController.selectLanguage.value = newValue.toString()!;
                          });
                        },
                        items: ['English', 'Arbic']
                            .map((gender) => DropdownMenuItem(
                                  child: Text(gender, style: TextStyle(color: primaryGrey)),
                                  value: gender,
                                ))
                            .toList(),
                      ),*/
                            CustomDropDownBorder(
                              hintText: selectLanguage,
                              onchage: (newValue) {
                                setState(() {
                                  profileController.selectLanguage = newValue;
                                  String code = (newValue == 'Arabic' || newValue == arbic) ? 'ar' : 'en';
                                  profileController.changeLanguage(code, context);
                                });
                              },
                              items: profileController.languages,
                              selectedValue: profileController.selectLanguage,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            AppTextfield(
                              width: 15,
                              hint: firstname,
                              lable: firstname,
                              controller: profileController.firstNameController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(width: 15, hint: secondname, lable: secondname, controller: profileController.secondNameController.value),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 15,
                              hint: thirdname,
                              lable: thirdname,
                              controller: profileController.thirdNameController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(width: 15, hint: familyname, lable: familyname, controller: profileController.familyNameController.value),
                            const SizedBox(height: 10),
                            CustomDropDownBorder1(
                              dropdownTitle: selectNationality,
                              onchage: (newValue) {
                                setState(() {
                                  GetNationalityList cdl = profileController.getNationalityList.firstWhere((element) => element.id == newValue);
                                  profileController.selectNationality.value = cdl;
                                  // profileController.selectNationality = newValue;
                                });
                              },
                              items: profileController.getNationalityList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                              selectedValue: profileController.getNationalityList.any((element) => element.id == profileController.selectNationality.value.id) ? profileController.selectNationality.value.id ?? 0 : null,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 15,
                              hint: nationalNumberPassportNumber,
                              lable: nationalNumberPassportNumber,
                              controller: profileController.nationOrPassportNumberController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                              width: 15,
                              hint: residenceno,
                              lable: residenceno,
                              controller: profileController.idOrResidenceNumberController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(
                                width: 10,
                                readOnly: true,
                                hint: birthdate,
                                lable: birthdate,
                                controller: profileController.birthDateController.value,
                                ontap: () {
                                  startDateDialog();
                                }),
                            CustomDropDownBorder(
                              dropdownTitle: selectgender,
                              onchage: (newValue) {
                                setState(() {
                                  profileController.selectedGender = newValue!;
                                });
                              },
                              items: const [male, female],
                              selectedValue: profileController.selectedGender,
                            ),
                            CustomDropDownBorder1(
                              onchage: (newValue) {
                                setState(() {
                                  OccuptionList cdl = profileController.occupationList.firstWhere((element) => element.id == newValue);
                                  profileController.selectOccupation.value = cdl;
                                });
                              },
                              items: profileController.occupationList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                              selectedValue: profileController.occupationList.any((element) => element.id == profileController.selectOccupation.value.id) ? profileController.selectOccupation.value.id ?? 0 : null,
                              dropdownTitle: occupancy,
                            ),

                            CustomDropDownBorder(
                              onchage: (newValue) {
                                setState(() {
                                  profileController.selectedMaritalStatus = newValue!;
                                });
                              },
                              items: const [single, married, divorced, widowed],
                              selectedValue: profileController.selectedMaritalStatus,
                              dropdownTitle: mrgstatus,
                            ),
                            const SizedBox(height: 20), // Added space
                            AppTextfield(
                              width: 15,
                              hint: email,
                              lable: email,
                              controller: profileController.emailController.value,
                            ),
                            const SizedBox(height: 10),
                            AppTextfield(width: 15, maxLength: 10, hint: mobileNumber, lable: mobileNumber, controller: profileController.mobileController.value, keyboardType: TextInputType.phone),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                        child: Column(
                          children: [
                            AppBtnWithColorShades(
                              onTap: () {
                                if (profileController.selectLanguage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseSelectLanguage,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.firstNameController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseEnterYourFirstName,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.secondNameController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseEnterYourSecondName,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.thirdNameController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseEnterYourThirdName,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.familyNameController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseEnterYourFamilyName,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.selectNationality.value.id == 0 || profileController.selectNationality.value.id == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseSelectNationality,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.nationOrPassportNumberController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseEnterNationORPassportNo,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.idOrResidenceNumberController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseEnterIDORResidenceNo,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.birthDateController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseSelectYourBirthday,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.selectedGender == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseSelectGender,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else if (profileController.selectedMaritalStatus == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseSelectMaritalStatus,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                 } else if (profileController.emailController.value.text.trim().isEmpty) {
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                       content: AppText(
                                     text: pleaseEnterYourEmailID,
                                     txtColor: primaryWhite,
                                     size: 12,
                                   )));
                                 } else if (!Utils.isValidEmail(profileController.emailController.value.text)) {
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                       content: AppText(
                                     text: pleaseEnterValidEmailId,
                                     txtColor: primaryWhite,
                                     size: 12,
                                   )));
                                 } else if (profileController.mobileController.value.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: AppText(
                                    text: pleaseEnterYourMobileNo,
                                    txtColor: primaryWhite,
                                    size: 12,
                                  )));
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkDetailProfileScreen()));
                                }
                              },
                              btnTxt: saveNext,
                              color1: darkBlue2,
                              color2: darkBlue1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  startDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1901),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      /* String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        editProfileController.birthDateController.value.text = formattedDate;
      });*/

      if (_calculateAge(pickedDate) < 18) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(ageValidation),
              content: const Text(youMustBeAtLeast18YearsOld),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(ok),
                ),
              ],
            );
          },
        );
      } else {
        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        setState(() {
          profileController.birthDateController.value.text = formattedDate;
        });
      }
    } else {
      print("Date is not selected");
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    return now.year - birthDate.year - ((now.month > birthDate.month || (now.month == birthDate.month && now.day >= birthDate.day)) ? 0 : 1);
  }
}
