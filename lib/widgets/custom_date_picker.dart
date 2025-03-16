import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  final DateFormat _monthFormat = DateFormat('yyyy年M月');
  final DateFormat _dayFormat = DateFormat('d');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  List<Widget> _buildCalendar() {
    List<Widget> dayWidgets = [];

    // 曜日の見出し
    final weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    for (var weekday in weekdays) {
      dayWidgets.add(
        Container(
          height: 30,
          alignment: Alignment.center,
          child: Text(
            weekday,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // 月の最初の日の曜日を取得（0: 月曜日, 6: 日曜日）
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    int firstWeekday = firstDayOfMonth.weekday - 1; // 0-based index for grid

    // 前月の日を埋める
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // 月の日数を取得
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    // 各日のウィジェットを作成
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = DateTime(
                date.year,
                date.month,
                date.day,
                _selectedDate.hour,
                _selectedDate.minute,
              );
            });
            widget.onDateSelected(_selectedDate);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : null,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _dayFormat.format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            ),
          ),
        ),
      );
    }

    return dayWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _previousMonth,
            ),
            Text(
              _monthFormat.format(_currentMonth),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _nextMonth,
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          children: _buildCalendar(),
        ),
      ],
    );
  }
}
