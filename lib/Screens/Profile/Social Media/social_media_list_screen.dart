import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/Profile/Social%20Media/social_media_controller.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class SocialMediaListScreen extends StatefulWidget {
  const SocialMediaListScreen({super.key});

  @override
  State<SocialMediaListScreen> createState() => _SocialMediaListScreenState();
}

class _SocialMediaListScreenState extends State<SocialMediaListScreen> {
  SocialMediaController socialMediaController = Get.put(SocialMediaController());

  @override
  void initState() {
    socialMediaController.getSocialMediaApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(title: AppText(text: socialMedia, size: 18, fontWeight: FontWeight.bold)),
      body: Obx(() {
        return socialMediaController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : socialMediaController.socialMediaListModel.value.data == null || socialMediaController.socialMediaListModel.value.data!.isEmpty
                ? Center(child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600))
                : Padding(
                    padding: const EdgeInsets.only(top: 8, left: 14, right: 18, bottom: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: socialMediaController.socialMediaListModel.value.data!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      socialMediaController.launchURL(socialMediaController.socialMediaListModel.value.data![index].url ?? '');
                                    },
                                    child: Card(
                                      elevation: 5,
                                      color: primaryWhite,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 16),
                                            IconButton(
                                              icon: const Icon(Icons.send, color: deepBluedark, size: 30),
                                              onPressed: () {},
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(child: AppText(text: socialMediaController.socialMediaListModel.value.data![index].platform ?? '', txtColor: deepBluedark, size: 16, fontWeight: FontWeight.w500))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10)
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
      }),
    );
  }
}
