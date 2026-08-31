import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/app_utils/app_constrint.dart';
import 'package:soperia_user/app_utils/demo_localization.dart';
import 'package:soperia_user/main.dart';

const String LAGUAGE_CODE = 'LAGUAGE_CODE';

const String ENGLISH = 'en';
const String ARBIC = 'ar';

Future<Locale> setLocale(String langCode, [BuildContext? context]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, langCode);
  await prefs.setString('selected_language', langCode);
  languageCode = langCode;
  Locale locale = getLangFromCode(langCode == "ar" ? 'ar' : 'en');
  try {
    Get.updateLocale(locale);
  } catch (e) {
    print('Get.updateLocale error: $e');
  }
  if (context != null) {
    try {
      MyApp.setLocale(context, locale);
    } catch (e) {
      print('MyApp.setLocale error: $e');
    }
  }
  await loadLangs();
  return locale;
}

Future<String> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? saved = prefs.getString(LAGUAGE_CODE) ?? prefs.getString('selected_language');
  if (saved != null && saved.isNotEmpty) {
    return saved;
  }
  String systemLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  return (systemLang == 'ar') ? 'ar' : 'en';
}

Locale getLangFromCode(String langCode) {
  switch (langCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case ARBIC:
      return const Locale(ARBIC, "ARE");
    default:
      return const Locale(ENGLISH, 'US');
  }
}

Map<String, String> _localizedValues = {};

Future<void> loadLangs([String? lang]) async {
  try {
    String code = lang ?? languageCode ?? await getLocale();
    languageCode = code;
    String jsonStringValues = await rootBundle.loadString('lib/language/$code.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  } catch (e) {
    print('Error loading language file: $e');
  }
}

String getTranslated(BuildContext? context, String key) {
  if (key.isEmpty) return key;

  String trimmed = key.trim();
  // Do not translate pure numbers / timer digits / quantities / IDs
  if (num.tryParse(trimmed) != null) {
    return key;
  }

  // 1. Direct match
  String? value = _localizedValues[key];
  if (value != null && value.isNotEmpty) return value;

  // 2. Trimmed match
  value = _localizedValues[trimmed];
  if (value != null && value.isNotEmpty) return value;

  // 3. Lowercase match
  value = _localizedValues[trimmed.toLowerCase()];
  if (value != null && value.isNotEmpty) return value;

  // 4. Normalized whitespace match
  String singleSpaced = trimmed.replaceAll(RegExp(r'\s+'), ' ');
  value = _localizedValues[singleSpaced];
  if (value != null && value.isNotEmpty) return value;

  // 5. Try DemoLocalization if context is available
  if (context != null) {
    try {
      String? demoVal = DemoLocalization.of(context)?.translate(key);
      if (demoVal != null && demoVal != key && demoVal.isNotEmpty) {
        return demoVal;
      }
    } catch (_) {}
  }

  return key;
}

/// Helper function to translate backend response messages / error messages
String translateBackendMessage(dynamic msg, [BuildContext? context]) {
  if (msg == null) return '';
  String text = msg.toString().trim();
  if (text.isEmpty) return '';
  return getTranslated(context, text);
}

const PROFILE_PAGE = [
  {
    'title': "edit_profile",
    'icon': "assets/images/edit.png"
  },
  {
    'title': "change_password",
    'icon': "assets/images/edit.png"
  },
  {
    'title': "language",
    'icon': "assets/images/language.png"
  },
  {
    'title': "noon_shop",
    'icon': "assets/images/purchase.png"
  },
  {
    'title': "delete_acc",
    'icon': "assets/images/delete_account.png"
  },
  {
    'title': "privacy_policy",
    'icon': "assets/images/privacy.png"
  },
  {
    'title': "device_manager",
    'icon': "assets/images/mobile_manager.png"
  },
  {
    'title': "notebook",
    'icon': "assets/images/notebook.png"
  },
  {
    'title': "feedback_just",
    'icon': "assets/images/feedback.png"
  },
  {
    'title': "logout",
    'icon': "assets/images/logout.png"
  }
];

const BOTTOM_SHEET_PAGE = [
  {
    'title': "feed_app_problem",
    'icon': "assets/images/setting_icon.png"
  },
  {
    'title': "feed_video_problem",
    'icon': "assets/images/video.png"
  },
  {
    'title': "feed_text_problem",
    'icon': "assets/images/text.png"
  },
  {
    'title': "feed_homework_problem",
    'icon': "assets/images/exercise.png"
  },
  {
    'title': "feed_chapter_problem",
    'icon': "assets/images/chapter.png"
  },
  {
    'title': "feed_exam_problem",
    'icon': "assets/images/exam.png"
  },
  {
    'title': "feed_general_problem",
    'icon': "assets/images/global.png"
  },
];

const LANGUAGE_PAGE = [
  {
    'title': "English",
  },
  {
    'title': "اَلْعَرَبِيَّةُ",
  },
];
