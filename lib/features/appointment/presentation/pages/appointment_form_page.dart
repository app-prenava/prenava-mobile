import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/consultation_type.dart';
import '../../domain/entities/bidan_profile.dart';
import '../providers/appointment_providers.dart';

class AppointmentFormPage extends ConsumerStatefulWidget {
  final Map<String, bool> sharedFields;

  const AppointmentFormPage({super.key, this.sharedFields = const {}});

  @override
  ConsumerState<AppointmentFormPage> createState() =>
      _AppointmentFormPageState();
}

class _AppointmentFormPageState extends ConsumerState<AppointmentFormPage> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  ConsultationType? _selectedConsultationType;
  final TextEditingController _notesController = TextEditingController();
  Map<String, bool>? _sharedFields;
  BidanProfile? _bidan;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final state = ref.read(appointmentNotifierProvider);
    _bidan = state.selectedBidan;
    _sharedFields = widget.sharedFields;

    if (state.consultationTypes.isNotEmpty) {
      _selectedConsultationType = state.consultationTypes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Form Janji Temu'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFA6978)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBidanInfo(),
                  const SizedBox(height: 24),
                  _buildDatePicker(),
                  const SizedBox(height: 24),
                  _buildTimePicker(),
                  const SizedBox(height: 24),
                  _buildConsultationTypeSelector(),
                  const SizedBox(height: 24),
                  _buildNotesField(),
                  const SizedBox(height: 32),
                  _buildButtons(state),
                ],
              ),
            ),
    );
  }

  Widget _buildBidanInfo() {
    if (_bidan == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bidan yang Dipilih',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 20, color: Color(0xFFFA6978)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _bidan!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      _bidan!.address,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Tanggal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFFFA6978)),
                const SizedBox(width: 12),
                Text(
                  DateFormat(
                    'EEEE, dd MMMM yyyy',
                    'id_ID',
                  ).format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF424242),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Waktu',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _pickTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Color(0xFFFA6978)),
                const SizedBox(width: 12),
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF424242),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsultationTypeSelector() {
    final state = ref.watch(appointmentNotifierProvider);

    if (state.consultationTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
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
        ...state.consultationTypes.map((type) {
          final isSelected = _selectedConsultationType?.id == type.id;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedConsultationType = type;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFA6978).withValues(alpha: 0.1)
                    : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFA6978)
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? const Color(0xFFFA6978)
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFFFA6978)
                                : const Color(0xFF424242),
                          ),
                        ),
                        if (type.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            type.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan (Opsional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tambahkan catatan khusus untuk bidan',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Contoh: Periksa kandungan trimester kedua',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(AppointmentState state) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isCreating ? null : _submitAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: state.isCreating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Buat Janji Temu', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: const Text('Kembali'),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1));
    final lastDate = now.add(const Duration(days: 30));

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('id', 'ID'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (_bidan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih bidan terlebih dahulu')),
      );
      return;
    }

    if (_selectedConsultationType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis konsultasi')),
      );
      return;
    }

    final state = ref.read(appointmentNotifierProvider);
    final success = await ref
        .read(appointmentNotifierProvider.notifier)
        .createAppointment(
          bidanId: _bidan!.id,
          locationId: _bidan!.locationId,
          preferredDate: _selectedDate,
          preferredTime:
              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
          consultationType: _selectedConsultationType!.id,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          consentAccepted: true,
          consentVersion: state.consentInfo?.version ?? '1.0',
          sharedFields: _sharedFields ?? {},
        );

    if (mounted) {
      if (success && state.error == null) {
        context.go('/appointments');
      } else if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
