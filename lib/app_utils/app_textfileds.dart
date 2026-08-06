import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'app_text.dart';

class AppTextfieldCircular extends StatefulWidget {
  String? headerTxt;
  double width;
  double? prefixSize;
  double? subfixSize;
  double? hintSize;
  String hint;
  String lable;
  String? suffixImage;
  String? prefixImage;
  IconData? prefixicon;
  bool? isPrefix;
  bool? isSuffix;
  bool? isfilled;
  bool? isReadOnly;
  IconData? subfixicon;
  int? maxLine;
  Function? onTap;
  Function? onTapTextField;
  BorderRadius? redius;
  Radius? onlyRedius;
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  List<TextInputFormatter>? inputFormatters;
  bool? hidePassword;
  Color? sufixColor;
  Color? preFixColor;
  Color? fillColor;
  Color? hintTxtColor;
  Color? borderColor;
  Color? headerTextColor;
  double? headerTextSize;
  FontWeight? headerFontWeight;
  String? fontFamily;

  AppTextfieldCircular(
      {Key? key,
      this.hidePassword,
      required this.width,
      required this.hint,
      required this.lable,
      this.controller,
      this.keyboardType,
      this.textInputAction,
      this.inputFormatters,
      this.redius,
      this.maxLine,
      this.prefixicon,
      this.subfixicon,
      this.preFixColor,
      this.prefixSize,
      this.subfixSize,
      this.hintSize,
      this.sufixColor,
      this.onlyRedius,
      this.isReadOnly,
      this.suffixImage,
      this.hintTxtColor,
      this.prefixImage,
      this.fillColor,
      this.onTap,
      this.onTapTextField,
      this.isPrefix = false,
      this.isSuffix = false,
      this.isfilled = false,
      this.borderColor,
      this.headerTextColor,
      this.headerTextSize,
      this.headerFontWeight,
      this.fontFamily,
      this.headerTxt})
      : super(key: key);

  @override
  State<AppTextfieldCircular> createState() => _AppTextfieldCircularState();
}

class _AppTextfieldCircularState extends State<AppTextfieldCircular> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headerTxt != null && widget.headerTxt!.isNotEmpty)
          AppText(
              text: widget.headerTxt ?? "",
              txtColor: widget.headerTextColor ?? blackShade,
              /*fontFamily: fontSemiBold,*/
              size: widget.headerTextSize ?? 12,
              fontWeight: widget.headerFontWeight ?? FontWeight.normal),
        // Text(widget.headerTxt ?? "", style: AppTxtStyles.titleText(size: 12)),
        const SizedBox(height: 8),
        Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: widget.redius ?? BorderRadius.circular(50),
            ),
            elevation: 0,
            child: Container(
              // height: 40,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: widget.redius ?? BorderRadius.circular(50)),
              child: TextField(
                onTap: () {
                  widget.onTapTextField != null ? widget.onTapTextField!() : '';
                },
                cursorColor: primaryBlack,
                style: TextStyle(fontFamily: widget.fontFamily ?? "Montserrat_Regular", fontSize: 16),
                obscureText: widget.hidePassword ?? false,
                readOnly: widget.isReadOnly ?? false,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onEditingComplete: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                inputFormatters: widget.inputFormatters,
                maxLines: widget.maxLine ?? 1,
                controller: widget.controller,
                decoration: InputDecoration(
                    filled: widget.isfilled,
                    fillColor: widget.isfilled! ? widget.fillColor : null,
                    contentPadding: const EdgeInsets.only(left: 8, right: 10, top: 20, bottom: 2),
                    prefixIcon: widget.isPrefix!
                        ? widget.prefixImage != null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: SizedBox(child: Image(image: AssetImage(widget.prefixImage!), color: primaryGrey)),
                              )
                            : Container(
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                    color: primaryGreyShade,
                                    borderRadius: BorderRadius.only(topLeft: widget.onlyRedius ?? const Radius.circular(10), bottomLeft: widget.onlyRedius ?? const Radius.circular(10))),
                                child: Padding(padding: const EdgeInsets.all(15.0), child: Icon(widget.prefixicon, color: deepBlue, size: widget.prefixSize ?? 26)))
                        : null,
                    suffixIcon: widget.isSuffix!
                        ? widget.suffixImage != null
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(child: SvgPicture.asset(width: 26, height: 22, widget.suffixImage!)) /*Image(image: AssetImage(widget.suffixImage!), color: primaryGrey)*/)
                            : InkWell(
                                onTap: () {
                                  widget.onTap!();
                                },
                                child: Icon(widget.subfixicon, color: widget.sufixColor ?? primaryGrey, size: widget.subfixSize ?? 15))
                        : null,
                    hintText: widget.hint,
                    label: Text(widget.lable),
                    labelStyle: TextStyle(color: widget.hintTxtColor ?? primaryGreyShade3, fontSize: widget.hintSize ?? 12),
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(color: widget.hintTxtColor ?? primaryGreyShade3, fontSize: widget.hintSize ?? 12),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.borderColor ?? primaryGreyShade3), borderRadius: widget.redius ?? BorderRadius.circular(50)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: widget.borderColor ?? deepBlue.withOpacity(0.5)),
                      borderRadius: widget.redius ?? BorderRadius.circular(50),
                    )),
              ),
            )),
        const SizedBox(height: 12),
      ],
    );
  }
}

class AppTextfield extends StatelessWidget {
  double? width;
  double? height;
  double? hintSize;
  String hint;
  String lable;
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  List<TextInputFormatter>? inputFormatters;
  int? maxLength;
  bool? readOnly;
  bool? obscureText;
  IconData? prefixicon;
  IconButton? sufixicon;
  Function? ontap;
  Function? onChange;
  bool? isExpands;
  Color? enabledBorderColor;
  int? maxLine;

  AppTextfield(
      {Key? key,
      this.height,
       this.width,
      required this.hint,
      required this.lable,
      this.obscureText,
      this.readOnly,
      this.controller,
      this.hintSize,
      this.maxLength,
      this.keyboardType,
      this.textInputAction,
      this.inputFormatters,
      this.prefixicon,
      this.sufixicon,
      this.ontap,
      this.onChange,this.isExpands,this.enabledBorderColor,this.maxLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        // style: const TextStyle(color: skyBlueShade3),
        textAlign: TextAlign.start,textAlignVertical: TextAlignVertical.top,
        maxLines: maxLine ?? 1,
          expands: isExpands ?? false,
        onTap: () {
          if (ontap != null) ontap!();
        },
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (value) {
          onChange != null ? onChange!() : '';
          // if (onChange != null) onChange!(value);
        },
        maxLength: maxLength,
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.done,
        inputFormatters: inputFormatters,
        controller: controller,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            prefixIcon: prefixicon != null ? Icon(prefixicon, color: primaryGrey, size: 20) : null,
            suffixIcon:sufixicon ,
            counterText: '',
            filled: true,
            fillColor: primaryWhite,
            hintText: hint,
            label: Text(lable),
            floatingLabelAlignment: FloatingLabelAlignment.start,alignLabelWithHint: true,
            labelStyle: TextStyle(color: skyBlueShade3, fontSize: hintSize ?? 14),
            hintStyle: TextStyle(color: skyBlueShade3, fontSize: hintSize ?? 14),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(width: 1, color:enabledBorderColor ?? skyBlueShade1),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: skyBlueShade1),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
