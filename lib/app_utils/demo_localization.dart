import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalization {
  DemoLocalization(this.locale);

  final Locale locale;

  static DemoLocalization? of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  Map<String, String> _localizedValues = {};

  Future<void> load() async {
    try {
      String jsonStringValues = await rootBundle.loadString('lib/language/${locale.languageCode}.json');
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
      _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      print('DemoLocalization load error: $e');
    }
  }

  String? translate(String key) {
    if (key.isEmpty) return key;
    String trimmed = key.trim();
    if (num.tryParse(trimmed) != null) {
      return key;
    }
    String? val = _localizedValues[key];
    if (val != null && val.isNotEmpty) return val;
    val = _localizedValues[trimmed];
    if (val != null && val.isNotEmpty) return val;
    val = _localizedValues[trimmed.toLowerCase()];
    if (val != null && val.isNotEmpty) return val;
    String singleSpaced = trimmed.replaceAll(RegExp(r'\s+'), ' ');
    val = _localizedValues[singleSpaced];
    if (val != null && val.isNotEmpty) return val;

    final loadingRegex = RegExp(r'^Loading\s*(.*?)(\.{0,3})$', caseSensitive: false);
    final loadingMatch = loadingRegex.firstMatch(trimmed);
    if (loadingMatch != null) {
      String inner = loadingMatch.group(1)?.trim() ?? '';
      bool isAr = (locale.languageCode == 'ar') || (_localizedValues['termsConditions'] == 'الشروط والأحكام') || (_localizedValues['home'] == 'الرئيسية');
      if (inner.isEmpty) {
        return isAr ? "جارٍ التحميل..." : "Loading...";
      } else {
        String translatedInner = translate(inner) ?? inner;
        return isAr ? "جارٍ تحميل $translatedInner..." : "Loading $translatedInner...";
      }
    }
    return key;
  }

  static const LocalizationsDelegate<DemoLocalization> delegate = _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    DemoLocalization localization = DemoLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<DemoLocalization> old) => false;
}
