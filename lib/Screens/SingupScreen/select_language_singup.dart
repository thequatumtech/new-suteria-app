import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/login_screen.dart';
import 'package:soperia_user/Screens/SingupScreen/mobileregester_singup.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/language/language_controller.dart';

class SingupSelectLanguage extends StatefulWidget {
  const SingupSelectLanguage({super.key});

  @override
  State<SingupSelectLanguage> createState() => _SingupSelectLanguageState();
}

class _SingupSelectLanguageState extends State<SingupSelectLanguage> {
  late final LanguageController _languageController;
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = "".obs;

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  controller: _searchController,
                  onChange: (val) {
                    _searchQuery.value = val.toString();
                  },
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Obx(() {
                  final query = _searchQuery.value.trim().toLowerCase();
                  final list = _languageController.languages.where((l) {
                    if (query.isEmpty) return true;
                    return (l.name ?? '').toLowerCase().contains(query) || l.code.contains(query);
                  }).toList();

                  return Column(
                    children: list.map((item) {
                      bool isSelected = _languageController.selectedLanguageCode.value == item.code;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: InkWell(
                          onTap: () {
                            _languageController.changeLanguage(item, context);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
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
                                    width: 32,
                                    height: 32,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? primaryWhite : deepBluedark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AppText(
                                    text: item.displayName,
                                    size: 15,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  const Spacer(),
                                  if (isSelected)
                                    const Icon(Icons.check_circle_rounded, color: deepBlue, size: 22),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                child: Column(
                  children: [
                    AppBtnWithColorShades(
                      onTap: () async {
                        await _languageController.changeLanguageByCode(
                          _languageController.selectedLanguageCode.value,
                          context,
                        );
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
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
