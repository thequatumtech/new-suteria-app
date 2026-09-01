import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

class ImageUploadWidget extends StatelessWidget {
  String? txt;
  File? image;
  Color? borderColor;
  bool? isLoading;

  ImageUploadWidget({super.key, this.txt, this.image, this.borderColor,this.isLoading});

  @override
  Widget build(BuildContext context) {
    return image != null && image?.path != ''
        ? Container(
            width: double.infinity,
            height: 150,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(image: DecorationImage(image: FileImage(image!), fit: BoxFit.contain), border: Border.all(color: borderColor ?? primaryBlack), borderRadius: const BorderRadius.all(Radius.circular(10))),
            /*child: Column(
        children: [
          Image.file(
            image!,
            fit: BoxFit.fill,height: 140,width: double.infinity,
          ),
        ],
      ),*/
          )
        :  Container(
            width: double.infinity,
            // height: 130,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(border: Border.all(color: borderColor ?? primaryBlack), borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: isLoading ?? false
                ? const Center(child: CircularProgressIndicator())
                :Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(uploadlogo),
                const SizedBox(height: 10),
                AppText(
                  text: txt ?? uploadYourDocumentHere,
                  size: 14,
                  fontWeight: FontWeight.w100,
                )
              ],
            ),
          );
  }
}



class ImageUploadWidgetSubText extends StatelessWidget {
  String? txt;
  String? subTxt;
  File? image;
  Color? borderColor;
  bool? isLoading;

  ImageUploadWidgetSubText({super.key, this.txt, this.image, this.borderColor,this.isLoading,this.subTxt});

  @override
  Widget build(BuildContext context) {
    return image != null && image?.path != ''
        ? Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(image: DecorationImage(image: FileImage(image!), fit: BoxFit.contain), border: Border.all(color: borderColor ?? primaryBlack), borderRadius: const BorderRadius.all(Radius.circular(10))),
      /*child: Column(
        children: [
          Image.file(
            image!,
            fit: BoxFit.fill,height: 140,width: double.infinity,
          ),
        ],
      ),*/
    )
        :  Container(
      width: double.infinity,
      // height: 130,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(border: Border.all(color: borderColor ?? primaryBlack), borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: isLoading ?? false
          ? const Center(child: CircularProgressIndicator())
          :Column(
        children: [
          const SizedBox(height: 10),
          Image.asset(uploadlogo),
          const SizedBox(height: 10),


          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: getTranslated(context, txt ?? uploadYourDocumentHere),
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                    fontFamily: "Montserrat_Regular",
                    fontSize: 14,
                  ),
                ),
                if (subTxt != null && subTxt!.isNotEmpty)
                  TextSpan(
                    text: "   (${getTranslated(context, subTxt!)})",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w100,
                      fontFamily: "Montserrat_Regular",
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

        /*  AppText(
            text: txt ?? uploadYourDocumentHere,
            size: 14,
            fontWeight: FontWeight.w100,
          )*/
        ],
      ),
    );
  }
}