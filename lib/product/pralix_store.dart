import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PralixStore extends ChangeNotifier {
  SharedPreferences? _prefs;
  List<dynamic> _history = [];

  List<dynamic> get history => _history;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final data = _prefs?.getString('pralix_history');
    if (data != null) {
      _history = jsonDecode(data);
    }
    notifyListeners();
  }

  void addHistory(String entry) {
    _history.add(entry);
    _prefs?.setString('pralix_history', jsonEncode(_history));
    notifyListeners();
  }
}
