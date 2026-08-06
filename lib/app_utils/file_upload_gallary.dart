import 'dart:io';

import 'package:flutter/material.dart';

import 'image_helper.dart';



Future<File?> selectImageFromGallery(BuildContext context) async {
  final pickedFile = await ImageHelper.pickImageFromGallery(context: context, title: 'Image');
  if (pickedFile != null) {

    return pickedFile;

    //
  }
  return null;
}

Future<File?> selectImageFromCamera(BuildContext context) async {
  final pickedFile = await ImageHelper.pickImageFromCamera(context: context, title: 'Image');
  if (pickedFile != null) {

    return pickedFile;

    //
  }
  return null;
}