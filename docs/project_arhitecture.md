lib/
├── core/                        # Tüm modüllerde ortak yapılar
│   ├── network/                 # Network utils, connectivity checker
│   ├── usecase/                 # Base UseCase abstract sınıfı
│   └── utils/                   # Genel yardımcı fonksiyonlar, extensions
│
├── features/
│   └── auth/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── screens/         # LoginScreen, RegisterScreen
│           ├── viewmodel/       # LoginBloc, LoginEvent, LoginState
│           └── widgets/
├── app/
│   ├── router/
│   ├── theme/
│   └── app.dart
├── main.dart