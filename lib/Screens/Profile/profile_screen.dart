import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/change_password_in_app/change_password_view.dart';
import 'package:soperia_user/Screens/Profile/Complaint/complaint_screen.dart';
import 'package:soperia_user/Screens/Profile/Contact%20Us/contact_us_message_screen.dart';
import 'package:soperia_user/Screens/Profile/Social%20Media/social_media_list_screen.dart';
import 'package:soperia_user/Screens/Profile/edit_profile.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
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
                            SizedBox(width: 10),
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
                              }else if (profileController.menu[index] == termsConditions) {
                                //Add commentMore actions
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyScreen(
                                    url: 'https://www.sisirbc.com/terms-conditions.php', title: termsConditions,
                                  ),
                                ),
                              );
                              }
                              else if (profileController.menu[index] == privacyPolicyTxt) {
                                //Add commentMore actions
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyScreen(
                                    url: 'https://www.sisirbc.com/privacy-policy.php', title: privacyPolicyTxt,
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
