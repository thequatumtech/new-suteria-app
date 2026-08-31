import 'package:flutter/material.dart';
import 'package:soperia_user/Screens/AuthScreen/login_screen.dart';
import 'package:soperia_user/Screens/SingupScreen/personal_detail_signup_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  bool check = false;
  bool isSelectEn = true;

  @override
  void initState() {
    super.initState();
    getLocale().then((code) {
      if (mounted) {
        setState(() {
          isSelectEn = (code != 'ar');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                  AppText(text: selectYour, size: 25, fontWeight: FontWeight.bold),
                ],
              ),
              Row(
                children: [
                  AppText(text: language, size: 25, fontWeight: FontWeight.bold),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectEn = false;
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: yellowShade1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        AppText(text: arbic, size: 15),
                        const Spacer(),
                        isSelectEn ? const SizedBox() : const Icon(Icons.check),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectEn = true;
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: yellowShade1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        AppText(text: english, size: 15),
                        const Spacer(),
                        !isSelectEn ? const SizedBox() : const Icon(Icons.check),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AppBtnWithColorShades(
                onTap: () async {
                  await setLocale(isSelectEn ? 'en' : 'ar', context);
                  if (!mounted) return;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                btnTxt: next,
                color1: darkBlue2,
                color2: darkBlue1,
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await setLocale(isSelectEn ? 'en' : 'ar', context);
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingupScreen(
                              isEng: isSelectEn,
                            )),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: donTHaveAnAccount, style: TextStyle(color: primaryGrey)),
                      TextSpan(text: singUp, style: TextStyle(color: blue500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
