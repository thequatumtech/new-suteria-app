import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/get_policy_details_model.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/my_policies_controller.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/policy_details_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';


import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/policy_renewal_helper.dart';

class MyPolicies extends StatefulWidget {
  const MyPolicies({super.key});

  @override
  State<MyPolicies> createState() => _MyPoliciesState();
}

class _MyPoliciesState extends State<MyPolicies> with SingleTickerProviderStateMixin {
  MyPoliciesController myPoliciesController = Get.put(MyPoliciesController());

  @override
  void initState() {
    myPoliciesController.clearData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          AppText(text: mypolicies, size: 18, fontWeight: FontWeight.bold),
          const Spacer(),
         /* SvgPicture.asset(searchSvg),
          const SizedBox(width: 18),
          SvgPicture.asset(tuneSvg),*/
        ],
      )),
      body: SafeArea(
        child: Obx(() {
          return myPoliciesController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  color: deepBluedark,
                  onRefresh: () async {
                    await myPoliciesController.getPolicyDetailsApi(context, isRefresh: true);
                  },
                  child: myPoliciesController.getPolicyDetailsModel.value.data == null || myPoliciesController.getPolicyDetailsModel.value.data!.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Divider(color: skyBlueShade2),
                              Padding(
                                padding: const EdgeInsets.only(top: 8, left: 18, right: 18, bottom: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), border: Border.all(color: deepBluedark)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              myPoliciesController.isPoliciesActive.value = true;
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(color: !myPoliciesController.isPoliciesActive.value ? Colors.transparent : deepBluedark, borderRadius: BorderRadius.all(Radius.circular(30))),
                                              child: Center(child: AppText(text: active, size: 16, txtColor: !myPoliciesController.isPoliciesActive.value ? primaryBlack : primaryWhite)),
                                            ),
                                          )),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                myPoliciesController.isPoliciesActive.value = false;
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(color: myPoliciesController.isPoliciesActive.value ? Colors.transparent : deepBluedark, borderRadius: BorderRadius.all(Radius.circular(30))),
                                                child: Center(child: AppText(text: expired, size: 16, txtColor: myPoliciesController.isPoliciesActive.value ? primaryBlack : primaryWhite)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    myPoliciesController.isPoliciesActive.value ? activeData() : expiredData()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                );
        }),
      ),
    );
  }

  Widget activeData() {
    List<PolicyData> activeList = (myPoliciesController.getPolicyDetailsModel.value.data ?? [])
        .where((element) => !isActiveOrExpiredDataCheck(element.expiryDate ?? ''))
        .toList();

    if (activeList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: AppText(
            text: noActivePoliciesFound,
            size: 16,
            fontWeight: FontWeight.w600,
            txtColor: primaryGrayShade,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: activeList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final policyItem = activeList[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PolicyDetailsScreen(policyData: policyItem),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: AppText(text: '$policyNo ${policyItem.policyNo ?? ''}', txtColor: primaryWhite, size: 16, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: policyType, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: policyItem.policyType.toString(), size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: expiryDate, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: commonDateFormat(policyItem.expiryDate ?? ''), size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: premiumPaid, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: commonDateFormat(policyItem.inceptionDate ?? ''), size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: insuranceCompany, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: policyItem.companyName ?? '', size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget expiredData() {
    List<PolicyData> expiredList = (myPoliciesController.getPolicyDetailsModel.value.data ?? [])
        .where((element) => isActiveOrExpiredDataCheck(element.expiryDate ?? ''))
        .toList();

    if (expiredList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: AppText(
            text: noExpiredPoliciesFound,
            size: 16,
            fontWeight: FontWeight.w600,
            txtColor: primaryGrayShade,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: expiredList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final policyItem = expiredList[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PolicyDetailsScreen(policyData: policyItem),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: AppText(text: '$policyNo ${policyItem.policyNo ?? ''}', txtColor: primaryWhite, size: 16, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: policyType, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: policyItem.policyType.toString(), size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: expiryDate, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: commonDateFormat(policyItem.expiryDate ?? ''), size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: premiumPaid, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: commonDateFormat(policyItem.inceptionDate ?? ''), size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(text: insuranceCompany, size: 15, fontWeight: FontWeight.w500, txtColor: primaryGrayShade),
                                const SizedBox(height: 2),
                                AppText(text: policyItem.companyName ?? '', size: 15, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      child: AppBtnWithColorShades(
                        textSize: 12,
                        paddingSize: 8,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PolicyDetailsScreen(policyData: policyItem),
                            ),
                          );
                        },
                        btnTxt: viewDetails,
                        color1: darkBlue2,
                        color2: darkBlue1,
                      ),
                    ),
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 120,
                      child: AppBtnWithColorShades(
                        textSize: 12,
                        paddingSize: 8,
                        onTap: () {
                          renewPolicy(context, policyItem);
                        },
                        btnTxt: renew,
                        color1: darkBlue2,
                        color2: darkBlue1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  isActiveOrExpiredDataCheck(String date) {
    if (date.isEmpty) return false;
    final now = DateTime.now();
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date).add(const Duration(days: 1));
    final bool isExpired = tempDate.isBefore(now);
    return isExpired;
  }
}


