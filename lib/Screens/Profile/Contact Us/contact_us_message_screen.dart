import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Profile/Contact%20Us/contact_us_controller.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class ContactUsMessageScreen extends StatefulWidget {
  ContactUsMessageScreen({super.key});

  @override
  State<ContactUsMessageScreen> createState() => _ContactUsMessageScreenState();
}

class _ContactUsMessageScreenState extends State<ContactUsMessageScreen> with SingleTickerProviderStateMixin {
  ContactUsController contactUsController = Get.put(ContactUsController());

  @override
  void initState() {
    contactUsController.apiMethod(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: AppText(text: contactus, size: 18, fontWeight: FontWeight.bold)),
        body: SafeArea(
          child: Obx(() {
            return contactUsController.isLoadingChatsList.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    key: contactUsController.refreshKey,
                    onRefresh: () => contactUsController.refreshList(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Column(
                        children: [
                          contactUsController.contactChatsListModel.value.data != null /*|| contactUsController.contactChatsListModel.value.data!.messages!.isNotEmpty*/
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    controller: contactUsController.listScrollController.value,
                                    child: ListView.builder(
                                      itemCount: contactUsController.contactChatsListModel.value.data!.messages!.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (index == 0 ||
                                                DateFormat('d MMMM, y').format(DateTime.parse(contactUsController.contactChatsListModel.value.data!.messages![index].createdAt ?? '')) !=
                                                    DateFormat('d MMMM, y').format(DateTime.parse(contactUsController.contactChatsListModel.value.data!.messages![index - 1].createdAt ?? '')))
                                              Column(
                                                children: [
                                                  Center(child: AppText(text: DateFormat('d MMMM, y').format(DateTime.parse(contactUsController.contactChatsListModel.value.data!.messages![index].createdAt ?? '')), size: 15, txtColor: primaryGrayShade, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            const SizedBox(height: 5),
                                            int.parse(contactUsController.contactChatsListModel.value.data!.messages![index].sentBy ?? '') == 0
                                                ? Padding(
                                                    padding: const EdgeInsets.only(left: 5, right: 25),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: const BoxDecoration(color: grayshad200, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                                          child: contactUsController.contactChatsListModel.value.data!.messages![index].isMessage == '1'
                                                              ? Padding(
                                                                  padding: const EdgeInsets.all(12),
                                                                  child: AppText(text: contactUsController.contactChatsListModel.value.data!.messages![index].message ?? '', size: 14, fontWeight: FontWeight.w500),
                                                                )
                                                              : Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(12),
                                                                      child: AppText(text: contactUsController.contactChatsListModel.value.data!.clientName ?? '', size: 14, fontWeight: FontWeight.w500),
                                                                    ),
                                                                    Container(
                                                                        alignment: Alignment.center,
                                                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                        child: ClipRRect(
                                                                            child: CachedNetworkImage(
                                                                                imageUrl: "${contactUsController.contactChatsListModel.value.data!.filePath ?? ''}/${contactUsController.contactChatsListModel.value.data!.messages![index].message ?? ''}",
                                                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                                fit: BoxFit.cover))),
                                                                  ],
                                                                ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: AppText(text: DateFormat.jm().format(DateTime.parse(contactUsController.contactChatsListModel.value.data!.messages![index].createdAt ?? '')), size: 12, txtColor: primaryGrayShade),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets.only(right: 5, left: 25),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: Container(
                                                            decoration: const BoxDecoration(color: deepBluedark, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topLeft: Radius.circular(10))),
                                                            child: contactUsController.contactChatsListModel.value.data!.messages![index].isMessage == '1'
                                                                ? Padding(
                                                                    padding: const EdgeInsets.all(12),
                                                                    child: AppText(text: contactUsController.contactChatsListModel.value.data!.messages![index].message ?? '', size: 14, txtColor: primaryWhite, fontWeight: FontWeight.w500),
                                                                  )
                                                                : Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(12),
                                                                        child: AppText(text: contactUsController.contactChatsListModel.value.data!.clientName ?? '', size: 14, txtColor: primaryWhite, fontWeight: FontWeight.w500),
                                                                      ),
                                                                      Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                          child: ClipRRect(
                                                                              child: CachedNetworkImage(
                                                                                  imageUrl: "${contactUsController.contactChatsListModel.value.data!.filePath ?? ''}/${contactUsController.contactChatsListModel.value.data!.messages![index].message ?? ''}",
                                                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                                  fit: BoxFit.cover))),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: AppText(text: DateFormat.jm().format(DateTime.parse(contactUsController.contactChatsListModel.value.data!.messages![index].createdAt ?? '')), size: 12, txtColor: primaryGrayShade),
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
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                                IconButton(
                                  icon: const Icon(Icons.attach_file, color: primaryGrayShade, size: 26),
                                  onPressed: () {
                                    contactUsController.showPicker(context);
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: contactUsController.messageController.value,
                                    decoration: const InputDecoration(
                                      hintText: enterMessage,
                                      hintStyle: TextStyle(color: deepBluedark, fontWeight: FontWeight.w500, fontSize: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                contactUsController.isLoadingSendClaimsMessage.value
                                    ? const CircularProgressIndicator()
                                    : IconButton(
                                        icon: const Icon(Icons.send, color: deepBluedark, size: 30),
                                        onPressed: () {
                                          if (contactUsController.messageController.value.text.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterMessage, txtColor: primaryWhite, size: 12)));
                                          } else {
                                            contactUsController.sendContactMessageApi(context);
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
      print(contactUsController.dateList);
      if (!contactUsController.dateList.contains(dateFormat)) {
        contactUsController.dateList.add(dateFormat);
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
      print(contactUsController.dateList);
      if (!contactUsController.dateList.contains(dateFormat)) {
        contactUsController.dateList.add(dateFormat);
        return newFormatDate;
      } else {
        return '';
      }
    } catch (e) {
      return date;
    }
  }
}
