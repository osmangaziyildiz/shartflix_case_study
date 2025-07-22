import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;

extension LocalizedString on String {
  String get localized => LocalizationManager.getLocalizedString(this);
}

class LocalizationManager {
  static const Map<String, String> _specialFallbacks = {
    'pt': 'pt-PT', // Portekizce'nin herhangi bir varyantı gelirse pt-PT kullan.
    'es': 'es-MX', // İspanyolcanın herhangi bir varyantı gelirse es-MX kullan.
  };

  static const String _defaultLanguage = 'tr';

  static String? currentLanguage;
  static Map<String, Map<String, String>> translations = {};
  static Set<String> supportedLanguages = {};

  static Future<void> init() async {
    String jsonString = await rootBundle.loadString(
      'assets/localization/Localizable.json',
    );
    Map<String, dynamic> strings = json.decode(jsonString);

    for (var entry in strings.entries) {
      String key = entry.key;
      Map<String, dynamic> stringEntry = entry.value;

      if (stringEntry.containsKey('localizations')) {
        Map<String, dynamic> localizations = stringEntry['localizations'];
        if (localizations.containsKey('en')) {
          translations[key] = {};
          for (var lang in localizations.keys) {
            translations[key]?[lang] = localizations[lang];
            supportedLanguages.add(lang);
          }
        }
      }
    }

    fetchLanguage();
  }

  static void fetchLanguage() {
    final String locale = PlatformDispatcher.instance.locale.toLanguageTag();

    // 1. Birebir Eşleşme Kontrolü
    if (supportedLanguages.contains(locale)) {
      currentLanguage = locale;
      return;
    }

    // Eşleşme yoksa, ana dil kodunu al.
    final String base = locale.split('-')[0];

    // 2. Özel Kural (Fallback) Kontrolü
    if (_specialFallbacks.containsKey(base)) {
      final String fallbackLanguage = _specialFallbacks[base]!;
      if (supportedLanguages.contains(fallbackLanguage)) {
        currentLanguage = fallbackLanguage;
        return;
      }
    }

    // 3. Ana Dil Kodu Kontrolü
    if (supportedLanguages.contains(base)) {
      currentLanguage = base;
      return;
    }

    // 4. Varsayılan Dile Dönme
    currentLanguage = _defaultLanguage;
  }

  static String getLocalizedString(String text) {
    String key = text;
    if (translations.containsKey(key)) {
      Map<String, String> langTranslations = translations[key]!;
      if (langTranslations.containsKey(currentLanguage)) {
        return langTranslations[currentLanguage]!;
      } else {
        return langTranslations['tr']!; // Hata olursa Türkçe dönüş yapılır.
      }
    }
    return text; // Eğer key bulunamazsa orjinal text dönüş yapılır.
  }
}
