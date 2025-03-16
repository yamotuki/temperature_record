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
  final _temperatureController = TextEditingController(text: '36.8');
  DateTime _selectedDateTime = DateTime.now();
  int _selectedHour = DateTime.now().hour;

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
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
          0,
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
        0,
      );
    });
  }

  void _submit() {
    final temperature = double.tryParse(_temperatureController.text);
    if (temperature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効な体温を入力してください')),
      );
      return;
    }

    widget.onSubmit(TemperatureRecord(
      dateTime: _selectedDateTime,
      temperature: temperature,
    ));

    // 入力をリセット
    _temperatureController.text = '36.8';
    setState(() {
      _selectedDateTime = DateTime.now();
      _selectedHour = DateTime.now().hour;
    });
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
                Expanded(
                  child: TextField(
                    controller: _temperatureController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '体温 (°C)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
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
                        items: List.generate(24, (index) => index + 1)
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
