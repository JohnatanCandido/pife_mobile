import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pife_mobile/app/models/player_statistic.dart';

class StatisticsController extends ChangeNotifier {

  static StatisticsController instance = StatisticsController();

  StatisticsController() {
    _checkRetrieveStatistics();
  }

  List<PlayerStatistic> get playerStatistics => _playerStatistics;
  bool get statisticsLoaded => _playerStatistics.isNotEmpty;

  final List<PlayerStatistic> _playerStatistics = [];

  void _checkRetrieveStatistics() async {
    if (_playerStatistics.isEmpty) {
      print('Loading statistics...');
      final prefs = await SharedPreferences.getInstance();
      List<String>? statistics = prefs.getStringList('statistics');

      if (statistics != null) {
        for (String data in statistics) {
          _playerStatistics.add(PlayerStatistic.fromJson(jsonDecode(data)));
        }
        print('Statistics loaded.');
      } else {
        _createStatistics();
        print('No statistics to load.');
      }
      notifyListeners();
    }
  }

  void _createStatistics() {
    for (String n in ['1', '2', '3', '4']) {
      _playerStatistics.add(PlayerStatistic(n));
    }
  }

  void addWon() async {
    int numberOfOpponents = OpponentController.instance.numberOfOpponents;
    _playerStatistics[numberOfOpponents-1].gamesWon += 1;
    _save();
  }

  void addLost() async {
    int numberOfOpponents = OpponentController.instance.numberOfOpponents;
    _playerStatistics[numberOfOpponents-1].gamesLost += 1;
    _save();
  }

  void _save() async {
    List<String> data = [];
    for (PlayerStatistic statistic in _playerStatistics) {
      data.add(jsonEncode(statistic));
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('statistics', data);
    notifyListeners();
  }

  void resetStatistics() async {
    _playerStatistics.clear();
    _createStatistics();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('statistics');
    notifyListeners();
  }
}