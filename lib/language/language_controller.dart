import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/model_class/get_language_model.dart';

class LanguageController extends GetxController {
  RxList<LanguageData> languages = <LanguageData>[].obs;
  RxBool isLoading = false.obs;
  RxString selectedLanguageCode = 'en'.obs;
  RxInt selectedLanguageId = 7.obs;

  static const String _cachedLanguagesKey = 'cached_languages_list';

  @override
  void onInit() {
    super.onInit();
    _loadInitialState();
    fetchLanguages();
  }

  Future<void> _loadInitialState() async {
    // 1. Load active language code and ID
    String savedCode = await getLocale();
    selectedLanguageCode.value = savedCode;
    int? savedId = await getSavedLanguageId();
    if (savedId != null) {
      selectedLanguageId.value = savedId;
    } else {
      selectedLanguageId.value = (savedCode == 'ar') ? 6 : 7;
    }

    // 2. Load cached languages or use default
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedJson = prefs.getString(_cachedLanguagesKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        List<dynamic> list = json.decode(cachedJson);
        languages.assignAll(list.map((e) => LanguageData.fromJson(e)).toList());
      } catch (_) {}
    }

    if (languages.isEmpty) {
      languages.assignAll([
        LanguageData(id: 6, name: "العربية"),
        LanguageData(id: 7, name: "English"),
      ]);
    }
  }

  Future<void> fetchLanguages([BuildContext? context]) async {
    try {
      isLoading.value = true;
      final api = getIt.get<ApiCall>();
      
      // Use dioClient directly so it works whether context is present or null
      final response = await api.dioClient.get(getLanguage);
      
      if (response.data is Map<String, dynamic>) {
        GetLanguageModelClass model = GetLanguageModelClass.fromJson(response.data);
        if (model.status == true && model.data != null && model.data!.isNotEmpty) {
          languages.assignAll(model.data!);

          // Cache languages locally
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<Map<String, dynamic>> rawList = model.data!.map((e) => e.toJson()).toList();
            await prefs.setString(_cachedLanguagesKey, json.encode(rawList));
          } catch (_) {}

          // Ensure selectedLanguageId is synced
          final current = languages.firstWhereOrNull((l) => l.code == selectedLanguageCode.value);
          if (current != null && current.id != null) {
            selectedLanguageId.value = current.id!;
          }
        }
      }
    } catch (e) {
      print('LanguageController fetchLanguages error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeLanguage(LanguageData lang, BuildContext? context) async {
    selectedLanguageCode.value = lang.code;
    if (lang.id != null) {
      selectedLanguageId.value = lang.id!;
    }
    await setLocale(lang.code, context, lang.id);
  }

  Future<void> changeLanguageByCode(String code, BuildContext? context) async {
    LanguageData? target = languages.firstWhereOrNull((l) => l.code == code);
    if (target != null) {
      await changeLanguage(target, context);
    } else {
      selectedLanguageCode.value = code;
      int id = code == 'ar' ? 6 : 7;
      selectedLanguageId.value = id;
      await setLocale(code, context, id);
    }
  }
}
