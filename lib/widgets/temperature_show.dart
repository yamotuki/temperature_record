import 'package:flutter/material.dart';
import '../models/temperature_record.dart';
import 'year_month_section.dart';

class TemperatureShow extends StatelessWidget {
  final List<TemperatureRecord> records;
  final Function(TemperatureRecord) onDelete;

  const TemperatureShow({
    super.key, 
    required this.records,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(
        child: Text('記録がありません'),
      );
    }
    
    // 記録を日付の降順（新しい順）にソート
    final sortedRecords = List<TemperatureRecord>.from(records)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // 年月ごとにグループ化
    final recordsByYearMonth = <String, List<TemperatureRecord>>{};
    for (var record in sortedRecords) {
      final year = record.dateTime.year;
      final month = record.dateTime.month;
      final key = '$year-$month';
      
      if (!recordsByYearMonth.containsKey(key)) {
        recordsByYearMonth[key] = [];
      }
      recordsByYearMonth[key]!.add(record);
    }

    // 年月のキーを降順（新しい順）にソート
    final sortedKeys = recordsByYearMonth.keys.toList()
      ..sort((a, b) {
        final aParts = a.split('-').map(int.parse).toList();
        final bParts = b.split('-').map(int.parse).toList();
        
        // 年で比較し、同じ年なら月で比較
        final yearComparison = bParts[0].compareTo(aParts[0]);
        if (yearComparison != 0) return yearComparison;
        return bParts[1].compareTo(aParts[1]);
      });

    // 年月ごとのセクションを作成
    final sections = <Widget>[];
    for (int i = 0; i < sortedKeys.length; i++) {
      final key = sortedKeys[i];
      final parts = key.split('-').map(int.parse).toList();
      final year = parts[0];
      final month = parts[1];
      
      sections.add(
        YearMonthSection(
          year: year,
          month: month,
          records: recordsByYearMonth[key]!,
          onDelete: onDelete,
        ),
      );
      
      // 年月の間にスペースを入れる
      if (i < sortedKeys.length - 1) {
        sections.add(const SizedBox(height: 16));
      }
    }

    return ListView(
      children: sections,
    );
  }
}
