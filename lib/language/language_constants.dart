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

  // 3. Dynamic Deductible Pattern: e.g. "0% Deductible", "5% Deductible", "Deductible 0%", "Deductible 10%"
  final deductibleRegex1 = RegExp(r'^(\d+\.?\d*%\s*)deductible$', caseSensitive: false);
  final deductibleRegex2 = RegExp(r'^deductible\s*(\d+\.?\d*%\s*)$', caseSensitive: false);
  final match1 = deductibleRegex1.firstMatch(trimmed);
  final match2 = deductibleRegex2.firstMatch(trimmed);
  if (match1 != null || match2 != null) {
    String percent = (match1?.group(1) ?? match2?.group(1) ?? '').trim();
    String deductibleWord = _localizedValues['Deductible'] ?? _localizedValues['deductible'] ?? 'Deductible';
    bool isAr = (languageCode == 'ar') || (context != null && Localizations.localeOf(context).languageCode == 'ar') || deductibleWord.contains(RegExp(r'[\u0600-\u06FF]'));
    if (isAr) {
      return "$deductibleWord $percent";
    } else {
      return "$percent $deductibleWord";
    }
  }

  // 4. Lowercase match
  value = _localizedValues[trimmed.toLowerCase()];
  if (value != null && value.isNotEmpty) return value;

  // 5. Normalized whitespace match
  String singleSpaced = trimmed.replaceAll(RegExp(r'\s+'), ' ');
  value = _localizedValues[singleSpaced];
  if (value != null && value.isNotEmpty) return value;

  // 6. Dynamic Loading Pattern: e.g. "Loading Terms & Conditions...", "Loading...", "Loading"
  final loadingRegex = RegExp(r'^Loading\s*(.*?)(\.{0,3})$', caseSensitive: false);
  final loadingMatch = loadingRegex.firstMatch(trimmed);
  if (loadingMatch != null) {
    String inner = loadingMatch.group(1)?.trim() ?? '';
    bool isAr = (languageCode == 'ar') || (context != null && Localizations.localeOf(context).languageCode == 'ar') || (_localizedValues['home'] == 'الرئيسية') || (_localizedValues['termsConditions'] == 'الشروط والأحكام');
    if (inner.isEmpty) {
      return isAr ? "جارٍ التحميل..." : "Loading...";
    } else {
      String translatedInner = getTranslated(context, inner);
      return isAr ? "جارٍ تحميل $translatedInner..." : "Loading $translatedInner...";
    }
  }

  // 7. Try DemoLocalization if context is available
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
