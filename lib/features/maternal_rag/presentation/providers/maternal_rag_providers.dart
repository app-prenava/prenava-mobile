import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/maternal_rag_remote_datasource.dart';
import '../../data/models/maternal_rag_model.dart';

final maternalRagDatasourceProvider = Provider<MaternalRagRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return MaternalRagRemoteDatasource(dio);
});

class MaternalRagState {
  final bool isLoading;
  final String? errorMessage;
  final List<MaternalConsultationItem> consultations;
  final List<DangerCategoryItem> dangerCatalog;
  final bool isLoadingCatalog;
  final String? catalogError;
  final MaternalConsultationItem? activeEmergency;

  // Geolocation & Nearby Healthcare Facilities State
  final double userLat;
  final double userLng;
  final bool isUsingGpsLocation;
  final String locationStatusText;
  final bool isLoadingFacilities;
  final String? facilitiesError;
  final List<HealthcareFacilityItem> nearbyFacilities;
  final String selectedFacilityFilter; // 'all', 'bidan_mitra', 'rs_puskesmas'

  const MaternalRagState({
    this.isLoading = false,
    this.errorMessage,
    this.consultations = const [],
    this.dangerCatalog = const [],
    this.isLoadingCatalog = false,
    this.catalogError,
    this.activeEmergency,
    this.userLat = -6.9175,
    this.userLng = 107.6191,
    this.isUsingGpsLocation = false,
    this.locationStatusText = 'Jarak dihitung dari pusat Kota Bandung',
    this.isLoadingFacilities = false,
    this.facilitiesError,
    this.nearbyFacilities = const [],
    this.selectedFacilityFilter = 'all',
  });

  List<HealthcareFacilityItem> get filteredFacilities {
    if (selectedFacilityFilter == 'bidan_mitra') {
      return nearbyFacilities.where((f) => f.isPartnerBidan).toList();
    }
    if (selectedFacilityFilter == 'rs_puskesmas') {
      return nearbyFacilities.where((f) => !f.isPartnerBidan).toList();
    }
    return nearbyFacilities;
  }

  MaternalRagState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<MaternalConsultationItem>? consultations,
    List<DangerCategoryItem>? dangerCatalog,
    bool? isLoadingCatalog,
    String? catalogError,
    bool clearCatalogError = false,
    MaternalConsultationItem? activeEmergency,
    bool clearEmergency = false,
    double? userLat,
    double? userLng,
    bool? isUsingGpsLocation,
    String? locationStatusText,
    bool? isLoadingFacilities,
    String? facilitiesError,
    bool clearFacilitiesError = false,
    List<HealthcareFacilityItem>? nearbyFacilities,
    String? selectedFacilityFilter,
  }) {
    return MaternalRagState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      consultations: consultations ?? this.consultations,
      dangerCatalog: dangerCatalog ?? this.dangerCatalog,
      isLoadingCatalog: isLoadingCatalog ?? this.isLoadingCatalog,
      catalogError:
          clearCatalogError ? null : (catalogError ?? this.catalogError),
      activeEmergency:
          clearEmergency ? null : (activeEmergency ?? this.activeEmergency),
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      isUsingGpsLocation: isUsingGpsLocation ?? this.isUsingGpsLocation,
      locationStatusText: locationStatusText ?? this.locationStatusText,
      isLoadingFacilities: isLoadingFacilities ?? this.isLoadingFacilities,
      facilitiesError: clearFacilitiesError
          ? null
          : (facilitiesError ?? this.facilitiesError),
      nearbyFacilities: nearbyFacilities ?? this.nearbyFacilities,
      selectedFacilityFilter:
          selectedFacilityFilter ?? this.selectedFacilityFilter,
    );
  }
}

class MaternalRagNotifier extends StateNotifier<MaternalRagState> {
  final MaternalRagRemoteDatasource _datasource;

  MaternalRagNotifier(this._datasource) : super(const MaternalRagState()) {
    init();
  }

  Future<void> init() async {
    await Future.wait([
      fetchDangerCatalog(),
      fetchHistory(),
      refreshLocationAndFacilities(requestPermissionIfNeeded: true),
    ]);
  }

  Future<void> fetchDangerCatalog() async {
    state = state.copyWith(isLoadingCatalog: true, clearCatalogError: true);
    try {
      final catalog = await _datasource.getDangerCatalog();
      state = state.copyWith(
        dangerCatalog: catalog,
        isLoadingCatalog: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingCatalog: false,
        catalogError: 'Gagal memuat katalog tanda bahaya Buku KIA.',
      );
    }
  }

