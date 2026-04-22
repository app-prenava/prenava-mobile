import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

class LmpBottomSheet extends ConsumerStatefulWidget {
  final Future<void> Function(String hpht, int gestationalAge, bool isMultiple) onSuccess;

  const LmpBottomSheet({Key? key, required this.onSuccess}) : super(key: key);

  @override
  ConsumerState<LmpBottomSheet> createState() => _LmpBottomSheetState();
}

class _LmpBottomSheetState extends ConsumerState<LmpBottomSheet> {
  DateTime? _selectedDate;
  int _gestationalAge = 0;
  String _multipleGestation = 'Tidak';
  int? _autoFilledAge;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final profile = profileState.profile;

    // Auto-fill age from profile
    if (_autoFilledAge == null && profile?.usia != null) {
      _autoFilledAge = profile!.usia;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sedikit lagi ya ❤️', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Sebelum melanjutkan ke Prenava, silakan isi terlebih dahulu profil kehamilanmu agar kami bisa mendampingimu dengan lebih baik.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          if (_autoFilledAge != null) _buildAgeDisplay(_autoFilledAge!),
          if (_autoFilledAge != null) const SizedBox(height: 16),
          _buildDateField(),
          const SizedBox(height: 16),
          _buildNumberField(),
          const SizedBox(height: 16),
          _buildDropdownField(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Nanti', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC75166)),
                  onPressed: _selectedDate == null ? null : () async {
                    final hpht = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                    final isMultiple = _multipleGestation == 'Ya';
                    await widget.onSuccess(hpht, _gestationalAge, isMultiple);
                    // Parent is responsible for closing the sheet
                  },
                  child: const Text('Lanjutkan', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hari pertama haid terakhir'),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (date != null) setState(() => _selectedDate = date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(_selectedDate == null ? 'Pilih tanggal' : DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Usia kehamilan (dalam minggu)'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none, hintText: '0'),
            onChanged: (val) => _gestationalAge = int.tryParse(val) ?? 0,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kehamilan kembar'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _multipleGestation,
              items: <String>['Tidak', 'Ya'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => setState(() => _multipleGestation = val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeDisplay(int age) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC75166), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.cake, color: Color(0xFFC75166)),
          const SizedBox(width: 8),
          Text('Usia: $age tahun', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
