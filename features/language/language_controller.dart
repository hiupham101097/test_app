import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/translation_service.dart';

class LanguageController extends GetxController {
  static const String LANGUAGE_KEY = 'selected_language';

  final RxString _currentLanguage = 'en'.obs;

  String get currentLanguage => _currentLanguage.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(LANGUAGE_KEY) ?? 'en';
    _currentLanguage.value = savedLanguage;
    await TranslationService.changeLanguage(savedLanguage);
  }

  Future<void> changeLanguage(String langCode) async {
    _currentLanguage.value = langCode;
    await TranslationService.changeLanguage(langCode);
    await _saveLanguagePreference(langCode);
  }

  Future<void> _saveLanguagePreference(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_KEY, langCode);
  }

  List<Map<String, String>> get availableLanguages => [
    {'code': 'vi', 'name': TranslationService.getLanguageName('vi')},
    {'code': 'en', 'name': TranslationService.getLanguageName('en')},
  ];
}
