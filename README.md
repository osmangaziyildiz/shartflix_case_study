## NOTLAR

- Projede hakkında genel bir bilgi sağlaması açısından projenin kök dizinine "docs" adında bir klasör oluşturdum, bu klasörde teknik dökümantasyonlar yer almakta.

- Film datasındaki "Poster" parametresinde gelen bazı linkler kırık olduğu (çalışmadığı) için "Images" listesindeki ilk görselleri kullandım profil sayfasında.

- Profil sekmesine her geçişte gereksiz durumlarda bile filmler ve profil bilgileri çekilmemesi adına bir Stream yapısı kurdum. Bu stream yapısı sadece bir değişiklik olduğu zaman "favori filmler veya profil bilgileri" çekmek için istek atıp rebuild oluyor.
Yani kullanıcı her "Profil" sekmesine geçtiğinde gereksiz yere API isteği yapılmıyor. Bu sayede daha akıcı ve performanslı bir state yönetimi sağladım.

- Favori ekleme butonuna animasyon ekledim.

- Performans optimizasyonu için LayoutBuilder kullandım.

- Login sonrası token flutter_secure_storage ile güvenli bir şekilde cihaz hafızasına kayıt ediliyor. Fakat şu an "Beni hatırla" veya "Çıkış yap" gibi özellikler istenmediği için app her açıldığında tekrar login olmak gerekiyor. 

- Navigation sırasında herhangi bir hata oluşur ise otomatik olarak yönlendirilecek merkezi hata ekranı kodlandı.

- Paywall ekranındaki tüm gradyan efekler, renkler, bileşenler vs. flutter kodu ile yazılmış hiç birinde hazır figma görseli kullanılmamıştır.

- Figma'da belirtilen Ana sayfa tasarımı haricinde farklı bir ana sayfa tasarımı daha yaptım, filmlerin normal card widget ile gösterildiği. Test etmek için "lib/core/navigation/route_manager.dart" dosyasındaki DiscoverScreen yerine HomeScreen yazmanız yeterli görmek için.

## MİMARİ VE PROJE YAPISI HAKKINDA

- Sınıflara ProfileBloc yerine ProfileViewModel gibi isimler verdim MVVM pattern istendiği için.

- Normalde böyle küçük bir proje için tam kurallı bir clean arhictecture kullanmaya gerek olmadığını düşünüp mail attım fakat maile herhangi bir dönüş olmayınca tam kurallı bir Clean Architecture istendiği düşündüm ve tüm abstract class, usecase, entity vb. katmanları kuralları bir şekilde uyguladım. 

Daha basit olarak şöyle bir yapı kullanılabilirdi:

```
lib/
├── core/                       
│   ├── network/
│   ├── constants/
│   ├── navigation/
│   ├── widgets/
│   └── utils/
│
├── features/
│   └── auth/
│       ├── repositories/
│       │   ├── auth_local_data_sources.dart
│       │   ├── auth_remote_data_sources.dart
│       ├── models/
│       │   ├── login_request_model.dart
│       │   ├── login_response_model.dart
│       ├── viewmodels/
│       │   ├── auth_viewmodel.dart
│       └── screens/
│       │   ├── login_screen.dart
│       │   ├── register_screen.dart
│       └── widgets/
│           ├── custom_textfield.dart
│           ├── custom_button.dart
│
│       └── //.... Diğer featurelar
├── main.dart
```