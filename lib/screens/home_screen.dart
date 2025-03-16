import 'package:flutter/material.dart';
import '../models/temperature_record.dart';
import '../services/storage_service.dart';
import '../widgets/temperature_input.dart';
import '../widgets/temperature_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<TemperatureRecord> _records = [];
  bool _isLoading = true;

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
      final records = await _storageService.getRecords();
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

  Future<void> _addRecord(TemperatureRecord record) async {
    try {
      await _storageService.addRecord(record);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TemperatureInput(onSubmit: _addRecord),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TemperatureChart(records: _records),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
