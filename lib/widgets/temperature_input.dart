import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/temperature_record.dart';

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
  DateTime _selectedDateTime = DateTime.now();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedHour,
          _selectedMinute,
        );
      });
    }
  }

  void _updateHour(int hour) {
    setState(() {
      _selectedHour = hour;
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        hour,
        _selectedMinute,
      );
    });
  }

  void _updateMinute(int minute) {
    setState(() {
      _selectedMinute = minute;
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        _selectedHour,
        minute,
      );
    });
  }

  void _submit() {
    widget.onSubmit(TemperatureRecord(
      dateTime: _selectedDateTime,
      temperature: _selectedTemperature,
    ));

    // 入力値はリセットせず、保持したままにする
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');

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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      dateFormat.format(_selectedDateTime),
                      style: const TextStyle(fontSize: 14),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
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
                      const SizedBox(width: 8),
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
                ),
              ],
            ),
            const SizedBox(height: 12),
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
