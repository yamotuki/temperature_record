import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/temperature_record.dart';

class TemperatureChart extends StatelessWidget {
  final List<TemperatureRecord> records;

  const TemperatureChart({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '記録がありません',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // 日付でソート
    final sortedRecords = List<TemperatureRecord>.from(records)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 0.5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < sortedRecords.length) {
                          final date = sortedRecords[value.toInt()].dateTime;
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        );
                      },
                      interval: 1.0,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                minX: 0,
                maxX: sortedRecords.length - 1.0,
                minY: 35.0,
                maxY: 40.0,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      sortedRecords.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        sortedRecords[index].temperature,
                      ),
                    ),
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3.5,
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
