import 'package:flutter/material.dart';
import '../models/temperature_record.dart';
import 'date_selector.dart';

class TemperatureInput extends StatefulWidget {
  final Function(TemperatureRecord) onSubmit;
  final bool isDateTimeExpanded;
  final VoidCallback onDateTimeExpandToggle;

  const TemperatureInput({
    super.key,
    required this.onSubmit,
    required this.isDateTimeExpanded,
    required this.onDateTimeExpandToggle,
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
    return Column(
      children: [
        // 体温選択部分（常に表示）
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              // 体温選択ドロップダウン
              Expanded(
                child: DropdownButton<double>(
                  value: _selectedTemperature,
                  isExpanded: true,
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
              ),
              
              // 記録ボタン
              const SizedBox(width: 8),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    final DateTime now = DateTime.now();
                    final TemperatureRecord record = TemperatureRecord(
                      dateTime: DateTime(
                        widget.isDateTimeExpanded ? _selectedYear : now.year,
                        widget.isDateTimeExpanded ? _selectedMonth : now.month,
                        widget.isDateTimeExpanded ? _selectedDay : now.day,
                        widget.isDateTimeExpanded ? _selectedHour : now.hour,
                        widget.isDateTimeExpanded ? _selectedMinute : now.minute,
                      ),
                      temperature: _selectedTemperature,
                    );
                    widget.onSubmit(record);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(40, 36),
                  ),
                  child: const Text(
                    '追加',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
        
        // 日時選択部分の開閉ボタン
        InkWell(
          onTap: widget.onDateTimeExpandToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isDateTimeExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        
        // 展開時に表示される日時選択部分
        AnimatedCrossFade(
          firstChild: const SizedBox(
            width: double.infinity,
            height: 0,
          ),
          secondChild: _buildDateTimeSelector(),
          crossFadeState: widget.isDateTimeExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
  
  // 日時選択部分のUIを構築
  Widget _buildDateTimeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
