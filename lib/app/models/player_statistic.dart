import 'dart:math';

class PlayerStatistic {

  PlayerStatistic(this.numberOfOpponents);
  
  final String numberOfOpponents;
  double gamesWon = 0;
  double gamesLost = 0;

  String get gamesPlayed => '${(gamesWon + gamesLost).toInt()}';
  String get won => '${gamesWon.toInt()} (${(gamesWon / max(gamesWon + gamesLost, 1) * 100).toStringAsFixed(2)}%)';
  String get lost => '${gamesLost.toInt()} (${(gamesLost / max(gamesWon + gamesLost, 1) * 100).toStringAsFixed(2)}%)';

  static PlayerStatistic fromJson(Map<String, dynamic> data) {
    var statistic = PlayerStatistic(data['numberOfOpponents']);
    statistic.gamesWon = data['gamesWon'];
    statistic.gamesLost = data['gamesLost'];

    return statistic;
  }

  Map<String ,dynamic> toJson() {
    return {
      'numberOfOpponents': numberOfOpponents,
      'gamesWon': gamesWon,
      'gamesLost': gamesLost
    };
  }
}