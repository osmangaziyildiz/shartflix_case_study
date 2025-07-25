# LoggerService Mimarisi ve Kullanımı

Bu döküman, projemizdeki `LoggerService`'in amacını ve temel kullanımını açıklar.

## Amaç

`LoggerService`, uygulama içinde oluşan kritik sistem hatalarını ve beklenmedik programlama hatalarını yakalayıp merkezi bir yerden Firebase Crashlytics'e bildirmek için tasarlanmıştır. Bu servis sayesinde, uygulama çökmese bile arka planda oluşan sorunlardan haberdar oluruz.

## Temel Kullanım

Servis, `get_it` ile `singleton` olarak yönetilir ve temel kullanım alanı **Repository (`RepositoryImpl`)** katmanlarıdır.

### 1. Hataları Akıllıca Loglama

En önemli özelliği, "kullanıcı hatası" (örn: yanlış şifre) ile "sistem hatası" (örn: sunucuya ulaşılamıyor) arasında ayrım yapmasıdır. Sadece sistemin sağlığını etkileyen gerçek hatalar loglanır.

**Örnek: `AuthRepositoryImpl` içinde**
```dart
@override
Future<UserEntity> login({ ... }) async {
  try {
    // ... Başarılı durum mantığı ...
  } on ServerException catch (e, stackTrace) {
    // Sadece sunucu/ağ hatası (5xx) ise logla, kullanıcı hatasını (4xx) loglama.
    if (e.statusCode == null || e.statusCode! >= 500) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'AuthRepository: Giriş sırasında sunucu/ağ hatası',
      );
    }
    rethrow; // Mevcut hata akışının devam etmesi için hatayı tekrar fırlat.
  } catch (e, stackTrace) {
    // Diğer tüm beklenmedik hataları (kodlama hataları vb.) logla.
    logger.recordError(
      exception: e,
      stackTrace: stackTrace,
      reason: 'AuthRepository: Giriş sırasında beklenmedik bir hata oluştu',
      fatal: true,
    );
    rethrow;
  }
}
```

### 2. Kullanıcı Kimliğini Ayarlama

Hataları belirli bir kullanıcıyla ilişkilendirmek için `setUserIdentifier` metodu kullanılır. Bu metot, kullanıcı giriş yaptığında bir kez çağrılır ve çıkış yaptığında temizlenir.

**Örnek: `AuthRepositoryImpl` içinde**
```dart
// Giriş başarılı olduğunda
await logger.setUserIdentifier('kullanici_email@ornek.com');

// Çıkış yapıldığında
await logger.setUserIdentifier('');
``` 