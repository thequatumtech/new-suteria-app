import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soperia_user/Screens/AuthScreen/otp_screen.dart';
import 'package:soperia_user/Screens/AuthScreen/select_language.dart';
import 'package:soperia_user/Screens/SingupScreen/sign_up_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custome.dart';
import 'package:soperia_user/language/language_constants.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  SignUpController signUpController = Get.put(SignUpController());

  bool isPassShow = true;
  bool isPassShowConfirm = true;

  bool isChar6 = false;
  bool isSpecialChar = false;
  bool _isNavigating = false;

  checkPassword(String value) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(value);
    if (value.length < 6) {
      isChar6 = false;
      setState(() {});
      print("too_short");
    } else {
      isChar6 = true;
      setState(() {});
    }
    if (value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      print("bad_char");

      isSpecialChar = true;
      setState(() {});
    } else {
      isSpecialChar = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        width: 35,
                        child: Icon(Icons.arrow_back, size: 25),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          text: createpassword,
                          size: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    AppText(
                      text: passwordnote,
                      size: 15,
                      maxLine: 2,
                      fontWeight: FontWeight.w200,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    AppTextfield(
                        controller: signUpController.password,
                        width: 15,
                        hint: createpassword,
                        lable: createpassword,
                        onChange: () {
                          checkPassword(signUpController.password.text);
                        },
                        sufixicon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPassShow = !isPassShow;
                              });
                            },
                            icon: Icon(!isPassShow ? Icons.visibility : Icons.visibility_off)),
                        obscureText: isPassShow),
                    Row(
                      children: [
                        isChar6
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(right))),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(alert))),
                                ),
                              ),
                        AppText(
                          text: passwordrule,
                          size: 15,
                          txtColor: isChar6 ? green : redshad500,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        isSpecialChar
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(right))),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(alert))),
                                ),
                              ),
                        AppText(
                          text: passwordalert,
                          size: 15,
                          txtColor: isSpecialChar ? green : redshad500,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextfield(
                        controller: signUpController.conformPassword,
                        width: 15,
                        hint: confirmpassword,
                        lable: confirmpassword,
                        sufixicon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPassShowConfirm = !isPassShowConfirm;
                              });
                              print("object");
                            },
                            icon: Icon(!isPassShowConfirm ? Icons.visibility : Icons.visibility_off)),
                        obscureText: isPassShowConfirm),
                  ],
                ),
              ),
              const SizedBox(
                height: 160,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    /* InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreenSingUp())),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(createaccImg)),
                        ),
                      ),
                    ),*/

                    Obx(
                      () => AppBtnWithColorShades(
                        onTap: () async {
                          if (_isNavigating) return;
                          await checkPassword(signUpController.password.text);
                          if (signUpController.password.text.isEmpty) {
                            showToast(pleaseEnterPassword, context);
                          } else if (signUpController.conformPassword.text.isEmpty) {
                            showToast(pleaseEnterConformPassword, context);
                          } else if (!isChar6 || !isSpecialChar) {
                            showToast("$passwordrule or ${passwordalert.toLowerCase()}", context);
                          } else if (signUpController.password.text != signUpController.conformPassword.text) {
                            showToast(passwordAndConformPasswordNotMatch, context);
                          } else {
                            _isNavigating = true;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(isFromSignup: true, mobileNo: signUpController.mobileController.value.text))).then((_) {
                              _isNavigating = false;
                            });
                          }
                        },
                        btnTxt: createAccount,
                        color1: darkBlue2,
                        color2: darkBlue1,
                        isLoad: signUpController.buttonLoading.value,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectLanguage(),
                          ),
                          (route) => false),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: getTranslated(context, passwordnotee).trim(), style: const TextStyle(color: primaryGrey, fontFamily: "Montserrat_Regular")),
                            const TextSpan(text: "  "),
                            TextSpan(text: getTranslated(context, login).trim(), style: const TextStyle(color: blue500, fontWeight: FontWeight.bold, fontFamily: "Montserrat_Regular")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
