import 'package:flutter/material.dart';
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
    return Text(/*getTranslated(context, text) ?? */text,maxLines: maxLine,
        style: TextStyle(fontFamily: fontFamily??"Montserrat_Regular",color: txtColor ?? primaryBlack, fontSize: size ?? 8, fontWeight: fontWeight ?? FontWeight.normal,overflow:overflow, decoration: textunderline ??TextDecoration.none,decorationColor: textUnderlineColor ?? primaryBlack),textAlign: txtAlign,softWrap: true,); //getternsleted(context,key)
  }
}
