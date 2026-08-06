
import 'package:flutter/material.dart';

import 'app_text.dart';
import 'color_constrint.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(String msg,context){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: AppText(
        text: msg,
        txtColor: primaryWhite,
        size: 12,
      )));
}