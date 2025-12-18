import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/hydration_providers.dart';
import '../widgets/hydration_glass_item.dart';

class HydrationPage extends ConsumerStatefulWidget {
  const HydrationPage({super.key});

  @override
  ConsumerState<HydrationPage> createState() => _HydrationPageState();
}

class _HydrationPageState extends ConsumerState<HydrationPage> {
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    // Auto-refresh setiap 30 detik
    _autoRefreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (mounted) {
          ref.invalidate(waterIntakeProvider);
        }
      },
    );
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final waterIntakeAsync = ref.watch(waterIntakeProvider);
    final addWaterIntakeState = ref.watch(waterIntakeNotifierProvider);

    // Listen untuk success/error dari add water intake
    ref.listen<AsyncValue<void>>(
      waterIntakeNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            // Refresh data setelah berhasil
            ref.invalidate(waterIntakeProvider);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Konsumsi air berhasil ditambahkan!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          error: (error, _) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.toString().replaceAll('Exception: ', '')),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(waterIntakeProvider.future),
        color: const Color(0xFFFA6978),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Bagian dengan background gradien
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/gradien.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Header dengan back button
                      waterIntakeAsync.when(
                        data: (data) => _buildHeader(data.today),
                        loading: () => _buildHeader(null),
                        error: (_, __) => _buildHeader(null),
                      ),
                      // Card: Pantau Konsumsi Air
                      waterIntakeAsync.when(
                        data: (data) => _buildTodayCard(
                          data.today,
                          ref,
                          addWaterIntakeState,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              // Bagian dengan background putih (History)
              waterIntakeAsync.when(
                data: (data) => _buildHistoryCard(
                  data.history7Hari,
                  data.statistik,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(today) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          // Back button
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => context.pop(),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Status Hidrasi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            today?.targetTercapai == true
                ? 'Yuk Minum, Hidrasi Terpenuhi'
                : 'Yuk Minum, Penuhi Target Hidrasi',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCard(today, WidgetRef ref, AsyncValue<void> addWaterIntakeState) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFA6978).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/hidrasipage.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.water_drop,
                        color: Color(0xFFFA6978),
                        size: 24,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pantau Konsumsi Air',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Catat kecukupan minum harian Mums di sini.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Jumlah gelas + tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '${today.jumlahGelas} Gelas',
                    key: ValueKey(today.jumlahGelas),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  today.tanggalFormatted,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Visual 8 gelas (grid 2x4)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  final isFilled = index < today.jumlahGelas;
                  final canAdd = !isFilled && 
                                 !addWaterIntakeState.isLoading && 
                                 today.jumlahGelas < 8;
                  return HydrationGlassItem(
                    filled: isFilled,
                    onTap: canAdd ? () => _addWaterIntake(ref) : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Pesan target tercapai
            if (today.targetTercapai)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Wah kerenn!! Target sudah tercapai!!',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Text(
              '1 gelas = 250ml',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            // Waktu terakhir update
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Terakhir update: ${today.lastUpdatedFormatted}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (addWaterIntakeState.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFA6978),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(history, stats) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Minum',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${history.first.tanggalFormatted} - ${history.last.tanggalFormatted}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          // Bar Chart sederhana
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: history.map<Widget>((day) {
                final maxGelas = 10;
                final height = (day.jumlahGelas / maxGelas) * 180;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: height.clamp(0.0, 180.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA6978),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.tanggalLabel,
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      '${day.jumlahGelas}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          // Statistik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Rata-rata',
                '${stats.rataRataGelas7Hari.toStringAsFixed(1)} gelas',
                Icons.trending_up,
              ),
              _buildStatItem(
                'Total 7 Hari',
                '${(stats.totalMl7Hari / 1000).toStringAsFixed(1)} L',
                Icons.water_drop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFA6978)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Future<void> _addWaterIntake(WidgetRef ref) async {
    await ref.read(waterIntakeNotifierProvider.notifier).addWaterIntake(
          jumlahMl: 250,
        );
  }
}

