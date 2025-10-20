## Prasyarat

- **Flutter SDK** `^3.9.2` (stable) — disarankan pakai [FVM](https://fvm.app/)
- **JDK 17** untuk build Android
- **Android SDK**

## Versi & Dependencies

**Flutter SDK:** `^3.9.2`

**Dependencies Utama:**
- `flutter_riverpod: ^3.0.3` — State management
- `go_router: ^16.2.5` — Routing & navigation
- `dio: ^5.9.0` — HTTP client
- `flutter_secure_storage: ^9.2.4` — Secure storage
- `isar: ^3.1.0+1` — Local database
- `freezed_annotation: ^3.1.0` — Code generation
- `json_annotation: ^4.9.0` — JSON serialization
- `logger: ^2.6.2` — Logging

**Dev Dependencies:**
- `build_runner: ^2.7.1`
- `riverpod_generator: ^3.0.3`
- `freezed: ^3.2.3`
- `json_serializable: ^6.11.1`
- `very_good_analysis: ^10.0.0`

## Instalasi

```bash
flutter pub get
```

## Konfigurasi Environment (Dev)

File konfigurasi environment ada di `env/dev.json`:

```json
{
  "API_BASE": "http://127.0.0.1:8000",
  "ENV": "dev",
  "LOG_LEVEL": "debug"
}
```

## Menjalankan Aplikasi

### Web (Chrome)
```bash
flutter run -d chrome --dart-define-from-file=env/dev.json
```

### Android Emulator
```bash
flutter run -d android --dart-define-from-file=env/dev.json
```

### iOS Simulator
```bash
flutter run -d ios --dart-define-from-file=env/dev.json
```

> **Kenapa pakai `--dart-define-from-file`?**  
> Supaya variabel environment seperti `API_BASE`, `ENV`, dan `LOG_LEVEL` diambil dari `env/dev.json`, bukan default bawaan di kode atau hardcode.

## Testing

```bash
flutter test
```

## Build Runner (Code Generation)

Untuk generate code dari Freezed, Riverpod Generator, dan JSON Serializable:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Atau watch mode untuk auto-generate:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```
