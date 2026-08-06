import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:soperia_user/Screens/SingupScreen/work_detail_signup_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/custome.dart';
import 'package:soperia_user/model_class/get_nationality_model.dart';

import 'sign_up_controller.dart';

class SingupScreen extends StatefulWidget {
  bool? isEng = true;

  SingupScreen({super.key, this.isEng});

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  void initState() {
    /* signUpController.postSignUp(context);*/
    // TODO: implement initState

    signUpController.init(context);
    signUpController.isEng = widget.isEng ?? true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Obx(() => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            height: 40,
                            width: 35,
                            child: Icon(Icons.arrow_back, size: 25),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        AppText(text: personaldetails, size: 25),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(text: know, size: 25, fontWeight: FontWeight.bold, txtAlign: TextAlign.center),
                        AppText(text: singupfrom, size: 15, maxLine: 2, fontWeight: FontWeight.w200, txtAlign: TextAlign.center),
                        const SizedBox(
                          height: 18,
                        ),

                        CustomDropDownBorder(
                          dropdownTitle: chooseYourLanguage,
                          onchage: (newValue) {
                            setState(() {
                              signUpController.selectLanguage = newValue!;
                            });
                          },
                          items: signUpController.languages,
                          selectedValue: signUpController.selectLanguage,
                        ),

                        AppTextfield(width: 15, hint: firstname, lable: firstname, controller: signUpController.firstNameController.value),
                        const SizedBox(height: 10),
                        AppTextfield(width: 15, hint: secondname, lable: secondname, controller: signUpController.secondNameController.value),
                        const SizedBox(height: 10),
                        AppTextfield(width: 15, hint: thirdname, lable: thirdname, controller: signUpController.thirdNameController.value),
                        const SizedBox(height: 10),
                        AppTextfield(width: 15, hint: familyname, lable: familyname, controller: signUpController.familyNameController.value),
                        const SizedBox(height: 10),
                        /* CustomDropDownBorder(
                      dropdownTitle: 'Select Nationality',
                      onchage: (newValue) {
                        setState(() {
                          signUpController.selectedNation = newValue!;
                        });
                      },
                      items: const ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'],
                      selectedValue: signUpController.selectedNation,
                    ),*/

                        CustomDropDownBorder1(
                          onchage: (newValue) {
                            setState(() {
                              GetNationalityList cdl = signUpController.nationalityList.firstWhere((element) => element.id == newValue);
                              signUpController.selectNationality.value = cdl;
                            });
                          },
                          items: signUpController.nationalityList
                              .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack))))
                              .toList(),
                          selectedValue:
                              signUpController.nationalityList.any((element) => element.id == signUpController.selectNationality.value.id) ? signUpController.selectNationality.value.id ?? 0 : null,
                          dropdownTitle: selectNationality,
                        ),

                        const SizedBox(height: 10),
                        AppTextfield(width: 15, hint: nationalNumberPassportNumber, lable: nationalNumberPassportNumber, controller: signUpController.nationOrPassportNumberController.value),
                        const SizedBox(height: 10),
                        AppTextfield(width: 15, hint: residenceno, lable: residenceno, controller: signUpController.idOrResidenceNumberController.value),
                        const SizedBox(height: 10),
                        AppTextfield(
                            width: 10,
                            readOnly: true,
                            hint: birthdate,
                            lable: birthdate,
                            controller: signUpController.birthDateController.value,
                            ontap: () {
                              startDateDialog();
                            }),

                        CustomDropDownBorder(
                          dropdownTitle: selectgender,
                          onchage: (newValue) {
                            setState(() {
                              signUpController.selectedGender = newValue!;
                            });
                          },
                          items: const [male, female],
                          selectedValue: signUpController.selectedGender,
                        ),

                        CustomDropDownBorder(
                          onchage: (newValue) {
                            setState(() {
                              signUpController.selectedMaritalStatus = newValue!;
                            });
                          },
                          items: const [single, married, divorced, widowed],
                          selectedValue: signUpController.selectedMaritalStatus,
                          dropdownTitle: mrgstatus,
                        ),
                        const SizedBox(height: 20), // Added space
                        AppTextfield(width: 15, hint: email, lable: email, controller: signUpController.emailController.value),
                        const SizedBox(height: 10),
                        IntlPhoneField(
                          controller: signUpController.mobileController.value,
                          decoration: InputDecoration(
                            hintText: entermobileno,
                            border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                          ),
                          initialCountryCode: 'JO',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: AppBtnWithColorShades(
                      onTap: () {
                        if (signUpController.selectLanguage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseSelectLanguage,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.firstNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterYourFirstName,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.secondNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterYourSecondName,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.thirdNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterYourThirdName,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.familyNameController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterYourFamilyName,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.selectNationality.value.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseSelectNationality,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.nationOrPassportNumberController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterNationORPassportNo,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.idOrResidenceNumberController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterIDORResidenceNo,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.birthDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseSelectYourBirthday,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.selectedGender == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseSelectGender,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.selectedMaritalStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseSelectMaritalStatus,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.emailController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterYourEmailID,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else if (signUpController.emailController.value.text.isNotEmpty &&
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(signUpController.emailController.value.text)) {
                          showToast(pleaseEnterValidEmailId, context);
                        } else if (signUpController.mobileController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                            text: pleaseEnterYourMobileNo,
                            txtColor: primaryWhite,
                            size: 12,
                          )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WorkDetailSingupScreen(),
                              ));
                        }
                      },
                      btnTxt: saveNext,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              )),
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
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        setState(() {
          signUpController.birthDateController.value.text = commonDateFormat(formattedDate);
        });
        // editProfileController.birthDateController.value.text = pickedDate.toString();
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
