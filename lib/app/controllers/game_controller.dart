import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/table.dart';
import 'package:pife_mobile/app/models/validator.dart';

class GameController extends ChangeNotifier {
  
  static GameController instance = GameController();
  
  GameTable table = GameTable();
  late BasePlayer player;
  
  late bool blockActions;
  late bool buying;
  late bool won;

  void newGame() {
    print('-------------- New Game --------------');
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
      notifyListeners();
    }
  }

  void onDiscard() {
    blockActions = true;
    buying = true;
    OpponentController.instance.callNextPlayer();
  }
}