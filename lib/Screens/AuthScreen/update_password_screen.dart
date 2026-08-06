import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/AuthController/auth_controller.dart';
import 'package:soperia_user/Screens/AuthScreen/login_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custome.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  AuthController authController = Get.put(AuthController());
  bool isPassShow = true;
  bool isPassShowConfirm = true;

  bool isChar6 = false;
  bool isSpecialChar = false;

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
        appBar: AppBar(),
        body: Obx(
          () {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 35,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage(splashImg)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AppText(
                          text: sis,
                          txtColor: Colors.blue.shade700,
                          size: 25,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AppText(text: resetPassword, size: 25, fontWeight: FontWeight.bold),
                          ],
                        ),
                        Row(
                          children: [
                            AppText(text: enterNewPassword, size: 15, maxLine: 2, fontWeight: FontWeight.w200),
                          ],
                        ),
                        const SizedBox(height: 18),
                        AppTextfield(
                            controller: authController.passwordController.value,
                            width: 15,
                            hint: createpassword,
                            lable: createpassword,
                            onChange: () {
                              checkPassword(authController.passwordController.value.text);
                            },
                            sufixicon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPassShow = !isPassShow;
                                  });
                                  print("object");
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
                        const SizedBox(height: 18),
                        AppTextfield(
                            controller: authController.reEnterPasswordController.value,
                            width: 15,
                            hint: confirmpassword,
                            lable: confirmpassword,
                            sufixicon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPassShowConfirm = !isPassShowConfirm;
                                  });
                                },
                                icon: Icon(!isPassShowConfirm ? Icons.visibility : Icons.visibility_off)),
                            obscureText: isPassShowConfirm),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                    child: AppBtnWithColorShades(
                      isLoad: authController.isLoadingForgotPassword.value,
                      onTap: () async {
                        await checkPassword(authController.passwordController.value.text);
                        if (authController.passwordController.value.text.isEmpty) {
                          showToast(pleaseEnterPassword, context);
                        } else if (authController.reEnterPasswordController.value.text.isEmpty) {
                          showToast(pleaseReEnterPassword, context);
                        } else if (!isChar6 || !isSpecialChar) {
                          showToast("$passwordrule or ${passwordalert.toLowerCase()}", context);
                        } else if (authController.passwordController.value.text != authController.reEnterPasswordController.value.text) {
                          showToast(passwordAndConformPasswordNotMatch, context);
                        } else {
                          authController.forgotPasswordPostApi(context);
                        }
                      },
                      btnTxt: continuE,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
