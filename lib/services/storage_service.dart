import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/temperature_record.dart';

class StorageService {
  static const String _recordsKey = 'temperature_records';

  // 全ての体温記録を取得
  Future<List<TemperatureRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_recordsKey) ?? [];
    
    return recordsJson
        .map((json) => TemperatureRecord.fromJson(jsonDecode(json)))
        .toList();
  }

  // 新しい体温記録を追加
  Future<void> addRecord(TemperatureRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_recordsKey) ?? [];
    
    recordsJson.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_recordsKey, recordsJson);
  }

  // 全ての体温記録を保存
  Future<void> saveRecords(List<TemperatureRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = records
        .map((record) => jsonEncode(record.toJson()))
        .toList();
    
    await prefs.setStringList(_recordsKey, recordsJson);
  }
}
