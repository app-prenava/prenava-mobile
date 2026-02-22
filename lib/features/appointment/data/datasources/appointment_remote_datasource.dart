import 'package:dio/dio.dart';
import '../models/appointment_model.dart';
import '../models/bidan_profile_model.dart';
import '../models/consent_info_model.dart';
import '../models/consultation_type_model.dart';

class AppointmentRemoteDatasource {
  final Dio _dio;

  AppointmentRemoteDatasource(this._dio);

  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _dio.get('/user/appointments');

      if (response.statusCode == 200) {
        final data = response.data;
        print('APPOINTMENTS RAW DATA: ' + data.toString());
        print('APPOINTMENTS DATA TYPE: ' + data.runtimeType.toString());

        if (data is Map<String, dynamic>) {
          dynamic rawData = data['data'];
          List<dynamic>? appointmentsData;

          if (rawData is List) {
            appointmentsData = rawData;
          } else if (rawData is Map<String, dynamic>) {
            if (rawData.containsKey('data') && rawData['data'] is List) {
              appointmentsData = rawData['data'] as List<dynamic>;
            } else if (rawData.containsKey('data') && rawData['data'] == null) {
               appointmentsData = [];
            } else if (rawData.isEmpty) {
              appointmentsData = [];
            } else {
              appointmentsData = rawData.values.toList();
            }
          }

          if (appointmentsData != null) {
            return appointmentsData
                .map(
                  (json) =>
                      AppointmentModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
          }
        } else if (data is List) {
          return data
              .map(
                (json) =>
                    AppointmentModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }

        return [];
      } else {
        throw Exception('Failed to load appointments');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load appointments',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<AppointmentModel> getAppointmentById(int id) async {
    try {
      final response = await _dio.get('/user/appointments/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final appointmentData = data['data'];
          if (appointmentData != null) {
            return AppointmentModel.fromJson(
              appointmentData as Map<String, dynamic>,
            );
          }
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load appointment');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load appointment',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<BidanProfileModel>> getBidanProfiles() async {
    try {
      final response = await _dio.get('/user/bidans/locations');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          dynamic rawData = data['data'];
          List<dynamic>? bidansData;

          if (rawData is List) {
            bidansData = rawData;
          } else if (rawData is Map<String, dynamic>) {
            if (rawData.containsKey('data') && rawData['data'] is List) {
              bidansData = rawData['data'] as List<dynamic>;
            } else if (rawData.isEmpty) {
              bidansData = [];
            } else {
              bidansData = rawData.values.toList();
            }
          }

          if (bidansData != null) {
            return bidansData
                .map(
                  (json) =>
                      BidanProfileModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
          }
        } else if (data is List) {
          return data
              .map(
                (json) =>
                    BidanProfileModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }

        return [];
      } else {
        throw Exception('Failed to load bidans');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load bidans');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<BidanProfileModel> getBidanProfileById(int id) async {
    try {
      final response = await _dio.get('/user/bidans/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final bidanData = data['data'];
          if (bidanData != null) {
            return BidanProfileModel.fromJson(
              bidanData as Map<String, dynamic>,
            );
          }
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load bidan profile');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load bidan profile',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<ConsentInfoModel> getConsentInfo() async {
    try {
      final response = await _dio.get('/user/consent-info');
      print('CONSENT INFO DATA: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final consentData = data['data'];
          if (consentData != null) {
            return ConsentInfoModel.fromJson(
              consentData as Map<String, dynamic>,
            );
          }
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load consent info');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('CONSENT ERROR: ${e.response?.data}');
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load consent info',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<ConsultationTypeModel>> getConsultationTypes() async {
    try {
      final response = await _dio.get('/user/consultation-types');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          dynamic rawData = data['data'];
          List<dynamic>? typesData;

          if (rawData is List) {
            typesData = rawData;
          } else if (rawData is Map<String, dynamic>) {
            if (rawData.containsKey('data') && rawData['data'] is List) {
              typesData = rawData['data'] as List<dynamic>;
            } else if (rawData.isEmpty) {
              typesData = [];
            } else {
              typesData = rawData.values.toList();
            }
          }

          if (typesData != null) {
            return typesData
                .map(
                  (json) => ConsultationTypeModel.fromJson(
                    json as Map<String, dynamic>,
                  ),
                )
                .toList();
          }
        } else if (data is List) {
          return data
              .map(
                (json) => ConsultationTypeModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
        }

        return [];
      } else {
        throw Exception('Failed to load consultation types');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load consultation types',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<AppointmentModel> createAppointment(
    Map<String, dynamic> request,
  ) async {
    try {
      final response = await _dio.post('/user/appointments', data: request);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final appointmentData = data['data'];
          if (appointmentData != null) {
            return AppointmentModel.fromJson(
              appointmentData as Map<String, dynamic>,
            );
          }
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to create appointment');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('CREATE APPOINTMENT ERROR RESPONSE: ${e.response?.data}');
        throw Exception(
          e.response?.data['message'] ?? 'Failed to create appointment',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<bool> cancelAppointment(int id) async {
    try {
      final response = await _dio.patch('/user/appointments/$id/cancel');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to cancel appointment',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
