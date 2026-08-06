import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class NewUploadDocumentsCommonScreen extends StatefulWidget {
  String documentNameText;
  List<String> selectedDocumentsImg;
  Function removeDocumentFunction;
  Function addDocumentFunction;
  String addDocText;
  bool isLoading;


  NewUploadDocumentsCommonScreen({super.key, required this.documentNameText, required this.selectedDocumentsImg, required this.removeDocumentFunction, required this.addDocumentFunction,required this.addDocText,required this.isLoading});

  @override
  State<NewUploadDocumentsCommonScreen> createState() => _NewUploadDocumentsCommonScreenState();
}

class _NewUploadDocumentsCommonScreenState extends State<NewUploadDocumentsCommonScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AppText(text: widget.documentNameText, size: 14, fontWeight: FontWeight.w600),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 14),
          decoration: BoxDecoration(border: Border.all(color: skyBlueShade2), borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: GridView.builder(
            itemCount: widget.selectedDocumentsImg.length + 1,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return index == widget.selectedDocumentsImg.length
                  ? _buildAddImageButton()
                  : SizedBox(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                        height: 70,
                        width: 76,
                        child: CachedNetworkImage(
                            height: 70,
                            width: 76,
                            imageUrl: "$imgBaseUrl/${widget.selectedDocumentsImg[index] ?? ''}",
                            // imageUrl: profileController.getProfileModel.value.data?.profilePic ?? '',
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 16,
                      child: InkWell(
                        onTap: () {
                          widget.removeDocumentFunction(index);
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(color: deepBluedark, borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                            child: Icon(Icons.clear, size: 16, color: primaryWhite),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildAddImageButton() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: InkWell(
            onTap: () {
              widget.addDocumentFunction();
            },
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                :Container(
              height: 70,
              width: 76,
              decoration: BoxDecoration(border: Border.all(color: skyBlueShade2), borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, color: Colors.grey, size: 30),
                  AppText(
                    text: addDocuments,
                    size: 10,
                    txtColor: skyBlueShade3,
                    txtAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
