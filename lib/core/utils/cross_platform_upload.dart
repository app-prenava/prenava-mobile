import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

/// Cross-platform utility to create a Dio [MultipartFile] safely on both Mobile (Android/iOS)
/// and Web (iOS Safari PWA) without relying on dart:io File operations.
Future<MultipartFile> createMultipartFileFromPath(
  String path, {
  String? filename,
}) async {
  final bytes = await XFile(path).readAsBytes();
  final fallbackName = path.split('/').last.split('?').first;
  var resolvedName = filename ?? (fallbackName.isNotEmpty ? fallbackName : 'upload.jpg');
  if (!resolvedName.contains('.')) {
    resolvedName = '$resolvedName.jpg';
  }

  return MultipartFile.fromBytes(
    bytes,
    filename: resolvedName,
  );
}
