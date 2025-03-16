import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/temperature_record.dart';

class StorageService {
  static const String _recordsKey = 'temperature_records';

  /// 全ての体温記録を取得
  Future<List<TemperatureRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_recordsKey) ?? [];
    
    return recordsJson
        .map((json) => TemperatureRecord.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 新しい体温記録を追加（同じ日時と体温の組み合わせは追加しない）
  Future<void> saveRecord(TemperatureRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_recordsKey) ?? [];
    
    // 既存のレコードをデコード
    final existingRecords = recordsJson
        .map((json) => TemperatureRecord.fromJson(jsonDecode(json)))
        .toList();
    
    // 同じ日時と体温の組み合わせがあるか確認
    bool isDuplicate = existingRecords.any((existingRecord) => 
        existingRecord.dateTime.year == record.dateTime.year &&
        existingRecord.dateTime.month == record.dateTime.month &&
        existingRecord.dateTime.day == record.dateTime.day &&
        existingRecord.dateTime.hour == record.dateTime.hour &&
        existingRecord.dateTime.minute == record.dateTime.minute &&
        existingRecord.temperature == record.temperature);
    
    // 重複がなければ追加
    if (!isDuplicate) {
      recordsJson.add(jsonEncode(record.toJson()));
      await prefs.setStringList(_recordsKey, recordsJson);
    }
  }

  /// 体温記録を削除
  Future<void> deleteRecord(TemperatureRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_recordsKey) ?? [];
    
    // 既存のレコードをデコード
    final existingRecords = recordsJson
        .map((json) => TemperatureRecord.fromJson(jsonDecode(json)))
        .toList();
    
    // 削除対象のレコードを特定（日時と体温が一致するもの）
    existingRecords.removeWhere((existingRecord) => 
        existingRecord.dateTime.isAtSameMomentAs(record.dateTime) &&
        existingRecord.temperature == record.temperature);
    
    // 更新されたリストを保存
    await saveRecords(existingRecords);
  }

  /// 全ての体温記録を保存
  Future<void> saveRecords(List<TemperatureRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = records
        .map((record) => jsonEncode(record.toJson()))
        .toList();
    
    await prefs.setStringList(_recordsKey, recordsJson);
  }
}
