import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wisdom_provider.dart';
import '../../domain/entities/wisdom_item.dart';

final selectedRegionProvider = StateProvider<String>((ref) => 'Semua');

class WisdomChecklistSection extends ConsumerWidget {
  const WisdomChecklistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(wisdomProvider);
    final selectedRegion = ref.watch(selectedRegionProvider);

    return asyncItems.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: Color(0xFFFA6978)),
        ),
      ),
      error: (e, _) => const SizedBox(),
      data: (items) {
        final filteredItems = selectedRegion == 'Semua'
            ? items
            : items.where((item) => item.region.contains(selectedRegion)).toList();

        final checkedCount = items.where((e) => e.isChecked).length;
        final total = items.length;
        final progress = total > 0 ? checkedCount / total : 0.0;

        final regions = ['Semua', 'Jawa', 'Sunda', 'Bali', 'Sumatera', 'Bugis', 'Betawi'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WisdomHeader(checkedCount: checkedCount, total: total, progress: progress),
            
            // Region Filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: regions.length,
                itemBuilder: (context, index) {
                  final region = regions[index];
                  final isSelected = selectedRegion == region;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(region),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(selectedRegionProvider.notifier).state = region;
                      },
                      selectedColor: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[600],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            if (filteredItems.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('Tidak ada mitos untuk daerah ini.'),
                ),
              )
            else
              ...filteredItems.map((item) => _WisdomTile(item: item)),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────

class _WisdomHeader extends StatelessWidget {
  const _WisdomHeader({
    required this.checkedCount,
    required this.total,
    required this.progress,
  });

  final int checkedCount;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('🌿', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 8),
                  Text(
                    'Kearifan Lokal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$checkedCount / $total',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Pahami mitos agar Bunda lebih bijak & tenang 🤍',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── Individual Tile ────────────────────────────────────────────────────────

class _WisdomTile extends ConsumerStatefulWidget {
  const _WisdomTile({required this.item});
  final WisdomItem item;

  @override
  ConsumerState<_WisdomTile> createState() => _WisdomTileState();
}

class _WisdomTileState extends ConsumerState<_WisdomTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _animController;
  late final Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  Color _regionColor(String region) {
    if (region.contains('Jawa')) return const Color(0xFF5C6BC0);
    if (region.contains('Sunda')) return const Color(0xFF26A69A);
    if (region.contains('Bali')) return const Color(0xFFEF6C00);
    if (region.contains('Sumatera') || region.contains('Melayu')) {
      return const Color(0xFF8D6E63);
    }
    if (region.contains('Bugis') || region.contains('Makassar')) {
      return const Color(0xFFAD1457);
    }
    if (region.contains('Kalimantan')) return const Color(0xFF2E7D32);
    if (region.contains('Minang')) return const Color(0xFF6A1B9A);
    if (region.contains('Betawi')) return const Color(0xFF00838F);
    return const Color(0xFF757575); // Default: Umum/Nasional
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: item.isChecked
            ? const Color(0xFF4CAF50).withValues(alpha: 0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isChecked
              ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpand,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () => ref.read(wisdomProvider.notifier).toggle(item.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.isChecked
                            ? const Color(0xFF4CAF50)
                            : Colors.transparent,
                        border: Border.all(
                          color: item.isChecked
                              ? const Color(0xFF4CAF50)
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: item.isChecked
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title + region badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.myth,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: item.isChecked
                                ? Colors.grey[500]
                                : const Color(0xFF333333),
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _regionColor(item.region)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.region,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _regionColor(item.region),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand chevron
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[500],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable reason
          SizeTransition(
            sizeFactor: _expandAnim,
            child: Container(
              padding: const EdgeInsets.fromLTRB(52, 0, 16, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      item.reason,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
