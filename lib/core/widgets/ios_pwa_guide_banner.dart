import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Banner panduan untuk pengguna iPhone di Safari agar menambahkan web ke Home Screen.
class IosPwaGuideBanner extends StatefulWidget {
  const IosPwaGuideBanner({super.key});

  @override
  State<IosPwaGuideBanner> createState() => _IosPwaGuideBannerState();
}

class _IosPwaGuideBannerState extends State<IosPwaGuideBanner> {
  static const _prefKey = 'ios_pwa_banner_dismissed_v1';
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _loadDismissState();
  }

  Future<void> _loadDismissState() async {
    if (!kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final dismissed = prefs.getBool(_prefKey) ?? false;
      if (mounted) {
        setState(() {
          _dismissed = dismissed;
        });
      }
    } catch (_) {}
  }

  Future<void> _dismiss() async {
    setState(() {
      _dismissed = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, true);
    } catch (_) {}
  }

  bool get _shouldShow {
    if (!kIsWeb || _dismissed) return false;
    // Tampilkan hanya jika dijalankan di Web pada platform iOS
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F3),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFFFA6978).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFA6978).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.ios_share,
              size: 20,
              color: Color(0xFFFA6978),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pasang di Layar Utama iPhone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: Color(0xFF4A5568)),
                    children: [
                      TextSpan(text: 'Ketuk tombol Bagikan '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(Icons.ios_share,
                            size: 14, color: Color(0xFFFA6978)),
                      ),
                      TextSpan(text: ' di Safari, lalu pilih '),
                      TextSpan(
                        text: 'Tambah ke Layar Utama ➕',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' untuk pengalaman aplikasi fullscreen.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _dismiss,
          ),
        ],
      ),
    );
  }
}
