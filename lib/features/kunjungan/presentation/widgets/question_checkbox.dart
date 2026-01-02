import 'package:flutter/material.dart';

class QuestionCheckbox extends StatelessWidget {
  final String questionKey;
  final String label;
  final bool? value;
  final Function(bool?) onChanged;

  const QuestionCheckbox({
    super.key,
    required this.questionKey,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isChecked = value == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isChecked
            ? const Color(0xFFFA6978).withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isChecked
              ? const Color(0xFFFA6978)
              : Colors.grey[300]!,
          width: isChecked ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            tristate: true,
            onChanged: onChanged,
            activeColor: const Color(0xFFFA6978),
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isChecked ? const Color(0xFFFA6978) : const Color(0xFF2C2C2C),
                fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
