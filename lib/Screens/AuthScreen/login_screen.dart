import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:soperia_user/Screens/AuthScreen/AuthController/logincontroller.dart';
import 'package:soperia_user/Screens/AuthScreen/reset_password_screen.dart';
import 'package:soperia_user/Screens/SingupScreen/personal_detail_signup_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/webview_title_url.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  bool isPassShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppText(text: welcome, size: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppText(text: note, size: 15, maxLine: 3, fontWeight: FontWeight.w300),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: AppTextfield(controller: loginController.emailController, hint: enterEmailId, lable: enterEmailId),
                ),
                const SizedBox(height: 12),
                AppTextfield(
                  controller: loginController.passwordController,
                  hint: enterPassword,
                  lable: enterPassword,
                  sufixicon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPassShow = !isPassShow;
                        });
                        print("object");
                      },
                      icon: Icon(!isPassShow ? Icons.visibility : Icons.visibility_off)),
                  obscureText: isPassShow,
                ),
                const SizedBox(height: 12),
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResetPasswordScreen()));
                      },
                      child: AppText(text: forgotPassword, size: 14),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: loginController.check.value,
                        onChanged: (value) {
                          setState(() {
                            loginController.check.value = value ?? true;
                          });
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                            maxLines: 3,
                            style: const TextStyle(fontSize: 11, fontFamily: "Montserrat_Regular"),
                            TextSpan(children: [
                              TextSpan(
                                text: getTranslated(context, bySigningUpAgreeTo),
                              ),
                              TextSpan(
                                  text: getTranslated(context, termsConditions),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PrivacyPolicyScreen(
                                            id: 5,
                                            url: 'https://www.sisirbc.com/terms-conditions.php',
                                            title: getTranslated(context, termsConditions),
                                          ),
                                        ),
                                      );
                                    },
                                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                              TextSpan(text: " ${getTranslated(context, and)} "),
                              TextSpan(
                                  text: getTranslated(context, privacyPolicyTxt),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PrivacyPolicyScreen(
                                            id: 6,
                                            url: 'https://www.sisirbc.com/privacy-policy.php',
                                            title: getTranslated(context, privacyPolicyTxt),
                                          ),
                                        ),
                                      );
                                    },
                                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                            ])),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => AppBtnWithColorShades(
                    onTap: () async {
                      if (!loginController.isLoadingButton.value) {
                        loginController.isLoading.value ? null : loginController.loginValidation(context);
                        loginController.isLoadingButton.value = true;
                        await Future.delayed(const Duration(seconds: 2));
                        loginController.isLoadingButton.value = false;
                      }
                    },
                    btnTxt: continuE,
                    color1: darkBlue2,
                    color2: darkBlue1,
                    isLoad: loginController.isLoading.value,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap:
                      () =>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingupScreen(),
                              )),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: getTranslated(context, donTHaveAnAccount).trim(),
                          style: const TextStyle(color: primaryGrey, fontFamily: "Montserrat_Regular"),
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(
                          text: getTranslated(context, singUp).trim(),
                          style: const TextStyle(color: blue500, fontWeight: FontWeight.bold, fontFamily: "Montserrat_Regular"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}
