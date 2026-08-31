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
                Row(
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
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    AppText(text: welcome, size: 25, fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  children: [
                    AppText(text: note, size: 15, maxLine: 2, fontWeight: FontWeight.w200),
                  ],
                ),
                /*      const SizedBox(
                  height: 18,
                ),
                IntlPhoneField(
                  controller: loginController.phoneno,
                  decoration: InputDecoration(
                    hintText: entermobileno,
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                  ),
                  initialCountryCode: 'JO',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),*/
                /*AppText(
                  text: or,
                  size: 15,
                  fontWeight: FontWeight.bold,
                ),*/
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
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResetPasswordScreen()));
                      },
                      child: AppText(text: forgotPassword, size: 14),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
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
                            style: TextStyle(fontSize: 11),
                            TextSpan(children: [
                              TextSpan(
                                text: bySigningUpYouAgree,
                              ),
                              TextSpan(
                                  text: termsConditions,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PrivacyPolicyScreen(
                                            id: 5,
                                            url: 'https://www.sisirbc.com/terms-conditions.php',
                                            title: termsConditions,
                                          ),
                                        ),
                                      );
                                    },
                                  style: TextStyle(color: Colors.blue)),
                              TextSpan(text: and),
                              TextSpan(
                                  text: privacyPolicyTxt,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PrivacyPolicyScreen(
                                            id: 6,
                                            url: 'https://www.sisirbc.com/privacy-policy.php',
                                            title: privacyPolicyTxt,
                                          ),
                                        ),
                                      );
                                    },
                                  style: TextStyle(color: Colors.blue)),
                            ])),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => AppBtnWithColorShades(
                    onTap: () async {
                      /* if (loginController.phoneno.text == "" && loginController.emailController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "Please enter phoneno or Email",txtColor: primaryWhite,size: 12,)));
                      } else if (loginController.passwordController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:  "Please enter Password",txtColor: primaryWhite,size: 12,)));
                      }
                      else if (loginController.check.value==false) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text:  "Please Accept Terms and Conditions",txtColor: primaryWhite,size: 12,)));
                      }
                      else {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePageBottomNav()), (route) => false);
                      }*/
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
                /*   Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AppText(text: loginwith, size: 12, txtColor: primaryGreyShade3),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(google)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(fblogo)),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(applelogo)),
                      ),
                    ),
                  ],
                ),*/

                InkWell(
                  onTap:
                      () => /*Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileregisterScreen(),
                      ),
                       (route) => false),*/
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingupScreen(),
                              )),
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: donTHaveAnAccount, style: TextStyle(color: primaryGrey)),
                        TextSpan(text: singUp, style: TextStyle(color: blue500)),
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
