# AnalyticsService Mimarisi ve Kullanımı

Bu döküman, projemizdeki `AnalyticsService`'in amacını ve temel kullanımını açıklar.

## Amaç

`AnalyticsService`, kullanıcıların uygulama içindeki davranışlarını (hangi butonlara bastıkları, hangi ekranları gezdikleri vb.) izlemek ve bu verileri Firebase Analytics'e göndermek için oluşturulmuştur. Bu servis sayesinde, kullanıcı etkileşimlerini merkezi ve test edilebilir bir yapıda yönetiriz.

## Temel Kullanım

Servis, `get_it` ile `singleton` olarak yönetilir ve projenin herhangi bir yerinden `sl<AnalyticsService>()` ile erişilebilir.

### 1. Standart Olayları Loglama

Kullanıcı giriş (`login`) ve kayıt (`sign_up`) gibi Firebase'in standart olarak tanıdığı olayları loglamak için kullanılır. Bu olaylar, ilgili metotlar çağrılarak tetiklenir.

**Örnek: `AuthRepositoryImpl` içinde**
```dart
// Kullanıcı başarıyla giriş yaptığında
await analytics.logLogin(loginMethod: 'email');

// Kullanıcı başarıyla kayıt olduğunda
await analytics.logSignUp(signUpMethod: 'email');
```

### 2. Özel Olayları Loglama

Uygulamaya özel, standart dışı olayları (`toggle_favorite`, `view_paywall` vb.) loglamak için `logCustomEvent` metodu kullanılır.

**Örnek: `HomeRepositoryImpl` içinde**
```dart
// Kullanıcı bir filmi favorilediğinde
await analytics.logCustomEvent(
  name: 'toggle_favorite',
  parameters: {
    'movie_id': '12345',
  },
);
```

### 3. Kullanıcı Kimliğini Ayarlama

Analitik verilerini belirli bir kullanıcıyla ilişkilendirmek için `setUserId` metodu kullanılır. Bu metot, kullanıcı giriş yaptığında bir kez çağrılır ve çıkış yaptığında `null` değeriyle temizlenir. Bu sayede tüm olaylar doğru kullanıcıya bağlanır.

**Örnek: `AuthRepositoryImpl` içinde**
```dart
// Giriş başarılı olduğunda
await analytics.setUserId(id: 'kullanici_email@ornek.com');

// Çıkış yapıldığında
await analytics.setUserId(id: null);
``` 