import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthHistoryImageStore {
  static const _keyPrefix = 'health_history_img_';

  Future<String> saveImageToAppDir(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw Exception('Image source not found');
    }

    final appDir = await getApplicationDocumentsDirectory();
    final historyImageDir = Directory('${appDir.path}/health_history_images');
    if (!await historyImageDir.exists()) {
      await historyImageDir.create(recursive: true);
    }

    final extension = sourcePath.contains('.')
        ? sourcePath.substring(sourcePath.lastIndexOf('.'))
        : '.jpg';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
    final destinationPath = '${historyImageDir.path}/$fileName';

    await sourceFile.copy(destinationPath);
    return destinationPath;
  }

  Future<void> saveHistoryImagePath(int historyId, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_keyPrefix$historyId', path);
  }

  Future<String?> getHistoryImagePath(int historyId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_keyPrefix$historyId');
  }

  Future<void> deleteHistoryImage(int historyId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$historyId';
    final existingPath = prefs.getString(key);

    if (existingPath != null && existingPath.isNotEmpty) {
      final imageFile = File(existingPath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }

    await prefs.remove(key);
  }
}
