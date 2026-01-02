import 'package:flutter/material.dart';
import '../../domain/entities/visit.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedMonth;
  final List<Visit> visits;
  final Function(DateTime) onDateTap;
  final Function(DateTime) onMonthChanged;

  const CalendarWidget({
    super.key,
    required this.selectedMonth,
    required this.visits,
    required this.onDateTap,
    required this.onMonthChanged,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.selectedMonth;
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMonth != oldWidget.selectedMonth) {
      _currentMonth = widget.selectedMonth;
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      widget.onMonthChanged(_currentMonth);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      widget.onMonthChanged(_currentMonth);
    });
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysBefore = firstDay.weekday % 7; // Days before first day of month

    final days = <DateTime>[];

    // Add days from previous month
    for (int i = daysBefore - 1; i >= 0; i--) {
      days.add(DateTime(month.year, month.month, -i));
    }

    // Add days of current month
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    // Add days from next month to complete 6 weeks
    final remainingDays = 42 - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(month.year, month.month + 1, i));
    }

    return days;
  }

  bool _hasVisit(DateTime date) {
    return widget.visits.any((visit) =>
        visit.tanggalKunjungan.year == date.year &&
        visit.tanggalKunjungan.month == date.month &&
        visit.tanggalKunjungan.day == date.day);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == _currentMonth.month;
  }

  void _handleDateTap(DateTime date) {
    if (_isCurrentMonth(date)) {
      widget.onDateTap(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_currentMonth);
    const weekdays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
                color: const Color(0xFFFA6978),
              ),
              Text(
                _getMonthYear(_currentMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
                color: const Color(0xFFFA6978),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays.map((day) {
              return SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          Column(
            children: List.generate(6, (weekIndex) {
              final weekDays = days.skip(weekIndex * 7).take(7).toList();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays.map((date) {
                    final isCurrentMonth = _isCurrentMonth(date);
                    final isToday = _isToday(date);
                    final hasVisit = _hasVisit(date);

                    return GestureDetector(
                      onTap: () => _handleDateTap(date),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getDayBackgroundColor(
                              isToday, hasVisit, isCurrentMonth),
                          borderRadius: BorderRadius.circular(12),
                          border: isToday
                              ? Border.all(
                                  color: const Color(0xFFFA6978),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _getDayTextColor(
                                    isToday, isCurrentMonth),
                              ),
                            ),
                            if (hasVisit && isCurrentMonth)
                              Positioned(
                                bottom: 4,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFA6978),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Color? _getDayBackgroundColor(bool isToday, bool hasVisit, bool isCurrentMonth) {
    if (isToday) {
      return const Color(0xFFFA6978).withValues(alpha: 0.2);
    }
    if (hasVisit && isCurrentMonth) {
      return const Color(0xFFFA6978).withValues(alpha: 0.1);
    }
    return Colors.transparent;
  }

  Color _getDayTextColor(bool isToday, bool isCurrentMonth) {
    if (isToday) {
      return const Color(0xFFFA6978);
    }
    if (!isCurrentMonth) {
      return Colors.grey[400]!;
    }
    return const Color(0xFF424242);
  }
}
