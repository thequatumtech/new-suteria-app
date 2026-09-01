import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:soperia_user/Screens/AuthScreen/login_screen.dart';
import 'package:soperia_user/Screens/SingupScreen/personal_detail_signup_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

import '../../app_utils/Common Widgets/webview_title_url.dart';


class MobileregisterScreen extends StatefulWidget {
  const MobileregisterScreen({super.key});

  @override
  State<MobileregisterScreen> createState() => _MobileregisterScreenState();
}

class _MobileregisterScreenState extends State<MobileregisterScreen> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
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
                        AppText(text: welcome, size: 25, fontWeight: FontWeight.bold),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(text: createAnAccountToContinue, size: 15, maxLine: 2, fontWeight: FontWeight.w200),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    IntlPhoneField(
                      disableLengthCheck: true,
                      dropdownIconPosition: IconPosition.trailing,
                      invalidNumberMessage: getTranslated(context, invalidMobileNumber),
                      dropdownTextStyle: const TextStyle(fontSize: 14, fontFamily: "Montserrat_Regular"),
                      style: const TextStyle(fontSize: 14, fontFamily: "Montserrat_Regular"),
                      flagsButtonMargin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: primaryWhite,
                        hintText: getTranslated(context, entermobileno),
                        hintStyle: TextStyle(color: skyBlueShade3, fontSize: 14, fontFamily: "Montserrat_Regular"),
                        errorStyle: const TextStyle(fontSize: 12, fontFamily: "Montserrat_Regular"),
                        border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: skyBlueShade1), borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: skyBlueShade1), borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: skyBlueShade1), borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(width: 1, color: Colors.red), borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(width: 1, color: Colors.red), borderRadius: BorderRadius.circular(10)),
                      ),
                      initialCountryCode: 'JO',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    AppText(
                      text: or,
                      size: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: AppTextfield(hint: enterEmailId, lable: enterEmailId),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Row(
                        children: [
                          Checkbox(
                            value: check,
                            onChanged: (value) {
                              setState(() {
                                check = true;
                              });
                            },
                          ),
                          Expanded(
                              child: Text.rich(
                                  maxLines: 3,
                                  style: const TextStyle(fontSize: 10, fontFamily: "Montserrat_Regular"),
                                  TextSpan(children: [
                                    TextSpan(
                                      text: getTranslated(context, bySigningUpAgreeTo),
                                    ),
                                    TextSpan(text: getTranslated(context, termsConditions),
                                        recognizer:

                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PrivacyPolicyScreen(
                                                  id: 5,
                                                  url: 'https://www.sisirbc.com/terms-conditions.php', title: getTranslated(context, termsConditions),
                                                ),
                                              ),
                                            );
                                          },

                                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                    TextSpan(text: " ${getTranslated(context, and)} "),
                                    TextSpan(text: getTranslated(context, privacyPolicyTxt),

                                        recognizer:

                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PrivacyPolicyScreen(
                                                  id: 6,
                                                  url: 'https://www.sisirbc.com/privacy-policy.php', title: getTranslated(context, privacyPolicyTxt),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Column(
                  children: [
                    /*InkWell(
                      onTap: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingupScreen(),)),

                      child: Image.asset(buttonImg,
                        height: 100,

                      ),
                    ),*/
                    AppBtnWithColorShades(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingupScreen(),
                            ));
                      },
                      btnTxt: continuE,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: AppText(text: loginwith, size: 12, txtColor: primaryGreyShade3),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage(google)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage(fblogo)),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage(applelogo)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
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
