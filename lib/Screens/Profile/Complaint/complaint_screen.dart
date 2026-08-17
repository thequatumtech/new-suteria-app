import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Profile/Complaint/add_complaint_screen.dart';
import 'package:soperia_user/Screens/Profile/Complaint/complaint_controller.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  ComplaintController complaintController = Get.put(ComplaintController());

  @override
  void initState() {
    complaintController.getComplaintListApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: complaint, size: 18, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddComplaintScreen()));
            },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        return complaintController.isLoadingGetApi.value
            ? const Center(child: CircularProgressIndicator())
            : complaintController.getComplaintListModel.value.data == null || complaintController.getComplaintListModel.value.data!.isEmpty
                ? Center(
                    child: AppText(text: noComplaintsFound, size: 20, fontWeight: FontWeight.w600),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8, left: 18, right: 18, bottom: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: complaintController.getComplaintListModel.value.data!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                                    decoration: const BoxDecoration(color: skyBlueShade2, borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(child: AppText(text: '$complaintNo ${complaintController.getComplaintListModel.value.data![index].complaintNumber ?? ''}', txtColor: deepBluedark, size: 16, fontWeight: FontWeight.w700)),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                  decoration: const BoxDecoration(color: primaryWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: AppText(
                                                    text: complaintController.getComplaintListModel.value.data![index].status!.name ?? '',
                                                    txtColor: deepBluedark,
                                                    size: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            AppText(
                                              text: dateFormat(complaintController.getComplaintListModel.value.data![index].complaintDate ?? ''),
                                              txtColor: deepBluedark,
                                              size: 14,
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        AppText(
                                          text: complaintController.getComplaintListModel.value.data![index].complaintMessage ?? '',
                                          maxLine: 3,
                                          overflow: TextOverflow.ellipsis,
                                          txtColor: skyBlueShade3,
                                          size: 13,
                                          fontWeight: FontWeight.w500,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12)
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

  dateFormat(String date) {
    try {
      DateTime dateFormat = DateFormat('yyyy-MM-dd').parse(date);
      String newFormatDate = DateFormat('d MMMM, y').format(dateFormat);
      return newFormatDate;
    } catch (e) {
      return date;
    }
  }
}
