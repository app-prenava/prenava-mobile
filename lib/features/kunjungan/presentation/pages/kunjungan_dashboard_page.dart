import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/kunjungan_providers.dart';
import '../widgets/visit_card.dart';
import '../widgets/calendar_widget.dart';

class KunjunganDashboardPage extends ConsumerStatefulWidget {
  const KunjunganDashboardPage({super.key});

  @override
  ConsumerState<KunjunganDashboardPage> createState() => _KunjunganDashboardPageState();
}

class _KunjunganDashboardPageState extends ConsumerState<KunjunganDashboardPage> {
  DateTime _selectedMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kunjunganNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => ref.read(kunjunganNotifierProvider.notifier).loadVisits(),
        color: const Color(0xFFFA6978),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Gradient header with calendar
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
                      _buildHeader(),
                      _buildCalendarSection(),
                    ],
                  ),
                ),
              ),
              // Visit history
              _buildVisitHistorySection(state),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/kunjungan/create'),
        backgroundColor: const Color(0xFFFA6978),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          const Spacer(),
          const Text(
            'Kunjungan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: _buildCalendar(),
    );
  }

  Widget _buildCalendar() {
    final state = ref.watch(kunjunganNotifierProvider);
    final visits = state.visits;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Kalender Kunjungan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          CalendarWidget(
            selectedMonth: _selectedMonth,
            visits: visits,
            onDateTap: (date) {
              final visitsForDate = visits.where((visit) =>
                  visit.tanggalKunjungan.year == date.year &&
                  visit.tanggalKunjungan.month == date.month &&
                  visit.tanggalKunjungan.day == date.day).toList();

              if (visitsForDate.isNotEmpty) {
                context.push('/kunjungan/detail/${visitsForDate.first.id}');
              }
            },
            onMonthChanged: (month) {
              setState(() {
                _selectedMonth = month;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVisitHistorySection(KunjunganState state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Kunjungan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 16),
          if (state.isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFA6978)),
            )
          else if (state.error != null)
            Center(
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 8),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[400]),
                  ),
                ],
              ),
            )
          else if (state.visits.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.visits.length,
              itemBuilder: (context, index) {
                final visit = state.visits[index];
                return VisitCard(
                  visit: visit,
                  onTap: () => context.push('/kunjungan/detail/${visit.id}'),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada kunjungan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol + untuk menambahkan kunjungan baru',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
