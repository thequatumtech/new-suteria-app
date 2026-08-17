import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/add_new_claim_screen.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/claim_controller.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/claim_message_screen.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/my_claims_screen.dart';
import 'package:soperia_user/Screens/data_not_found_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class ReviewMyClaimStatusScreen extends StatefulWidget {
  const ReviewMyClaimStatusScreen({super.key});

  @override
  State<ReviewMyClaimStatusScreen> createState() => _ReviewMyClaimStatusScreenState();
}

class _ReviewMyClaimStatusScreenState extends State<ReviewMyClaimStatusScreen> with SingleTickerProviderStateMixin {
  ClaimController claimController = Get.put(ClaimController());

  @override
  void initState() {
    claimController.getClaimsListApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: reviewMyClaimStatus, size: 18, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyClaimsScreen()));
            },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        return SafeArea(
          child: claimController.isLoadingClaimsList.value
              ? const Center(child: CircularProgressIndicator())
              : claimController.getClaimsListModel.value.data == null || claimController.getClaimsListModel.value.data!.isEmpty
                  ? Center(
                      child: DataNotFoundScreen(
                      title: noActiveClaims,
                      subTitle: youDonTHaveAnyPoliciesWithUsUet,
                    ))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: claimController.getClaimsListModel.value.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: deepBluedark),
                                        color: primaryWhite,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryGray.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 10),
                                            decoration: const BoxDecoration(
                                              color: deepBluedark,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                            ),
                                            child: AppText(text: '$status ${claimController.getClaimsListModel.value.data![index].status ?? ''}', txtColor: primaryWhite, size: 16, fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16, bottom: 12, left: 20, right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(text: claimNumber, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                                    const SizedBox(height: 2),
                                                    AppText(text: claimController.getClaimsListModel.value.data![index].claimNo ?? '', size: 15, fontWeight: FontWeight.w500),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(text: policyType, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                                    const SizedBox(height: 2),
                                                    AppText(text: claimController.getClaimsListModel.value.data![index].policyType ?? '', size: 15, fontWeight: FontWeight.w500),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 110,
                                                child: AppButton(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddNewClaimsScreen(
                                                                  isEdit: true,
                                                                  editData: claimController.getClaimsListModel.value.data![index],
                                                                )));
                                                  },
                                                  height: 36,
                                                  buttonColor: primaryWhite,
                                                  txtColor: deepBluedark,
                                                  borderColor: deepBluedark,
                                                  text: editt,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              SizedBox(
                                                width: 110,
                                                child: AppButton(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => ClaimMessageScreen(
                                                                  data: claimController.getClaimsListModel.value.data![index],
                                                                )));
                                                  },
                                                  height: 36,
                                                  buttonColor: deepBluedark,
                                                  text: message,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14)
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      }),
    );
  }
}
