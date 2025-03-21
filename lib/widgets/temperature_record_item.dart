import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/temperature_record.dart';

class TemperatureRecordItem extends StatelessWidget {
  final TemperatureRecord record;
  final Function(TemperatureRecord) onDelete;
  final DateFormat? dateFormatter;

  const TemperatureRecordItem({
    super.key,
    required this.record,
    required this.onDelete,
    this.dateFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = dateFormatter ?? DateFormat('MM/dd HH:mm');
    final formattedDate = formatter.format(record.dateTime);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          // 日時
          Expanded(
            flex: 2,
            child: Text(
              formattedDate,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          // 体温
          Expanded(
            flex: 1,
            child: Text(
              '${record.temperature.toStringAsFixed(1)}℃',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 削除ボタン
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.red.withOpacity(0.5),
            ),
            onPressed: () {
              // 削除確認ダイアログを表示
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('削除の確認'),
                    content: Text('${formattedDate} ${record.temperature.toStringAsFixed(1)}℃ の記録を削除しますか？'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete(record);
                          Navigator.of(context).pop();
                        },
                        child: const Text('削除'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
