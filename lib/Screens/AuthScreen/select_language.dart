import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/login_screen.dart';
import 'package:soperia_user/Screens/SingupScreen/personal_detail_signup_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/language/language_controller.dart';
import 'package:soperia_user/model_class/get_language_model.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  late final LanguageController _languageController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<LanguageController>()) {
      _languageController = Get.find<LanguageController>();
    } else {
      _languageController = Get.put(LanguageController());
    }
    _languageController.fetchLanguages(context);
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
              Expanded(
                child: Obx(() {
                  if (_languageController.isLoading.value && _languageController.languages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.separated(
                    itemCount: _languageController.languages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      LanguageData item = _languageController.languages[index];
                      bool isSelected = _languageController.selectedLanguageCode.value == item.code;

                      return InkWell(
                        onTap: () {
                          _languageController.changeLanguage(item, context);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? deepBlue : yellowShade1,
                              width: isSelected ? 1.8 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: isSelected ? deepBlue.withValues(alpha: 0.05) : Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: isSelected ? deepBlue : primaryWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? deepBlue : primaryGreyShade,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.shortLabel,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? primaryWhite : deepBluedark,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                AppText(
                                  text: item.displayName,
                                  size: 15,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                                const Spacer(),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: deepBlue, size: 22)
                                else
                                  const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              AppBtnWithColorShades(
                onTap: () async {
                  await _languageController.changeLanguageByCode(_languageController.selectedLanguageCode.value, context);
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
                  await _languageController.changeLanguageByCode(_languageController.selectedLanguageCode.value, context);
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingupScreen(
                        isEng: _languageController.selectedLanguageCode.value != 'ar',
                      ),
                    ),
                  );
                },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
