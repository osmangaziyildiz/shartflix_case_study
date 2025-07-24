lib/
├── core/                        # Tüm modüllerde ortak yapılar
│   ├── network/                 # Network utils, connectivity checker
│   ├── constants/               # App boyunca sabit değerler path, color vb.
│   ├── navigation/              # App'in route tanımları ve merkezi router yönetimi.
│   ├── widgets/                 # Resuable ve ortak widget'lar.
│   └── utils/                   # Genel yardımcı fonksiyonlar, extensions.
│
├── features/                    # Feature-first mimari, her özellik kendi dosyalarından sorumludur.
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
├── main.dart