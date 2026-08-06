import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_text.dart';

import 'color_constrint.dart';

class AppButton extends StatelessWidget {
  final String text;
  Color? txtColor;
  Color? buttonColor;
  BorderRadius? redius;
  double? size;
  FontWeight? fontWeight;
  Color? borderColor;
  double? borderWidth;
  double? width;
  double? height;
  Function? onTap;
  EdgeInsetsGeometry? padding;
  String? fontFamily;
  bool? isShadow;
  Color? shadowColor;
  bool? isElevation;
  bool? isLoad;

  AppButton({Key? key, required this.text, this.isElevation = true, this.isLoad, this.width, this.height, this.shadowColor, this.isShadow = false, this.padding, this.txtColor, this.size, this.fontWeight, this.fontFamily, this.redius, this.borderColor, this.borderWidth, this.buttonColor, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Card(
        elevation: isElevation! ? 5 : 0,
        margin: EdgeInsets.zero,
        shape: OutlineInputBorder(borderRadius: redius ?? BorderRadius.circular(8), borderSide: BorderSide(color: borderColor ?? primaryWhite, width: 0.8)),
        child: Container(
          height: height ?? 46,
          width: width ?? double.infinity,
          padding: padding ?? EdgeInsets.zero,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: redius ?? BorderRadius.circular(8),
              color: buttonColor ?? Colors.red,
              border: Border.all(color: borderColor ?? buttonColorApp, width: borderWidth ?? 1.0),
              boxShadow: isShadow!
                  ? [
                      BoxShadow(
                        color: shadowColor!,
                        blurRadius: 8,
                      )
                    ]
                  : []),
          child: isLoad ?? false ? const CircularProgressIndicator(color: primaryWhite) : Center(child: Text(text, style: TextStyle(fontFamily: fontFamily ?? "Inter_Regular", color: txtColor ?? Colors.white, fontSize: size ?? 16, fontWeight: fontWeight ?? FontWeight.normal))),
        ),
      ),
    ); //getternsleted(context,key)
  }
}

class AppBtnWithColorShades extends StatelessWidget {
  Function? onTap;
  Color? color1;
  Color? color2;
  Color? textColor;
  String? btnTxt;
  bool? isLoad;
  double? textSize;
  double? paddingSize;

  AppBtnWithColorShades({super.key, this.onTap, this.textColor,this.color1, this.color2, this.btnTxt, this.isLoad, this.textSize, this.paddingSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isLoad ?? false ? null : onTap!();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(paddingSize ?? 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            gradient: LinearGradient(colors: [
              color1!,
              color2!,
            ], stops: const [
              0.0,
              1.0
            ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, tileMode: TileMode.repeated)),
        child: isLoad ?? false
            ? const Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: primaryWhite,
                    )))
            : Center(child: AppText(text: btnTxt ?? "", fontWeight: FontWeight.w600, txtColor: textColor ?? primarywhiteShade0, size: textSize ?? 16)),
      ),
    );
  }
}
