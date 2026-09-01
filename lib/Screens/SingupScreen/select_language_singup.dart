import 'package:flutter/material.dart';
import 'package:soperia_user/Screens/AuthScreen/login_screen.dart';
import 'package:soperia_user/Screens/SingupScreen/mobileregester_singup.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

class SingupSelectLanguage extends StatefulWidget {
  const SingupSelectLanguage({super.key});

  @override
  State<SingupSelectLanguage> createState() => _SingupSelectLanguageState();
}

class _SingupSelectLanguageState extends State<SingupSelectLanguage> {
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
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppText(text: selectYour, size: 25, fontWeight: FontWeight.bold),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(text: language, size: 25, fontWeight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AppTextfield(
                  width: 10,
                  hint: "",
                  lable: findlanguage,
                  prefixicon: Icons.search,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: yellowShade1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: AppText(text: arbic, size: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: yellowShade1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: AppText(text: english, size: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 60),
                child: Column(
                  children: [
                    /* InkWell(onTap: () =>
                   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),)),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(nextImg)),
                        ),
                      ),
                    ),*/
                    AppBtnWithColorShades(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      btnTxt: next,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                    InkWell(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MobileregisterScreen(),
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
