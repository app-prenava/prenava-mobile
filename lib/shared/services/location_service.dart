import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double? latitude;
  final double? longitude;
  final String? errorMessage;
  final bool isServiceDisabled;
  final bool isPermanentlyDenied;

  const LocationResult({
    this.latitude,
    this.longitude,
    this.errorMessage,
    this.isServiceDisabled = false,
    this.isPermanentlyDenied = false,
  });

  bool get isSuccess => latitude != null && longitude != null;
}

class LocationService {
  static Future<LocationResult> requestAndGetCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationResult(
        errorMessage:
            'Layanan GPS belum aktif. Mohon aktifkan GPS pada perangkat Anda untuk melanjutkan.',
        isServiceDisabled: true,
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LocationResult(
          errorMessage:
              'Izin lokasi wajib diberikan agar Prenava dapat mencari klinik bidan mitra terdekat.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationResult(
        errorMessage:
            'Izin lokasi ditolak permanen. Silakan aktifkan izin lokasi melalui Pengaturan Aplikasi.',
        isPermanentlyDenied: true,
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return LocationResult(
          latitude: lastKnown.latitude,
          longitude: lastKnown.longitude,
        );
      }
      return const LocationResult(
        errorMessage:
            'Gagal mendapatkan titik GPS. Pastikan sinyal GPS baik lalu coba lagi.',
      );
    }
  }

  static Future<bool> openLocationSettings() =>
      Geolocator.openLocationSettings();

  static Future<bool> openAppSettings() => Geolocator.openAppSettings();
}

