import 'package:flutter/material.dart';
import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';
import 'package:pife_mobile/app/models/table.dart';
import 'package:pife_mobile/app/models/validator.dart';

import 'options_controller.dart';

class GameController extends ChangeNotifier {
  
  static GameController instance = GameController();

  int numberOfOpponents = 1;
  GameTable table = GameTable();
  late BasePlayer player;
  late List<Opponent> opponents;
  GameCard? selectedCard;
  late bool blockActions;
  late bool buying;
  late bool won;
  late bool lost;
  bool showBuyingArea = false;

  Opponent? winner;

  void newGame() {
    player = BasePlayer(true);
    opponents = [];
    blockActions = false;
    buying = true;
    won = false;
    lost = false;
    winner = null;
    for (int i = 0; i < numberOfOpponents; i++) {
      opponents.add(Opponent(false));
    }
    table.newGame();
    table.deal([player, ...opponents]);
    for (var opponent in opponents) {
      opponent.organizeCards();
    }
  }

  void buy(GameCard card) {
    if (!player.cards.contains(card)) {
      table.buy(player, table.trash.contains(card));
      buying = false;
    }
    notifyListeners();
  }

  void discard(GameCard card) async {
    table.discard(player, card);
    blockActions = true;
    if (!makeOpponentsPlay()) {
      blockActions = false;
      buying = true;
    }
    notifyListeners();
  }

  bool makeOpponentsPlay() {
    for (Opponent opponent in opponents) {
      lost = table.play(opponent);
      if (lost) {
        winner = opponent;
        opponent.showHand = true;
        return true;
      }
    }
    return false;
  }

  void checkWin() {
    if (validateHand(player.cards)) {
      won = true;
      notifyListeners();
    }
  }

  String getWinnerName() {
    return 'Opponent ${opponents.indexOf(winner!) + 1}';
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