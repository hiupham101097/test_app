import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class TranslationService extends Translations {
  static final langs = ['vi', 'en'];

  static final locales = [const Locale('vi'), const Locale('en')];

  static final fallbackLocale = const Locale('vi');

  static final Map<String, Map<String, String>> _translations = {};

  static Future<void> init() async {
    for (var lang in langs) {
      final jsonString = await rootBundle.loadString('assets/lang/$lang.json');
      _translations[lang] = Map<String, String>.from(json.decode(jsonString));
    }
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;
  static Future<void> changeLanguage(String langCode) async {
    final locale = Locale(langCode);
    await Get.updateLocale(locale);
  }

  // Helper method to get current language
  static String getCurrentLanguage() {
    return Get.locale?.languageCode ?? 'vi';
  }

  // Helper method to get language name
  static String getLanguageName(String langCode) {
    switch (langCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return 'Tiếng Việt';
    }
  }
}
