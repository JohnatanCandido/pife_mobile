import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/controllers/pack_controller.dart';
import 'package:pife_mobile/app/controllers/trash_controller.dart';
import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/table.dart';

import '../models/exceptions.dart';
import 'options_controller.dart';

class PlayerHandController extends ChangeNotifier {

  static PlayerHandController instance = PlayerHandController();

  BasePlayer get _player => GameController.instance.player;
  GameTable get _table => GameController.instance.table;

  GameCard? selectedCard;
  bool showBuyingArea = false;

  bool invalidDiscard = false;

  GameCard? boughCard;
  bool discardedBoughtCard = false;

  void selectCard(GameCard card) {
    selectedCard = card;
    notifyListeners();
  }

  void dropCard() {
    selectedCard = null;
    notifyListeners();
  }

  void organizeCards(double dx) {
    int? newIndex;
    double? smallerDistance;
    for (int index=0; index<_player.cards.length; index++) {
      double relativePosition = index - (_player.cards.length - 1) / 2;
      double x = OptionsController.instance.getCardPosition(relativePosition)['x']!;
      double distance = (dx-x).abs();
      if (smallerDistance == null || distance < smallerDistance) {
        newIndex = index;
        smallerDistance = distance;
      }
    }
    if (newIndex != null && selectedCard != null) {
      _player.cards.remove(selectedCard);
      _player.cards.insert(newIndex, selectedCard!);
    }
    notifyListeners();
  }

   void setShowBuyingArea(bool showBuyingArea) {
    this.showBuyingArea = showBuyingArea;
    notifyListeners();
  }

  void buy(GameCard card) {
    if (GameController.instance.firstRound) {
      boughCard = card;
    }
    _table.buy(_player, _table.trash.contains(card));
    GameController.instance.buying = false;
    TrashController.instance.notifyListeners();
    PackController.instance.notifyListeners();
    notifyListeners();
  }

  void discard(GameCard card) {
    try {
      _table.discard(_player, card);
      if (GameController.instance.firstRound) {
        discardedBoughtCard = card == boughCard;
      }
      GameController.instance.onDiscard();
      TrashController.instance.notifyListeners();
      PackController.instance.notifyListeners();
      OpponentController.instance.notifyListeners();
    } on InvalidDiscardException {
      invalidDiscard = true;
    }
    notifyListeners();
  }
}