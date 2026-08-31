import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/add_new_claim_screen.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/claim_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

class MyClaimsScreen extends StatefulWidget {
  const MyClaimsScreen({super.key});

  @override
  State<MyClaimsScreen> createState() => _MyClaimsScreenState();
}

class _MyClaimsScreenState extends State<MyClaimsScreen> with SingleTickerProviderStateMixin {
  ClaimController claimController = Get.put(ClaimController());

  @override
  void initState() {
    claimController.getPolicyDetailsApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText(text: myclaims, size: 18, fontWeight: FontWeight.bold)),
      body: SafeArea(
        child: Obx(() {
          return claimController.isLoadingPolicyDetails.value
              ? const Center(child: CircularProgressIndicator())
              : claimController.getPolicyDetailsModel.value.data == null || claimController.getPolicyDetailsModel.value.data!.isEmpty
                  ? Center(child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView.builder(
                              itemCount: claimController.getPolicyDetailsModel.value.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return !isActiveOrExpiredDataCheck(claimController.getPolicyDetailsModel.value.data![index].expiryDate ?? '')
                                    ? Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryWhite,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryGray.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            // offset: const Offset(0, 0),
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
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                            ),
                                            child: AppText(text: '${getTranslated(context, policyNo)} ${claimController.getPolicyDetailsModel.value.data![index].policyNo ?? ''}', txtColor: primaryWhite, size: 16, fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      AppText(text: policyType, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                                      const SizedBox(height: 2),
                                                      AppText(text: claimController.getPolicyDetailsModel.value.data![index].policyType ?? '', size: 15, fontWeight: FontWeight.w500),
                                                      const SizedBox(height: 16),
                                                      AppText(text: insuranceCompany, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                                      const SizedBox(height: 2),
                                                      AppText(text: claimController.getPolicyDetailsModel.value.data![index].companyName ?? '', size: 15, fontWeight: FontWeight.w500),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: AppBtnWithColorShades(
                                                    textSize: 12,
                                                    paddingSize: 8,
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => AddNewClaimsScreen(
                                                                    isEdit: false,
                                                                    data: claimController.getPolicyDetailsModel.value.data![index],
                                                                  )));
                                                    },
                                                    btnTxt: addNewClaim,
                                                    color1: darkBlue2,
                                                    color2: darkBlue1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20)
                                  ],
                                )
                                : const SizedBox();
                              },
                            )
                          ],
                        ),
                      ),
                    );
        }),
      ),
    );
  }
  isActiveOrExpiredDataCheck(String date) {
    final now = DateTime.now();
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date).add(const Duration(days: 1));
    final bool isExpired = tempDate.isBefore(now);
    return isExpired;
  }
}
