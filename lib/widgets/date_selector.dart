import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final int selectedYear;
  final int selectedMonth;
  final int selectedDay;
  final Function(int) onYearChanged;
  final Function(int) onMonthChanged;
  final Function(int) onDayChanged;

  const DateSelector({
    super.key,
    required this.selectedYear,
    required this.selectedMonth,
    required this.selectedDay,
    required this.onYearChanged,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  // 指定された年と月の日数を取得
  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    // 年のリスト（現在の年から前5年）
    final int currentYear = DateTime.now().year;
    final List<int> years = List.generate(6, (index) => currentYear - 5 + index);
    
    // 月のリスト（1〜12月）
    final List<int> months = List.generate(12, (index) => index + 1);
    
    // 日のリスト（選択された年月に基づく）
    final int daysInMonth = _getDaysInMonth(selectedYear, selectedMonth);
    final List<int> days = List.generate(daysInMonth, (index) => index + 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 年の選択
        DropdownButton<int>(
          value: selectedYear,
          items: years.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value年'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              onYearChanged(newValue);
            }
          },
          isDense: true,
          underline: Container(),
        ),
        
        const SizedBox(width: 4),
        
        // 月の選択
        DropdownButton<int>(
          value: selectedMonth,
          items: months.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value月'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              onMonthChanged(newValue);
            }
          },
          isDense: true,
          underline: Container(),
        ),
        
        const SizedBox(width: 4),
        
        // 日の選択
        DropdownButton<int>(
          value: selectedDay <= daysInMonth ? selectedDay : daysInMonth,
          items: days.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value日'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              onDayChanged(newValue);
            }
          },
          isDense: true,
          underline: Container(),
        ),
      ],
    );
  }
}
