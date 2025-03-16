import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/temperature_record.dart';

class TemperatureShow extends StatelessWidget {
  final List<TemperatureRecord> records;

  const TemperatureShow({super.key, required this.records});

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

    // 年ごとにグループ化
    final recordsByYear = <int, List<TemperatureRecord>>{};
    for (var record in sortedRecords) {
      final year = record.dateTime.year;
      if (!recordsByYear.containsKey(year)) {
        recordsByYear[year] = [];
      }
      recordsByYear[year]!.add(record);
    }

    // 年の降順（新しい順）にソート
    final sortedYears = recordsByYear.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedYears.length,
      itemBuilder: (context, yearIndex) {
        final year = sortedYears[yearIndex];
        final yearRecords = recordsByYear[year]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 年の区切り
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[200],
              child: Text(
                '$year年',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            // その年の記録一覧
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: yearRecords.length,
              itemBuilder: (context, recordIndex) {
                final record = yearRecords[recordIndex];
                // MM/dd HH:mm 形式でフォーマット
                final dateFormatter = DateFormat('MM/dd HH:mm');
                final formattedDate = dateFormatter.format(record.dateTime);
                
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
                    ],
                  ),
                );
              },
            ),
            // 年の間にスペースを入れる
            if (yearIndex < sortedYears.length - 1)
              const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
