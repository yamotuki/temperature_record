class TemperatureRecord {
  final DateTime dateTime;
  final double temperature;

  TemperatureRecord({
    required this.dateTime,
    required this.temperature,
  });

  // JSONからオブジェクトを生成するファクトリメソッド
  factory TemperatureRecord.fromJson(Map<String, dynamic> json) {
    return TemperatureRecord(
      dateTime: DateTime.parse(json['dateTime']),
      temperature: json['temperature'],
    );
  }

  // オブジェクトをJSONに変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'temperature': temperature,
    };
  }
}
