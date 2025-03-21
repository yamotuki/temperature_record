import 'package:flutter/material.dart';
import '../models/temperature_record.dart';
import '../services/storage_service.dart';
import '../widgets/temperature_input.dart';
import '../widgets/temperature_show.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<TemperatureRecord> _records = [];
  bool _isLoading = true;
  bool _isInputExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final records = await _storageService.loadRecords();
      setState(() {
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('データの読み込みに失敗しました: $e')),
        );
      }
    }
  }

  // 体温記録を追加
  Future<void> _addRecord(TemperatureRecord record) async {
    try {
      await _storageService.saveRecord(record);
      await _loadRecords();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('体温を記録しました'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('記録の保存に失敗しました: $e')),
        );
      }
    }
  }

  // 体温記録を削除
  Future<void> _deleteRecord(TemperatureRecord record) async {
    try {
      await _storageService.deleteRecord(record);
      await _loadRecords();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('記録を削除しました'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('記録の削除に失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体温記録'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 体温入力部分
                Card(
                  margin: const EdgeInsets.all(4.0),
                  child: TemperatureInput(
                    onSubmit: _addRecord,
                    isDateTimeExpanded: _isInputExpanded,
                    onDateTimeExpandToggle: () {
                      setState(() {
                        _isInputExpanded = !_isInputExpanded;
                      });
                      // 触覚フィードバック
                      HapticFeedback.lightImpact();
                    },
                  ),
                ),
                // 体温記録の表示
                Expanded(
                  child: TemperatureShow(
                    records: _records,
                    onDelete: _deleteRecord,
                  ),
                ),
              ],
            ),
    );
  }
}
