import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCalculation {
  final String id;
  final DateTime timestamp;
  final String projectName;
  final String scaleRatioLabel;
  final double realMeters;
  final double drawingMm;
  final String calculationType; // 'Linear' or 'Area'
  final String notes;

  SavedCalculation({
    required this.id,
    required this.timestamp,
    required this.projectName,
    required this.scaleRatioLabel,
    required this.realMeters,
    required this.drawingMm,
    required this.calculationType,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'projectName': projectName,
        'scaleRatioLabel': scaleRatioLabel,
        'realMeters': realMeters,
        'drawingMm': drawingMm,
        'calculationType': calculationType,
        'notes': notes,
      };

  factory SavedCalculation.fromJson(Map<String, dynamic> json) =>
      SavedCalculation(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        projectName: json['projectName'] as String,
        scaleRatioLabel: json['scaleRatioLabel'] as String,
        realMeters: (json['realMeters'] as num).toDouble(),
        drawingMm: (json['drawingMm'] as num).toDouble(),
        calculationType: json['calculationType'] as String,
        notes: json['notes'] as String,
      );
}

class PralixRepository extends ChangeNotifier {
  static const String _storageKey = 'pralix_saved_calculations_v1';
  static const String _activeScaleKey = 'pralix_active_scale_v1';

  List<SavedCalculation> _history = [];
  String _activeScaleLabel = '1:50';
  bool _isInitialized = false;

  List<SavedCalculation> get history => List.unmodifiable(_history);
  String get activeScaleLabel => _activeScaleLabel;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);
      if (savedData != null && savedData.isNotEmpty) {
        final decoded = jsonDecode(savedData) as List<dynamic>;
        _history = decoded
            .map((e) => SavedCalculation.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _history = _seedCalculations();
        await _persistHistory();
      }

      final savedScale = prefs.getString(_activeScaleKey);
      if (savedScale != null && savedScale.isNotEmpty) {
        _activeScaleLabel = savedScale;
      }
    } catch (e) {
      debugPrint('Error loading Pralix data: $e');
      _history = _seedCalculations();
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _persistHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_history.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  Future<void> saveCalculation({
    required String projectName,
    required String scaleRatioLabel,
    required double realMeters,
    required double drawingMm,
    required String calculationType,
    required String notes,
  }) async {
    final item = SavedCalculation(
      id: 'calc_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      projectName: projectName.trim().isEmpty ? 'General Architectural' : projectName.trim(),
      scaleRatioLabel: scaleRatioLabel,
      realMeters: realMeters,
      drawingMm: drawingMm,
      calculationType: calculationType,
      notes: notes,
    );
    _history.insert(0, item);
    await _persistHistory();
    notifyListeners();
  }

  Future<void> deleteCalculation(String id) async {
    _history.removeWhere((c) => c.id == id);
    await _persistHistory();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _history.clear();
    await _persistHistory();
    notifyListeners();
  }

  Future<void> setActiveScale(String scale) async {
    _activeScaleLabel = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeScaleKey, scale);
    notifyListeners();
  }

  List<SavedCalculation> _seedCalculations() {
    return [
      SavedCalculation(
        id: 'c_1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        projectName: 'Harbor View Residential Complex',
        scaleRatioLabel: '1:50',
        realMeters: 6.80,
        drawingMm: 136.0,
        calculationType: 'Linear Span',
        notes: 'Living room primary structural bay clearance.',
      ),
      SavedCalculation(
        id: 'c_2',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        projectName: 'Civic Library Extension',
        scaleRatioLabel: '1:100',
        realMeters: 24.50,
        drawingMm: 245.0,
        calculationType: 'Linear Span',
        notes: 'Main atrium clear floor length.',
      ),
      SavedCalculation(
        id: 'c_3',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        projectName: 'Metro Station North Concourse',
        scaleRatioLabel: '1:200',
        realMeters: 75.00,
        drawingMm: 375.0,
        calculationType: 'Site Dimension',
        notes: 'Subsurface pedestrian transfer tunnel.',
      ),
    ];
  }
}
