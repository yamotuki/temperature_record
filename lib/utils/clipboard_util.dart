import 'package:flutter/services.dart';

class ClipboardUtil {
  /// 指定されたテキストをクリップボードにコピーする
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
  
  /// 複数行のテキストを改行区切りで結合してクリップボードにコピーする
  static Future<void> copyLinesToClipboard(List<String> lines) async {
    final text = lines.join('\n');
    await copyToClipboard(text);
  }
}
