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
                      decoration: InputDecoration(
                        hintText: entermobileno,
                        border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
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
                                style: TextStyle(fontSize: 10),
                                TextSpan(children: [
                                  TextSpan(
                                    text: bySigningUpYouAgree,
                                  ),
                                TextSpan(text: termsConditions,
                                    recognizer:

                                    TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PrivacyPolicyScreen(
                                          url: 'https://www.sisirbc.com/terms-conditions.php', title: termsConditions,
                                        ),
                                      ),
                                    );
                                  },

                                style: const TextStyle(color: Colors.blue)),
                              const TextSpan(text: and),
                              TextSpan(text: privacyPolicyTxt,

                                  recognizer:

                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PrivacyPolicyScreen(
                                            url: 'https://www.sisirbc.com/privacy-policy.php', title: privacyPolicyTxt,
                                          ),
                                        ),
                                      );
                                    },
                                  style: const TextStyle(color: Colors.blue)),
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
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: passwordnotee, style: TextStyle(color: primaryGrey)),
                            TextSpan(text: login, style: TextStyle(color: blue500)),
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
