import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱의 검색 기록을 관리하는 서비스 클래스입니다.
class HistoryService with ChangeNotifier {
  List<Map<String, String>> _history = [];
  static const _historyKey = 'history';
  static const _maxHistoryCount = 20;

  List<Map<String, String>> get history => _history;

  /// SharedPreferences에서 기록을 불러옵니다.
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getStringList(_historyKey) ?? [];
    _history = historyString
        .map((item) => Map<String, String>.from(json.decode(item)))
        .toList();
    notifyListeners();
  }

  /// 현재 기록 목록을 SharedPreferences에 저장합니다.
  Future<void> _persistHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = _history.map((item) => json.encode(item)).toList();
    await prefs.setStringList(_historyKey, historyString);
  }

  /// 새로운 기록을 추가하거나 기존 기록을 업데이트(최상단으로 이동)합니다.
  Future<void> addOrUpdateEntry(Map<String, String> newEntry) async {
    // 중복 제거
    _history.removeWhere((item) =>
        item['name'] == newEntry['name'] && item['date'] == newEntry['date']);

    // 맨 앞에 추가
    _history.insert(0, newEntry);

    // 최대 20개 유지
    if (_history.length > _maxHistoryCount) {
      _history = _history.sublist(0, _maxHistoryCount);
    }

    await _persistHistory();
    notifyListeners();
  }

  /// 특정 인덱스의 기록을 삭제합니다.
  Future<void> deleteEntry(int index) async {
    if (index < 0 || index >= _history.length) return;
    _history.removeAt(index);
    await _persistHistory();
    notifyListeners();
  }
}