  Future<void> fetchHistory() async {
    try {
      final history = await _datasource.getHistory();
      if (history.isNotEmpty) {
        state = state.copyWith(
          consultations: history,
        );
      }
    } catch (_) {}
  }

  /// Akuisisi Koordinat GPS 3-Tier (Hardware GPS -> Last Known -> Default Wilayah)
  /// dilanjutkan pengambilan Faskes Mitra Prenava + OpenStreetMap Overpass API
  Future<void> refreshLocationAndFacilities({
    bool requestPermissionIfNeeded = true,
  }) async {
    state = state.copyWith(
      isLoadingFacilities: true,
      clearFacilitiesError: true,
    );

    double resolvedLat = state.userLat;
    double resolvedLng = state.userLng;
    bool usingGps = false;
    String statusText =
        'Jarak dari pusat Kota Bandung. Ketuk Akurasi GPS untuk memakai lokasi Bunda.';

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 2), onTimeout: () => false);
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission()
            .timeout(
              const Duration(seconds: 2),
              onTimeout: () => LocationPermission.denied,
            );
        if (permission == LocationPermission.denied &&
            requestPermissionIfNeeded) {
          permission = await Geolocator.requestPermission().timeout(
            const Duration(seconds: 3),
            onTimeout: () => LocationPermission.denied,
          );
        }

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          try {
            // Tier 1: Hardware GPS / FusedLocationProvider
            final pos = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                timeLimit: Duration(seconds: 6),
              ),
            );
            resolvedLat = pos.latitude;
            resolvedLng = pos.longitude;
            usingGps = true;
            statusText = 'Diurutkan dari lokasi Bunda saat ini (GPS aktif)';
          } catch (_) {
            // Tier 2: Last Known Position
            final lastPos = await Geolocator.getLastKnownPosition();
            if (lastPos != null) {
              resolvedLat = lastPos.latitude;
              resolvedLng = lastPos.longitude;
              usingGps = true;
              statusText = 'Diurutkan dari lokasi terakhir perangkat Bunda';
            }
          }
        }
      }
    } catch (_) {
      // Tier 3: Tetap gunakan koordinat fallback Bandung bila platform tidak mendukung GPS
    }

    try {
      final facilities = await _datasource.getNearbyHealthcareFacilities(
        userLat: resolvedLat,
        userLng: resolvedLng,
      );

      state = state.copyWith(
        userLat: resolvedLat,
        userLng: resolvedLng,
        isUsingGpsLocation: usingGps,
        locationStatusText: statusText,
        isLoadingFacilities: false,
        nearbyFacilities: facilities,
      );
    } catch (e) {
      state = state.copyWith(
        userLat: resolvedLat,
        userLng: resolvedLng,
        isUsingGpsLocation: usingGps,
        locationStatusText: statusText,
        isLoadingFacilities: false,
        facilitiesError:
            'Gagal memperbarui daftar fasilitas kesehatan terdekat. Periksa koneksi internet Anda.',
      );
    }
  }

  void setFacilityFilter(String filter) {
    state = state.copyWith(selectedFacilityFilter: filter);
  }

  Future<void> askText(String query, {int? pregnancyId}) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _datasource.askText(
        query: query.trim(),
        pregnancyId: pregnancyId,
        lat: state.userLat,
        lng: state.userLng,
      );

      final updated = [result, ...state.consultations];
      state = state.copyWith(
        isLoading: false,
        consultations: updated,
        activeEmergency: result.isEmergency ? result : state.activeEmergency,
      );

      if (result.isEmergency && state.nearbyFacilities.isEmpty) {
        await refreshLocationAndFacilities(requestPermissionIfNeeded: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> askVoice(MultipartFile file, {int? pregnancyId}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _datasource.askVoice(
        audioFile: file,
        pregnancyId: pregnancyId,
        lat: state.userLat,
        lng: state.userLng,
      );

      final updated = [result, ...state.consultations];
      state = state.copyWith(
        isLoading: false,
        consultations: updated,
        activeEmergency: result.isEmergency ? result : state.activeEmergency,
      );

      if (result.isEmergency && state.nearbyFacilities.isEmpty) {
        await refreshLocationAndFacilities(requestPermissionIfNeeded: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void dismissEmergency() {
    state = state.copyWith(clearEmergency: true);
  }
}

final maternalRagNotifierProvider =
    StateNotifierProvider<MaternalRagNotifier, MaternalRagState>((ref) {
  final datasource = ref.watch(maternalRagDatasourceProvider);
  return MaternalRagNotifier(datasource);
});
