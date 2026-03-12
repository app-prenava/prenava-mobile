import 'package:flutter/material.dart';

class LmpBottomSheet extends StatefulWidget {
  final VoidCallback onSuccess;

  const LmpBottomSheet({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _LmpBottomSheetState createState() => _LmpBottomSheetState();
}

class _LmpBottomSheetState extends State<LmpBottomSheet> {
  DateTime? _selectedDate;
  int _gestationalAge = 0;
  String _multipleGestation = 'Tidak';

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    // TODO: Dispatch API call to Add Pregnancies Profile
                    widget.onSuccess();
                    Navigator.pop(context);
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
                Text(_selectedDate == null ? 'Date' : _selectedDate.toString().split(' ')[0]),
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
}
