# 🌍 Lokalizasyon Kullanımı

## Nasıl Çalışır?
Metin çevirileri `assets/localization/Localizable.json` dosyasında tutulur. Her metin için farklı dillerdeki karşılıkları tanımlanır.

## JSON Formatı
```json
{
  "Hoş Geldiniz": {
    "localizations": {
      "az": "Xoş gəlmisiniz",
      "de": "Willkommen",
      "en": "Welcome",
      "es-ES": "Bienvenido",
      "es-MX": "Bienvenido",
      "fr": "Bienvenue",
      "it": "Benvenuto",
      "pt-BR": "Bem-vindo",
      "pt-PT": "Bem-vindo",
      "tr": "Hoş geldiniz"
    }
  }
}
```

## Kullanım
Widget'larda string'in sonuna `.localized` ekle:

```dart
Text('Hoş Geldiniz'.localized)
```

## Dil Seçimi
- Cihaz dilini otomatik algılar
- Desteklenmeyen diller için Türkçe fallback
- Varsayılan dil: Türkçe

**Not:** Yeni metin eklerken hem JSON'a hem kod'a aynı key'i yazman yeterli!
