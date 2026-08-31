import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/change_password_in_app/change_password_view.dart';
import 'package:soperia_user/Screens/HomeScreen/home_screen_bottom.dart';
import 'package:soperia_user/Screens/Profile/Complaint/complaint_screen.dart';
import 'package:soperia_user/Screens/Profile/Contact%20Us/contact_us_message_screen.dart';
import 'package:soperia_user/Screens/Profile/Social%20Media/social_media_list_screen.dart';
import 'package:soperia_user/Screens/Profile/edit_profile.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_constrint.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';
import '../../app_utils/Common Widgets/webview_title_url.dart';
import 'profile_controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.getProfile(context);
    super.initState();
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        String tempSelected = languageCode ?? 'en';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: grayshad200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: skyBlueShade4,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.language_rounded, color: deepBluedark, size: 22),
                            ),
                            const SizedBox(width: 12),
                            AppText(
                              text: chooseYourLanguage,
                              size: 16,
                              fontWeight: FontWeight.bold,
                              txtColor: deepBluedark,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: grayshad400, size: 20),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // English Option
                    _buildLanguageItem(
                      title: 'English',
                      subtitle: 'English',
                      code: 'en',
                      isSelected: tempSelected == 'en',
                      onTap: () {
                        setSheetState(() {
                          tempSelected = 'en';
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Arabic Option
                    _buildLanguageItem(
                      title: 'العربية',
                      subtitle: 'Arabic',
                      code: 'ar',
                      isSelected: tempSelected == 'ar',
                      onTap: () {
                        setSheetState(() {
                          tempSelected = 'ar';
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Confirm Button
                    AppBtnWithColorShades(
                      onTap: () async {
                        try {
                          await setLocale(tempSelected, context);
                        } catch (_) {}

                        if (!mounted) return;
                        Navigator.pop(sheetContext);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePageBottomNav(initialIndex: 2)),
                          (route) => false,
                        );
                      },
                      btnTxt: ok,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageItem({
    required String title,
    required String subtitle,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? deepBlue.withValues(alpha: 0.06) : grayshad100.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? deepBlue : primaryGreyShade,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
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
                  code == 'ar' ? 'ع' : 'EN',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? primaryWhite : deepBluedark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? deepBluedark : primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? deepBlue.withValues(alpha: 0.8) : primaryGrey,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? deepBlue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? deepBlue : primaryGreyShade,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: primaryWhite,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => profileController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        color: deepBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /* Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(image: const DecorationImage(image: AssetImage(sample)), borderRadius: BorderRadius.circular(100), border: Border.all(color: blue500)),
                      ),*/
                            Container(
                                height: 70,
                                width: 70,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: CachedNetworkImage(
                                        height: 70,
                                        width: 70,
                                        imageUrl: "$imgBaseUrl/${profileController.getProfileModel.value.data?.profilePic ?? ''}",
                                        // imageUrl: profileController.getProfileModel.value.data?.profilePic ?? '',
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        fit: BoxFit.cover))),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(text: profileController.getProfileModel.value.data?.firstName ?? "", size: 18, fontWeight: FontWeight.bold, txtColor: primaryWhite),
                                  AppText(text: profileController.getProfileModel.value.data?.emailId ?? "", size: 12, fontWeight: FontWeight.bold, txtColor: primaryWhite),
                                ],
                              ),
                            ),
                            InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())), child: const Icon(Icons.edit, color: primaryWhite, size: 24)),
                          ],
                        ),
                      ),
                      ListView.builder(
                        itemCount: profileController.menu.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              if (profileController.menu[index] == logout) {
                                profileController.logOutDialog(context);
                              } else if (index < 3) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => profileController.menuscreen[index]));
                              } else if (profileController.menu[index] == addcomplaints) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ComplaintScreen()));
                              } else if (profileController.menu[index] == contactus) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsMessageScreen()));
                              }else if (profileController.menu[index] == changePass) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
                              }else if (profileController.menu[index] == socialPages) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SocialMediaListScreen()));
                              } else if (profileController.menu[index] == chooseYourLanguage) {
                                _showLanguageBottomSheet(context);
                              } else if (profileController.menu[index] == termsConditions) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicyScreen(
                                      id: 5,
                                      title: termsConditions,
                                      url: 'https://www.sisirbc.com/terms-conditions.php',
                                    ),
                                  ),
                                );
                              } else if (profileController.menu[index] == privacyPolicyTxt) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicyScreen(
                                      id: 6,
                                      title: privacyPolicyTxt,
                                      url: 'https://www.sisirbc.com/privacy-policy.php',
                                    ),
                                  ),
                                );
                              } else if (profileController.menu[index] == refundAndCancellation) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicyScreen(
                                      id: 7,
                                      title: refundAndCancellation,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 42,
                                          width: 42,
                                          decoration: BoxDecoration(border: Border.all(color: gold), borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Image(
                                              image: AssetImage(
                                                profileController.icos[index],
                                              ), /*height: 28,width: 28,*/
                                            ),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 25, right: 10),
                                        child: AppText(text: profileController.menu[index], size: 16),
                                      ),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.chevron_right,
                                          size: 20,
                                          color: primaryGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: primaryGrey,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
