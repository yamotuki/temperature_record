import 'package:flutter/material.dart';

class TimeSelector extends StatelessWidget {
  final int selectedHour;
  final int selectedMinute;
  final Function(int) onHourChanged;
  final Function(int) onMinuteChanged;

  const TimeSelector({
    super.key,
    required this.selectedHour,
    required this.selectedMinute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 時間のリスト（0〜23時）
    final List<int> hours = List.generate(24, (index) => index);
    
    // 分のリスト（0〜59分）
    final List<int> minutes = List.generate(60, (index) => index);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.access_time, size: 18, color: Colors.blue),
        const SizedBox(width: 8),
        
        // 時間の選択
        DropdownButton<int>(
          value: selectedHour,
          items: hours.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value時'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              onHourChanged(newValue);
            }
          },
          underline: Container(),
        ),
        
        const SizedBox(width: 8),
        
        // 分の選択
        DropdownButton<int>(
          value: selectedMinute,
          items: minutes.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value分'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              onMinuteChanged(newValue);
            }
          },
          underline: Container(),
        ),
      ],
    );
  }
}
