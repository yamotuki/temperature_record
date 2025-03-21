import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/temperature_record.dart';
import '../utils/clipboard_util.dart';
import 'temperature_record_item.dart';

class YearMonthSection extends StatelessWidget {
  final int year;
  final int month;
  final List<TemperatureRecord> records;
  final Function(TemperatureRecord) onDelete;

  const YearMonthSection({
    super.key,
    required this.year,
    required this.month,
    required this.records,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final monthFormatter = DateFormat.MMMM('ja');
    final monthName = monthFormatter.format(DateTime(year, month));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 年月の区切り
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$year年$monthName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // コピーボタン
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () => _copyMonthData(context),
                tooltip: 'この月のデータをコピー',
              ),
            ],
          ),
        ),
        // その月の記録一覧
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: records.length,
          itemBuilder: (context, index) {
            return TemperatureRecordItem(
              record: records[index],
              onDelete: onDelete,
            );
          },
        ),
      ],
    );
  }

  // 月のデータをクリップボードにコピーする
  void _copyMonthData(BuildContext context) async {
    // 日付でソートされた記録のリストを作成
    final sortedRecords = List<TemperatureRecord>.from(records)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    // コピーするテキスト行のリストを作成
    final lines = sortedRecords.map((record) {
      final dateStr = DateFormat('yyyy/MM/dd HH:mm').format(record.dateTime);
      return '$dateStr ${record.temperature.toStringAsFixed(1)}℃';
    }).toList();
    
    // クリップボードにコピー
    await ClipboardUtil.copyLinesToClipboard(lines);
    
    // コピー完了メッセージを表示
    final monthFormatter = DateFormat.MMMM('ja');
    final monthName = monthFormatter.format(DateTime(year, month));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$year年$monthNameのデータがコピーされました'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
