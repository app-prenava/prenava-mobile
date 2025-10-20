import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStoreProvider = Provider<_SecureStore>((_) => _SecureStore());

class _SecureStore {
  final _s = const FlutterSecureStorage();
  Future<void> write(String k, String v) => _s.write(key: k, value: v);
  Future<String?> read(String k) => _s.read(key: k);
  Future<void> delete(String k) => _s.delete(key: k);
}

