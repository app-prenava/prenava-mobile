import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  
  void setLoading(bool value) => state = value;
}

final authLoadingProvider = NotifierProvider<AuthLoadingNotifier, bool>(() => AuthLoadingNotifier());

