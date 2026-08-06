import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Profile/profile_controller/profile_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class MyCouponsScreen extends StatefulWidget {
  bool isApplyCoupon;
  String insuranceType;

  MyCouponsScreen({super.key, required this.insuranceType, required this.isApplyCoupon});

  @override
  State<MyCouponsScreen> createState() => _MyCouponsScreenState();
}

class _MyCouponsScreenState extends State<MyCouponsScreen> {
  ProfileController profileController = Get.put(ProfileController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    profileController.getDiscountCouponsApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(title: AppText(text: myCoupons, size: 18, fontWeight: FontWeight.bold)),
      body: Obx(() {
        return profileController.isLoadingDiscountCoupons.value
            ? const Center(child: CircularProgressIndicator())
            : profileController.getDiscountCouponsModel.value.data == null || profileController.getDiscountCouponsModel.value.data!.isEmpty
                ? Center(child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600))
                : Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isApplyCoupon)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: couponCodeTxt,
                                  size: 16,
                                  txtColor: deepBluedark,
                                  fontWeight: FontWeight.bold,
                                  txtAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: AppTextfield(
                                        keyboardType: TextInputType.number,
                                        width: 10,
                                        hint: couponCodeTxt,
                                        lable: enterCouponCode,
                                        controller: draftPdfController.couponCodeController.value,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: AppBtnWithColorShades(
                                        // isLoad: draftPdfController.isLoadingDiscountAmount.value,
                                        onTap: () {
                                          if (draftPdfController.couponCodeController.value.text.isNotEmpty) {
                                            draftPdfController.getDiscountAmountApi(context);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCouponCode, txtColor: primaryWhite, size: 12)));
                                          }
                                        },
                                        btnTxt: apply,
                                        color1: darkBlue2,
                                        color2: darkBlue1,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ListView.builder(
                            itemCount: profileController.getDiscountCouponsModel.value.data!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(text: profileController.getDiscountCouponsModel.value.data![index].couponCode ?? ''));
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "Coupon Code Copied", txtColor: primaryWhite, size: 12)));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(top: 14, bottom: 14, left: 25, right: 25),
                                            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(myCouponsBackImg), fit: BoxFit.fill)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              AppText(
                                                                text: '$couponCode${profileController.getDiscountCouponsModel.value.data![index].couponCode ?? ''}',
                                                                txtColor: primaryWhite,
                                                                size: 14,
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                              AppText(
                                                                text: '$insuranceType${profileController.getDiscountCouponsModel.value.data![index].lineOfBusiness!.name ?? ''}',
                                                                txtColor: primaryWhite,
                                                                size: 13,
                                                                fontWeight: FontWeight.w500,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            AppText(
                                                              text: expiredOn,
                                                              txtColor: primaryWhite,
                                                              size: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                            AppText(
                                                              text: dateFormat(profileController.getDiscountCouponsModel.value.data![index].expiryDate ?? ''),
                                                              txtColor: primaryWhite,
                                                              size: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                if (widget.isApplyCoupon)
                                                  Column(
                                                    children: [
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          SizedBox(
                                                            height: 40,
                                                            width: 80,
                                                            child: AppBtnWithColorShades(
                                                              // isLoad: draftPdfController.isLoadingDiscountAmount.value,
                                                              onTap: () {
                                                                draftPdfController.couponCodeController.value.text = profileController.getDiscountCouponsModel.value.data![index].couponCode ?? '';
                                                                if (draftPdfController.couponCodeController.value.text.isNotEmpty) {
                                                                  draftPdfController.getDiscountAmountApi(context);
                                                                } else {
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterCouponCode, txtColor: primaryWhite, size: 12)));
                                                                }
                                                              },
                                                              textSize: 14,
                                                              paddingSize: 8,
                                                              btnTxt: apply,
                                                              textColor: darkBlue2,
                                                              color1: primaryWhite,
                                                              color2: primaryWhite,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                Html(
                                                  data: profileController.getDiscountCouponsModel.value.data![index].description ?? '',
                                                  style: {'body': Style(fontWeight: FontWeight.w500, color: primaryWhite, maxLines: 3, fontSize: FontSize(14), textOverflow: TextOverflow.ellipsis)},
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10)
                                      ],
                                    ); /*widget.isApplyCoupon
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 150),
                                          child: Center(child: AppText(text: noCouponsFound, size: 20, fontWeight: FontWeight.w600)),
                                        )
                                      : Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(text: profileController.getDiscountCouponsModel.value.data![index].couponCode ?? ''));
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(top: 14, bottom: 14, left: 25, right: 25),
                                                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(myCouponsBackImg), fit: BoxFit.fill)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  AppText(
                                                                    text: '$couponCode${profileController.getDiscountCouponsModel.value.data![index].couponCode ?? ''}',
                                                                    txtColor: primaryWhite,
                                                                    size: 14,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                  AppText(
                                                                    text: '$insuranceType${profileController.getDiscountCouponsModel.value.data![index].lineOfBusiness!.name ?? ''}',
                                                                    txtColor: primaryWhite,
                                                                    size: 13,
                                                                    fontWeight: FontWeight.w500,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                AppText(
                                                                  text: expiredOn,
                                                                  txtColor: primaryWhite,
                                                                  size: 12,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                                AppText(
                                                                  text: dateFormat(profileController.getDiscountCouponsModel.value.data![index].expiryDate ?? ''),
                                                                  txtColor: primaryWhite,
                                                                  size: 12,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    if (widget.isApplyCoupon)
                                                      Column(
                                                        children: [
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              SizedBox(
                                                                height: 40,
                                                                width: 80,
                                                                child: AppBtnWithColorShades(
                                                                  // isLoad: draftPdfController.isLoadingDiscountAmount.value,
                                                                  onTap: () {
                                                                    draftPdfController.couponCodeController.value.text = profileController.getDiscountCouponsModel.value.data![index].couponCode ?? '';
                                                                    if (draftPdfController.couponCodeController.value.text.isNotEmpty) {
                                                                      draftPdfController.getDiscountAmountApi(context);
                                                                    } else {
                                                                      ScaffoldMessenger.of(context)
                                                                          .showSnackBar(SnackBar(content: AppText(text: pleaseEnterCouponCode, txtColor: primaryWhite, size: 12)));
                                                                    }
                                                                  },
                                                                  textSize: 14,
                                                                  paddingSize: 8,
                                                                  btnTxt: apply,
                                                                  textColor: darkBlue2,
                                                                  color1: primaryWhite,
                                                                  color2: primaryWhite,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    Html(
                                                      data: profileController.getDiscountCouponsModel.value.data![index].description ?? '',
                                                      style: {
                                                        'body': Style(fontWeight: FontWeight.w500, color: primaryWhite, maxLines: 3, fontSize: FontSize(14), textOverflow: TextOverflow.ellipsis)
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10)
                                          ],
                                        );*/
                            },
                          )
                        ],
                      ),
                    ),
                  );
      }),
    );
  }

  dateFormat(String date) {
    DateTime currentDate = DateTime.parse(date);
    String formattedDate = DateFormat("dd MMM, yyyy").format(currentDate);
    return formattedDate;
  }
}
