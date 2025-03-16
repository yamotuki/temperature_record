import 'package:flutter/material.dart';
import '../models/temperature_record.dart';
import 'date_selector.dart';

class TemperatureInput extends StatefulWidget {
  final Function(TemperatureRecord) onSubmit;

  const TemperatureInput({
    super.key,
    required this.onSubmit,
  });

  @override
  State<TemperatureInput> createState() => _TemperatureInputState();
}

class _TemperatureInputState extends State<TemperatureInput> {
  double _selectedTemperature = 36.8;
  final List<double> _temperatureList = [];
  
  // 日付と時間の状態変数
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = DateTime.now().day;
  int _selectedHour = DateTime.now().hour;
  int _selectedMinute = DateTime.now().minute;

  @override
  void initState() {
    super.initState();
    _generateTemperatureList();
  }

  void _generateTemperatureList() {
    for (double i = 35.0; i <= 41.0; i += 0.1) {
      _temperatureList.add(double.parse(i.toStringAsFixed(1)));
    }
  }

  // 年を更新
  void _updateYear(int year) {
    setState(() {
      _selectedYear = year;
    });
  }

  // 月を更新
  void _updateMonth(int month) {
    setState(() {
      _selectedMonth = month;
      // 月が変わると日数も変わるので、選択中の日が新しい月の日数を超える場合は調整
      final int daysInMonth = DateTime(_selectedYear, month + 1, 0).day;
      if (_selectedDay > daysInMonth) {
        _selectedDay = daysInMonth;
      }
    });
  }

  // 日を更新
  void _updateDay(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  void _updateHour(int hour) {
    setState(() {
      _selectedHour = hour;
    });
  }

  void _updateMinute(int minute) {
    setState(() {
      _selectedMinute = minute;
    });
  }

  void _submit() {
    // 選択された日時からDateTimeオブジェクトを作成
    final DateTime selectedDateTime = DateTime(
      _selectedYear,
      _selectedMonth,
      _selectedDay,
      _selectedHour,
      _selectedMinute,
    );
    
    widget.onSubmit(TemperatureRecord(
      dateTime: selectedDateTime,
      temperature: _selectedTemperature,
    ));

    // 入力値はリセットせず、保持したままにする
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('体温: ', style: TextStyle(fontSize: 16)),
                DropdownButton<double>(
                  value: _selectedTemperature,
                  items: _temperatureList.map<DropdownMenuItem<double>>((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text('${value.toStringAsFixed(1)} °C'),
                    );
                  }).toList(),
                  onChanged: (double? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTemperature = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 日付選択
            DateSelector(
              selectedYear: _selectedYear,
              selectedMonth: _selectedMonth,
              selectedDay: _selectedDay,
              onYearChanged: _updateYear,
              onMonthChanged: _updateMonth,
              onDayChanged: _updateDay,
            ),
            const SizedBox(height: 8),
            
            // 時間選択
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton<int>(
                  value: _selectedHour,
                  items: List.generate(24, (index) => index)
                      .map((hour) => DropdownMenuItem<int>(
                            value: hour,
                            child: Text('$hour時'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateHour(value);
                    }
                  },
                  underline: Container(),
                  isDense: true,
                ),
                const SizedBox(width: 4),
                DropdownButton<int>(
                  value: _selectedMinute,
                  items: List.generate(60, (index) => index)
                      .map((minute) => DropdownMenuItem<int>(
                            value: minute,
                            child: Text('$minute分'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateMinute(value);
                    }
                  },
                  underline: Container(),
                  isDense: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('記録する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
