import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sport_assessment_request.dart';
import '../bloc/sport_recommendation_bloc.dart';
import '../bloc/sport_recommendation_event.dart';

class AssessmentBottomSheet extends StatefulWidget {
  final VoidCallback onSuccess;

  const AssessmentBottomSheet({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _AssessmentBottomSheetState createState() => _AssessmentBottomSheetState();
}

class _AssessmentBottomSheetState extends State<AssessmentBottomSheet> {
  // Using generic dropdown options (Tidak/Ya) mapped to boolean
  bool _hypertension = false;
  bool _diabetes = false;
  bool _gestationalDiabetes = false;
  bool _fever = false;
  bool _highHeartRate = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    const Text('Tetap Akurat, Tetap Aman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'Sudah sebulan sejak kamu terakhir mengisi data kondisi tubuh dan kehamilanmu. Yuk, perbarui lagi informasi ini.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    _buildYesNoDropdown('Riwayat Hipertensi', _hypertension, (v) => setState(() => _hypertension = v)),
                    _buildYesNoDropdown('Diabetes', _diabetes, (v) => setState(() => _diabetes = v)),
                    _buildYesNoDropdown('Diabetes saat kehamilan', _gestationalDiabetes, (v) => setState(() => _gestationalDiabetes = v)),
                    _buildYesNoDropdown('Sering demam', _fever, (v) => setState(() => _fever = v)),
                    _buildYesNoDropdown('Detak Jantung Tinggi', _highHeartRate, (v) => setState(() => _highHeartRate = v)),
                  ],
                ),
              ),
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
                      onPressed: _submitForm,
                      child: const Text('Selanjutnya', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildYesNoDropdown(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value ? 'Ya' : 'Tidak',
                items: <String>['Tidak', 'Ya'].map((String val) {
                  return DropdownMenuItem<String>(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => onChanged(val == 'Ya'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // Defaulting BMI to placeholder because BMI logic is handled slightly differently in different views.
    // In production, grab BMI from user profile or earlier questions
    final request = SportAssessmentRequest(
      bmi: 22.0, // Defaulting for now
      hypertension: _hypertension,
      isDiabetes: _diabetes,
      gestationalDiabetes: _gestationalDiabetes,
      isFever: _fever,
      isHighHeartRate: _highHeartRate,
      previousComplications: false,
      mentalHealthIssue: false,
      lowImpactPref: false,
      waterAccess: false,
      backPain: false,
    );

    context.read<SportRecommendationBloc>().add(SubmitSportAssessmentEvent(request));
    Navigator.pop(context);
    widget.onSuccess();
  }
}
