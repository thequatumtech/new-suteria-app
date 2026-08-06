import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class UploadDocumentsCommonScreen extends StatefulWidget {
  String documentNameText;
  List<File> selectedDocumentsImg;
  Function removeDocumentFunction;
  Function addDocumentFunction;
  String addDocText;


  UploadDocumentsCommonScreen({super.key, required this.documentNameText, required this.selectedDocumentsImg, required this.removeDocumentFunction, required this.addDocumentFunction,required this.addDocText});

  @override
  State<UploadDocumentsCommonScreen> createState() => _UploadDocumentsCommonScreenState();
}

class _UploadDocumentsCommonScreenState extends State<UploadDocumentsCommonScreen> with SingleTickerProviderStateMixin {
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
                            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), image: DecorationImage(image: FileImage(widget.selectedDocumentsImg[index]), fit: BoxFit.cover)), height: 70, width: 76),
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
            child: Container(height: 70, width: 76,
              decoration: BoxDecoration(border: Border.all(color: skyBlueShade2), borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, color: Colors.grey, size: 30),
                  AppText(
                    text: widget.addDocText,
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
