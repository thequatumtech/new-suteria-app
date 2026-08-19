import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/Profile/Contact%20Us/contact_us_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/chat_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void dispose() {
    contactUsController.stopPolling();
    super.dispose();
  }

  Future<void> _openFileUrl(String url) async {
    if (url.isEmpty) return;
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching file URL: $e');
    }
  }

  Widget _buildBubbleContent(ChatMessageItem item) {
    List<Widget> children = [];

    // Render image or file if present
    if (item.hasFile) {
      final fileUrl = item.fullFileUrl(baseURL);
      if (item.isImage) {
        children.add(
          GestureDetector(
            onTap: () => _openFileUrl(fileUrl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: fileUrl,
                width: 200,
                height: 180,
                fit: BoxFit.cover,
                memCacheWidth: 400,
                memCacheHeight: 360,
                placeholder: (context, url) => const SizedBox(
                  width: 200,
                  height: 180,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 200,
                  height: 100,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      } else {
        // Document or Video file card
        children.add(
          InkWell(
            onTap: () => _openFileUrl(fileUrl),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.fileType == 'pdf'
                        ? Icons.picture_as_pdf
                        : item.fileType == 'video'
                            ? Icons.video_library
                            : Icons.insert_drive_file,
                    color: item.isClientMessage ? primaryWhite : deepBluedark,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      item.fileName ?? 'Attachment',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: item.isClientMessage ? primaryWhite : primaryBlack,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (item.message != null && item.message!.isNotEmpty) {
        children.add(const SizedBox(height: 6));
      }
    }

    // Render message text if present
    if (item.message != null && item.message!.isNotEmpty) {
      children.add(
        AppText(
          text: item.message!,
          size: 14,
          txtColor: item.isClientMessage ? primaryWhite : primaryBlack,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText(text: contactus, size: 18, fontWeight: FontWeight.bold)),
      body: SafeArea(
        child: Obx(() {
          if (contactUsController.isLoadingChatsList.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final liveMessages = contactUsController.chatMessagesList;
          final bool hasLiveMessages = liveMessages.isNotEmpty;

          return RefreshIndicator(
            key: contactUsController.refreshKey,
            onRefresh: () => contactUsController.refreshList(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: hasLiveMessages
                        ? SingleChildScrollView(
                            controller: contactUsController.listScrollController.value,
                            child: Column(
                              children: [
                                if (contactUsController.isLoadingMore.value)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                ListView.builder(
                                  itemCount: liveMessages.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final ChatMessageItem item = liveMessages[index];
                                    final String currentDateLabel = contactUsController.formatDateLabel(item.createdAt);
                                    final String prevDateLabel = index > 0 ? contactUsController.formatDateLabel(liveMessages[index - 1].createdAt) : '';
                                    final bool showDateHeader = index == 0 || (currentDateLabel.isNotEmpty && currentDateLabel != prevDateLabel);
                                    final String timeLabel = contactUsController.formatTimeLabel(item.createdAt);

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (showDateHeader)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Center(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: AppText(
                                                  text: currentDateLabel,
                                                  size: 12,
                                                  txtColor: primaryBlack,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 4),
                                        item.isClientMessage
                                            ? Padding(
                                                padding: const EdgeInsets.only(right: 5, left: 45, top: 4, bottom: 4),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: Container(
                                                        decoration: const BoxDecoration(
                                                          color: deepBluedark,
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(12),
                                                            bottomRight: Radius.circular(12),
                                                            topLeft: Radius.circular(12),
                                                          ),
                                                        ),
                                                        padding: const EdgeInsets.all(12),
                                                        child: _buildBubbleContent(item),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: AppText(
                                                        text: timeLabel,
                                                        size: 11,
                                                        txtColor: primaryGrayShade,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 45, top: 4, bottom: 4),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        color: grayshad200,
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(12),
                                                          bottomRight: Radius.circular(12),
                                                          topRight: Radius.circular(12),
                                                        ),
                                                      ),
                                                      padding: const EdgeInsets.all(12),
                                                      child: _buildBubbleContent(item),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: AppText(
                                                        text: timeLabel,
                                                        size: 11,
                                                        txtColor: primaryGrayShade,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: AppText(
                              text: 'No messages yet',
                              size: 14,
                              txtColor: primaryGrayShade,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
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
                          icon: const Icon(Icons.attach_file, color: primaryGrayShade, size: 24),
                          onPressed: () {
                            contactUsController.showPicker(context);
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: contactUsController.messageController.value,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: enterMessage,
                              hintStyle: TextStyle(color: deepBluedark, fontWeight: FontWeight.w500, fontSize: 15),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        contactUsController.isLoadingSendClaimsMessage.value
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.send, color: deepBluedark, size: 26),
                                onPressed: () {
                                  if (contactUsController.messageController.value.text.trim().isEmpty &&
                                      contactUsController.selectedFileDocuments.path.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: AppText(text: pleaseEnterMessage, txtColor: primaryWhite, size: 12)),
                                    );
                                  } else {
                                    contactUsController.sendContactMessageApi(context);
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
