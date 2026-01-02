import '../../domain/entities/pregnancy.dart';

class PregnancyModel {
  final String hpht;
  final String hphtFormatted;
  final String hpl;
  final String hplFormatted;
  final PregnancyAge usiaKehamilan;
  final int trimester;
  final String trimesterName;
  final double progressPercentage;
  final PregnancyCountdown countdown;
  final String status;
  final String statusDescription;
  final String? babyName;
  final String? babyGender;
  final FetalSize? fetalSize;

  PregnancyModel({
    required this.hpht,
    required this.hphtFormatted,
    required this.hpl,
    required this.hplFormatted,
    required this.usiaKehamilan,
    required this.trimester,
    required this.trimesterName,
    required this.progressPercentage,
    required this.countdown,
    required this.status,
    required this.statusDescription,
    this.babyName,
    this.babyGender,
    this.fetalSize,
  });

  factory PregnancyModel.fromJson(Map<String, dynamic> json) {
    return PregnancyModel(
      hpht: json['hpht']?.toString() ?? '',
      hphtFormatted: json['hpht_formatted']?.toString() ?? '',
      hpl: json['hpl']?.toString() ?? '',
      hplFormatted: json['hpl_formatted']?.toString() ?? '',
      usiaKehamilan: PregnancyAge.fromJson(json['usia_kehamilan'] as Map<String, dynamic>? ?? {}),
      trimester: (json['trimester'] as num?)?.toInt() ?? 0,
      trimesterName: json['trimester_name']?.toString() ?? '',
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
      countdown: PregnancyCountdown.fromJson(json['countdown'] as Map<String, dynamic>? ?? {}),
      status: json['status']?.toString() ?? '',
      statusDescription: json['status_description']?.toString() ?? '',
      babyName: json['baby_name']?.toString(),
      babyGender: json['baby_gender']?.toString(),
      fetalSize: json['fetal_size'] != null
          ? FetalSize.fromJson(json['fetal_size'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hpht': hpht,
      'hpht_formatted': hphtFormatted,
      'hpl': hpl,
      'hpl_formatted': hplFormatted,
      'usia_kehamilan': usiaKehamilan.toJson(),
      'trimester': trimester,
      'trimester_name': trimesterName,
      'progress_percentage': progressPercentage,
      'countdown': countdown.toJson(),
      'status': status,
      'status_description': statusDescription,
      'baby_name': babyName,
      'baby_gender': babyGender,
      'fetal_size': fetalSize?.toJson(),
    };
  }

  Pregnancy toEntity() {
    return Pregnancy(
      hpht: hpht,
      hphtFormatted: hphtFormatted,
      hpl: hpl,
      hplFormatted: hplFormatted,
      usiaKehamilan: usiaKehamilan,
      trimester: trimester,
      trimesterName: trimesterName,
      progressPercentage: progressPercentage,
      countdown: countdown,
      status: status,
      statusDescription: statusDescription,
      babyName: babyName,
      babyGender: babyGender,
      fetalSize: fetalSize,
    );
  }
}
