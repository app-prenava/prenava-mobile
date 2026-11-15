import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/maternal_rag_model.dart';
import '../providers/maternal_rag_providers.dart';
import 'nearby_faskes_referral_section.dart';

class DangerCatalogBottomSheet extends ConsumerWidget {
  final List<DangerCategoryItem> catalog;
  final ValueChanged<String>? onSelectSymptomQuery;

  const DangerCatalogBottomSheet({
    super.key,
    required this.catalog,
    this.onSelectSymptomQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(maternalRagNotifierProvider);
    final notifier = ref.read(maternalRagNotifierProvider.notifier);
    final effectiveCatalog =
        state.dangerCatalog.isNotEmpty ? state.dangerCatalog : catalog;

    return DraggableScrollableSheet(
      initialChildSize: 0.84,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF334155),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lembar Tanda Bahaya Kehamilan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Pedoman Buku KIA Kemenkes RI (Halaman 20 & 22)',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup panduan tanda bahaya',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 10),

              // 3 UI States (R-27): Loading, Error, Empty, atau Content
              Expanded(
                child: state.isLoadingCatalog && effectiveCatalog.isEmpty
                    ? _buildLoadingState()
                    : state.catalogError != null && effectiveCatalog.isEmpty
                        ? _buildErrorState(
                            state.catalogError!,
                            onRetry: notifier.fetchDangerCatalog,
                          )
                        : effectiveCatalog.isEmpty
                            ? _buildEmptyState(
                                onReload: notifier.fetchDangerCatalog,
                              )
                            : ListView(
                                controller: scrollController,
                                children: [
                                  for (int i = 0;
                                      i < effectiveCatalog.length;
                                      i++) ...[
                                    if (i > 0) const SizedBox(height: 10),
                                    _buildDangerCategoryCard(
                                      context,
                                      effectiveCatalog[i],
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  const NearbyFaskesReferralSection(
                                    maxVisibleItems: 4,
                                    isEmergencyContext: false,
                                  ),
                                ],
                              ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Color(0xFF334155),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Memuat panduan tanda bahaya dari Buku KIA...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, {required VoidCallback onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Muat Ulang'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required VoidCallback onReload}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Panduan tanda bahaya belum tersedia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onReload,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF334155),
              ),
              child: const Text('Muat Data Buku KIA'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerCategoryCard(
    BuildContext context,
    DangerCategoryItem item,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.kiaPageRef,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),
          if (item.clinicalRisk.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.clinicalRisk,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Color(0xFF334155),
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),
          Text(
            'Saran Medis: ${item.recommendedAction}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: Color(0xFF1E293B),
            ),
          ),
          if (item.firstAidSteps.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (int idx = 0; idx < item.firstAidSteps.length; idx++)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '${idx + 1}. ${item.firstAidSteps[idx]}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.35,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
          ],
          if (onSelectSymptomQuery != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onSelectSymptomQuery!(
                    'Bunda ingin berkonsultasi mengenai ${item.label.toLowerCase()}',
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                label: const Text(
                  'Tanyakan topik ini',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF334155),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
