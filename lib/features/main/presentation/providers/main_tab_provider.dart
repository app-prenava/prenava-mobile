import 'package:flutter/foundation.dart';

/// Shared tab index notifier for MainScaffold so HomePage or ScreeningResultPage
/// can smoothly switch to bottom navigation tabs (e.g. Komunitas = 1).
final ValueNotifier<int> mainTabIndexNotifier = ValueNotifier<int>(0);

/// Optional one-shot action for HomePage (e.g. 'local_wisdom' to open the
/// Kearifan Lokal tab inside the Home bottom sheet).
final ValueNotifier<String?> homePendingActionNotifier = ValueNotifier<String?>(null);
