
import 'package:flutter/widgets.dart';

class Utils {
  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return false;
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegExp.hasMatch(email.trim());
  }

  static bool heightWeightValidation({required String height, required String weight}) {
    final double? heightCm = double.tryParse(height.trim());
    final double? weightKg = double.tryParse(weight.trim());

    if (heightCm == null || weightKg == null || heightCm <= 0 || weightKg <= 0) {
      return false;
    }

    final double heightM = heightCm / 100;
    final double bmi = weightKg / (heightM * heightM);

    bool acceptable = (bmi > 17 && bmi <= 35);

    return !acceptable;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
