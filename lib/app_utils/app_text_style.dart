import 'package:flutter/material.dart';

class AppTxtStyles {
  static regularText({Color? color, FontWeight? weight, double? size, TextDecoration? decoration}) => TextStyle(
    color: color ?? Colors.black,
    fontSize: size ?? 14,
    fontWeight: weight ?? FontWeight.normal,
    decoration: decoration,
  );

  static titleText({Color? color, FontWeight? weight, double? size}) => TextStyle(
    color: color ?? Colors.black,
    fontSize: size ?? 18,
    fontWeight: weight ?? FontWeight.bold,
  );

  static hintText({Color? color, FontWeight? weight, double? size}) => TextStyle(
    color: color ?? Colors.grey,
    fontSize: size ?? 14,
    fontWeight: weight ?? FontWeight.normal,
  );
}