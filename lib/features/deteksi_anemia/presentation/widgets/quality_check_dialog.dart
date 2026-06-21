import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anemia_tutorial_providers.dart';

/// Quality Check Dialog for Anemia Detection
///
/// Displays a checklist of 5 quality criteria that must be met before
/// taking an anemia detection photo. User must explicitly choose to continue
/// or cancel - dialog is non-dismissible by barrier tap.
class QualityCheckDialog extends ConsumerWidget {
  /// Callback when user taps "Batal" (cancel)
  final VoidCallback onCancel;

  /// Callback when user taps "Lanjutkan" (continue)
  final VoidCallback onContinue;

  const QualityCheckDialog({
    required this.onCancel,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get quality check items from provider
    final qualityItems = ref.watch(anemiaQualityCheckItemsProvider);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.info_outline, color: Color(0xFFFA6978)),
          SizedBox(width: 8),
          Text(
            'Cek Kualitas Foto',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Untuk hasil analisis yang akurat, pastikan:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            // Generate quality check items
            ...qualityItems.map((item) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Color(0xFF48BB78), // Success green
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onContinue.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFA6978), // Primary pink
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Lanjutkan'),
        ),
      ],
    );
  }
}
