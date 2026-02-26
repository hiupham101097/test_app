import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> translations = {};

  @override
  Map<String, Map<String, String>> get keys => translations;

  static Future<void> loadTranslations() async {
    final viJson = await rootBundle.loadString('assets/lang/vi.json');
    final enJson = await rootBundle.loadString('assets/lang/en.json');

    translations['vi'] = Map<String, String>.from(json.decode(viJson));
    translations['en'] = Map<String, String>.from(json.decode(enJson));
  }
}
