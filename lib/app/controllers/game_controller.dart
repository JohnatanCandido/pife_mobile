import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/controllers/options_controller.dart';
import 'package:pife_mobile/app/controllers/player_hand_controller.dart';
import 'package:pife_mobile/app/controllers/statistics_controller.dart';
import 'package:pife_mobile/app/controllers/turn_marker_controller.dart';
import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/table.dart';
import 'package:pife_mobile/app/models/validator.dart';

class GameController extends ChangeNotifier {
  
  static GameController instance = GameController();
  
  GameTable table = GameTable();
  late BasePlayer player;
  
  bool firstRound = false;
  late bool blockActions;
  late bool buying;
  late bool won;

  void newGame() {
    print('-------------- New Game --------------');
    firstRound = true;
    player = BasePlayer(true);
    blockActions = false;
    buying = true;
    won = false;
    OpponentController.instance.initializeOpponents();
    table.newGame();
    table.deal([player, ...OpponentController.instance.opponents]);
    OpponentController.instance.organizeOpponentsCards();
    notifyListeners();
  }

  void checkWin() {
    if (validateHand(player.cards)) {
      won = true;
      StatisticsController.instance.addWon();
      notifyListeners();
    }
  }

  void onDiscard() {
    buying = true;
    if (firstRound && PlayerHandController.instance.discardedBoughtCard) {
      PlayerHandController.instance.boughCard = null;
      PlayerHandController.instance.discardedBoughtCard = false;
    } else {
      blockActions = true;
      OpponentController.instance.callNextPlayer();
      TurnMarkerController.instance.notifyListeners();
    }
    firstRound = false;
  }

  Map<String, double> getCardPosition(GameCard card) {
    int index = GameController.instance.player.cards.indexOf(card);
    int length = GameController.instance.player.cards.length;
    double relativePosition = index - (length - 1) / 2;

    return OptionsController.instance.getCardPosition(relativePosition);
  }
}