import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/appointment_providers.dart';
import '../widgets/appointment_card.dart';

class AppointmentDashboardPage extends ConsumerStatefulWidget {
  const AppointmentDashboardPage({super.key});

  @override
  ConsumerState<AppointmentDashboardPage> createState() =>
      _AppointmentDashboardPageState();
}

class _AppointmentDashboardPageState
    extends ConsumerState<AppointmentDashboardPage> {
  String _filter = 'all';
  Timer? _pollingTimer;
  late final AppointmentNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(appointmentNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifier.startPolling();
      }
    });
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _notifier.loadAppointments();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _notifier.stopPolling();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  List<dynamic> _getFilteredAppointments(AppointmentState state) {
    switch (_filter) {
      case 'pending':
        return state.pendingAppointments;
      case 'accepted':
        return state.acceptedAppointments;
      case 'completed':
        return state.completedAppointments;
      case 'cancelled':
        return state.cancelledAppointments;
      case 'rejected':
        return state.rejectedAppointments;
      default:
        return state.filteredAppointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentNotifierProvider);
    final filteredAppointments = _getFilteredAppointments(state);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(state),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(appointmentNotifierProvider.notifier).loadAppointments(),
        color: const Color(0xFFFA6978),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildFilterChips(),
              _buildAppointmentList(state, filteredAppointments),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/appointments/create'),
        backgroundColor: const Color(0xFFFA6978),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppointmentState state) {
    return AppBar(
      title: const Text('Janji Temu'),
      backgroundColor: const Color(0xFFFA6978),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        if (state.isPolling)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Update Otomatis',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'label': 'Semua', 'value': 'all'},
      {'label': 'Menunggu', 'value': 'pending'},
      {'label': 'Diterima', 'value': 'accepted'},
      {'label': 'Selesai', 'value': 'completed'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _filter == filter['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter['label'] as String),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _filter = filter['value'] as String;
                    });
                  }
                },
                selectedColor: const Color(0xFFFA6978).withValues(alpha: 0.2),
                checkmarkColor: const Color(0xFFFA6978),
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xFFFA6978)
                      : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFFA6978)
                      : Colors.grey[300]!,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(
    AppointmentState state,
    List<dynamic> appointments,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Janji Temu',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 16),
          if (state.isLoading && appointments.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Color(0xFFFA6978)),
              ),
            )
          else if (state.error != null && appointments.isEmpty)
            _buildErrorState(state.error!)
          else if (appointments.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return AppointmentCard(
                  appointment: appointment,
                  onTap: () =>
                      context.push('/appointments/detail/${appointment.id}'),
                );
              },
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada janji temu',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol + untuk membuat janji temu baru',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[400]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(appointmentNotifierProvider.notifier)
                  .loadAppointments(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
