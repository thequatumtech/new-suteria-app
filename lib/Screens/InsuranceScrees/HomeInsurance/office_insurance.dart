import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';


class HomefirstScreen extends StatefulWidget {
  Function onNext;
  HomefirstScreen({super.key,required this.onNext});

  @override
  State<HomefirstScreen> createState() => _HomefirstScreenState();
}

class _HomefirstScreenState extends State<HomefirstScreen> {
  List names=[
    mobileno,
    email
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: mobileno, lable: mobileno),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextfield(width: 10, hint: email, lable: email),
        ),
        /*InkWell(
          onTap: () =>widget.onNext(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(buttonImg,
              height: 100,

            ),
          ),
        ),*/
        AppBtnWithColorShades(
          onTap: () {
            widget.onNext();
          },
          btnTxt: continuE,
          color1: darkBlue2,
          color2: darkBlue1,
        ),
      ],
    );
  }
}
