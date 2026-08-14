
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<File?> pickImageFromGallery({
    required BuildContext context,
    required String title,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var file = File(pickedFile.path);
      return file;
    }
    return null;
  }

  static Future<File?> pickImageFromCamera({
    required BuildContext context,
    // required CropStyle cropStyle,
    required String title,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return null;
    var file = File(pickedFile.path);
    return file;
  }

}
