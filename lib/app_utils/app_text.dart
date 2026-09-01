import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';



class AppText extends StatelessWidget {
  final String text;
  Color? txtColor;
  TextDecoration ? textunderline ;
  Color ? textUnderlineColor ;
  double? size;
  FontWeight? fontWeight;
  TextAlign? txtAlign;
  int? maxLine;
  TextOverflow? overflow;
  String? fontFamily;
  AppText({Key? key, required this.text, this.txtColor, this.size, this.fontWeight, this.txtAlign,this.maxLine,this.fontFamily,this.overflow,this.textunderline,this.textUnderlineColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String translatedText = getTranslated(context, text);
    bool isYesOrNo = text == yesTxt ||
        text == noTxt ||
        text.trim().toLowerCase() == 'yes' ||
        text.trim().toLowerCase() == 'no' ||
        translatedText.trim() == 'نعم' ||
        translatedText.trim() == 'لا' ||
        translatedText.trim().toLowerCase() == 'yes' ||
        translatedText.trim().toLowerCase() == 'no';

    double effectiveSize = size ?? (isYesOrNo ? 15 : 8);
    if (isYesOrNo && size != null && size! < 15) {
      effectiveSize = 15;
    }

    FontWeight effectiveWeight = fontWeight ?? (isYesOrNo ? FontWeight.w500 : FontWeight.normal);

    return Text(
      translatedText,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: fontFamily ?? "Montserrat_Regular",
        color: txtColor ?? primaryBlack,
        fontSize: effectiveSize,
        fontWeight: effectiveWeight,
        overflow: overflow,
        decoration: textunderline ?? TextDecoration.none,
        decorationColor: textUnderlineColor ?? primaryBlack,
      ),
      textAlign: txtAlign,
      softWrap: true,
    );
  }
}
