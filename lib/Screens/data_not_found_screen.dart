import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class DataNotFoundScreen extends StatefulWidget {
  String title;
  String subTitle;
   DataNotFoundScreen({super.key,required this.title,required this.subTitle});

  @override
  State<DataNotFoundScreen> createState() => _DataNotFoundScreenState();
}

class _DataNotFoundScreenState extends State<DataNotFoundScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 300,
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: deepBluedark),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(searchImg),
          AppText(text: widget.title, size: 16, fontWeight: FontWeight.w700),
          AppText(text: widget.subTitle, size: 15, txtColor:skyBlueShade3),
        ],
      ),
    );
  }
}
