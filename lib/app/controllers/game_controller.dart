import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/table.dart';
import 'package:pife_mobile/app/models/validator.dart';

import 'options_controller.dart';

class GameController extends ChangeNotifier {
  
  static GameController instance = GameController();
  
  GameTable table = GameTable();
  late BasePlayer player;
  GameCard? selectedCard;
  late bool blockActions;
  late bool buying;
  late bool won;
  bool showBuyingArea = false;

  late Function updateGamePage;

  void newGame() {
    player = BasePlayer(true);
    blockActions = false;
    buying = true;
    won = false;
    OpponentController.instance.initializeOpponents();
    table.newGame();
    table.deal([player, ...OpponentController.instance.opponents]);
    OpponentController.instance.organizeOpponentsCards();
  }

  void buy(GameCard card) {
    table.buy(player, table.trash.contains(card));
    buying = false;
    notifyListeners();
  }

  void discard(GameCard card) {
    table.discard(player, card);
    blockActions = true;
    buying = true;
    OpponentController.instance.callNextPlayer();
    notifyListeners();
  }

  void checkWin() {
    if (validateHand(player.cards)) {
      won = true;
      notifyListeners();
    }
  }

  void organizeCards(double dx, double screenWidth) {
    dx += 30; // padding left
    screenWidth -= 60; // padding left + right

    int? newIndex;
    double? smallerDistance;
    for (int index=0; index<player.cards.length; index++) {
      double relativePosition = index - (player.cards.length - 1) / 2;
      double x = relativePosition * OptionsController.instance.cardSpacing;
      x = (x + 1) / 2 * screenWidth;
      double distance = (dx-x).abs();
      if (smallerDistance == null || distance < smallerDistance) {
        newIndex = index;
        smallerDistance = distance;
      }
    }
    if (newIndex != null && selectedCard != null) {
      player.cards.remove(selectedCard);
      player.cards.insert(newIndex, selectedCard!);
    }
  }

  void setShowBuyingArea(bool showBuyingArea) {
    this.showBuyingArea = showBuyingArea;
    notifyListeners();
  }
}