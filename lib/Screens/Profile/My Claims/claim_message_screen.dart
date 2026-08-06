import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/claim_controller.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/get_claims_list_model.dart';

class ClaimMessageScreen extends StatefulWidget {
  ClaimsListData data;

  ClaimMessageScreen({super.key, required this.data});

  @override
  State<ClaimMessageScreen> createState() => _ClaimMessageScreenState();
}

class _ClaimMessageScreenState extends State<ClaimMessageScreen> with SingleTickerProviderStateMixin {
  ClaimController claimController = Get.put(ClaimController());

  @override
  void initState() {
    claimController.apiCallMethod(context, widget.data.id ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: AppText(text: widget.data.companyName ?? '', size: 18, fontWeight: FontWeight.bold)),
        body: SafeArea(
          child: Obx(() {
            return claimController.isLoadingClaimsChatsList.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    key: claimController.refreshKey,
                    onRefresh: () => claimController.refreshList(context, widget.data.id ?? 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Column(
                        children: [
                          claimController.claimsChatSModel.value.data != null /*|| claimController.claimsChatSModel.value.data!.isNotEmpty*/
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    controller: claimController.listScrollController.value,
                                    child: ListView.builder(
                                      itemCount: claimController.claimsChatSModel.value.data!.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (index == 0 ||
                                                DateFormat('d MMMM, y').format(DateTime.parse(claimController.claimsChatSModel.value.data![index].createdAt ?? '')) != DateFormat('d MMMM, y').format(DateTime.parse(claimController.claimsChatSModel.value.data![index - 1].createdAt ?? '')))
                                              Column(
                                                children: [
                                                  Center(child: AppText(text: DateFormat('d MMMM, y').format(DateTime.parse(claimController.claimsChatSModel.value.data![index].createdAt ?? '')), size: 15, txtColor: primaryGrayShade, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            const SizedBox(height: 5),
                                            int.parse(claimController.claimsChatSModel.value.data![index].sentBy ?? '') == 0
                                                ? Padding(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: const BoxDecoration(color: grayshad200, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(12),
                                                            child: AppText(text: claimController.claimsChatSModel.value.data![index].message ?? '', size: 14, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: AppText(text: DateFormat.jm().format(DateTime.parse(claimController.claimsChatSModel.value.data![index].createdAt ?? '')), size: 12, txtColor: primaryGrayShade),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets.only(right: 5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: Container(
                                                            decoration: const BoxDecoration(color: deepBluedark, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topLeft: Radius.circular(10))),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(12),
                                                              child: AppText(text: claimController.claimsChatSModel.value.data![index].message ?? '', size: 14, txtColor: primaryWhite, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: AppText(text: DateFormat.jm().format(DateTime.parse(claimController.claimsChatSModel.value.data![index].createdAt ?? '')), size: 12, txtColor: primaryGrayShade),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : const Expanded(child: SizedBox()),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: claimController.claimMessageController.value,
                                    decoration: const InputDecoration(
                                      hintText: enterMessage,
                                      hintStyle: TextStyle(color: deepBluedark, fontWeight: FontWeight.w500, fontSize: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                claimController.isLoadingSendClaimsMessage.value
                                    ? const CircularProgressIndicator()
                                    : IconButton(
                                        icon: const Icon(Icons.send, color: deepBluedark, size: 30),
                                        onPressed: () {
                                          if (claimController.claimMessageController.value.text.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMessage, txtColor: primaryWhite, size: 12)));
                                          } else {
                                            claimController.sendClaimsMessageApi(context, widget.data);
                                          }
                                        },
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5)
                        ],
                      ),
                    ),
                  );
          }),
        ));
  }

  dateFormatCondition(String date) {
    try {
      DateTime dateFormat = DateFormat('yyyy-MM-dd').parse(date);
      String newFormatDate = DateFormat('d MMMM, y').format(dateFormat);
      print(claimController.dateList);
      if (!claimController.dateList.contains(dateFormat)) {
        claimController.dateList.add(dateFormat);
        return newFormatDate;
      } else {
        return '';
      }
    } catch (e) {
      return date;
    }
  }

  dateFormat(String date) {
    try {
      DateTime dateFormat = DateFormat('yyyy-MM-dd').parse(date);
      String newFormatDate = DateFormat('d MMMM, y').format(dateFormat);
      print(claimController.dateList);
      if (!claimController.dateList.contains(dateFormat)) {
        claimController.dateList.add(dateFormat);
        return newFormatDate;
      } else {
        return '';
      }
    } catch (e) {
      return date;
    }
  }
}
