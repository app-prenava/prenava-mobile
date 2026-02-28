import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/consultation_type.dart';
import '../providers/appointment_providers.dart';
import '../widgets/status_badge.dart';

class AppointmentDetailPage extends ConsumerStatefulWidget {
  final int appointmentId;

  const AppointmentDetailPage({super.key, required this.appointmentId});

  @override
  ConsumerState<AppointmentDetailPage> createState() =>
      _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends ConsumerState<AppointmentDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(appointmentNotifierProvider.notifier)
          .loadAppointmentDetail(widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentNotifierProvider);
    final appointment = state.selectedAppointment;

    if (state.isLoading && appointment == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFA6978)),
        ),
      );
    }

    if (state.error != null && appointment == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Detail Janji Temu'),
          backgroundColor: const Color(0xFFFA6978),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[400]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (appointment == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFA6978)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Janji Temu'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        actions: [
          if (appointment.canCancel)
            TextButton(
              onPressed: state.isCreating
                  ? null
                  : () => _showCancelDialog(appointment),
              child: Text(
                'Batalkan',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(appointment),
            const SizedBox(height: 20),
            _buildBidanInfo(appointment),
            const SizedBox(height: 20),
            _buildDateTimeCard(appointment),
            const SizedBox(height: 20),
            _buildConsultationInfo(appointment),
            if (appointment.notes != null) ...[
              const SizedBox(height: 20),
              _buildNotesCard(appointment),
            ],
            if (appointment.bidanNotes != null) ...[
              const SizedBox(height: 20),
              _buildBidanNotesCard(appointment),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(Appointment appointment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Janji Temu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatusBadge(status: appointment.status),
              const SizedBox(width: 8),
              Text(
                _getStatusMessage(appointment.status),
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBidanInfo(Appointment appointment) {
    final bidan = appointment.bidan;
    if (bidan == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Bidan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFFA6978),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bidan.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bidan.address,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (bidan.specialization != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                bidan.specialization!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFA6978),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateTimeCard(Appointment appointment) {
    final displayDate = appointment.confirmedDate ?? appointment.preferredDate;
    final displayTime = appointment.confirmedTime ?? appointment.preferredTime;
    final isConfirmed = appointment.confirmedDate != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: isConfirmed ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                isConfirmed ? 'Waktu Dikonfirmasi' : 'Waktu Diminta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isConfirmed ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.event, size: 20, color: Color(0xFF757575)),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(displayDate),
                style: const TextStyle(fontSize: 15, color: Color(0xFF424242)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: Color(0xFF757575)),
              const SizedBox(width: 8),
              Text(
                _formatTime(displayTime),
                style: const TextStyle(fontSize: 15, color: Color(0xFF424242)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationInfo(Appointment appointment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Konsultasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Color(0xFFFA6978),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getConsultationTypeName(appointment.consultationType),
                style: const TextStyle(fontSize: 15, color: Color(0xFF424242)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(Appointment appointment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 8),
              const Text(
                'Catatan Anda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            appointment.notes!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF616161),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidanNotesCard(Appointment appointment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2196F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_services,
                size: 20,
                color: Color(0xFF1976D2),
              ),
              const SizedBox(width: 8),
              const Text(
                'Catatan Bidan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            appointment.bidanNotes!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1565C0),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'requested':
        return 'Menunggu konfirmasi dari bidan';
      case 'accepted':
        return 'Janji temu telah diterima bidan';
      case 'rejected':
        return 'Janji temu ditolak oleh bidan';
      case 'completed':
        return 'Janji temu telah selesai';
      case 'cancelled':
        return 'Janji temu telah dibatalkan';
      default:
        return '';
    }
  }

  String _getConsultationTypeName(String type) {
    final state = ref.read(appointmentNotifierProvider);
    ConsultationType consultationType;
    try {
      consultationType = state.consultationTypes.firstWhere(
        (t) => t.id == type,
      );
    } catch (e) {
      consultationType = ConsultationType(
        id: type,
        name: type,
        description: '',
      );
    }
    return consultationType.name;
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $period';
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  Future<void> _showCancelDialog(Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Janji Temu'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan janji temu ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref
          .read(appointmentNotifierProvider.notifier)
          .cancelAppointment(appointment.id);

      if (mounted) {
        if (success) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Janji temu berhasil dibatalkan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }
}
