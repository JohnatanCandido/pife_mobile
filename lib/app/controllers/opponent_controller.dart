import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/pack_controller.dart';
import 'package:pife_mobile/app/controllers/statistics_controller.dart';
import 'package:pife_mobile/app/controllers/trash_controller.dart';
import 'package:pife_mobile/app/controllers/turn_marker_controller.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';

import '../models/opponent_display_properties.dart';
import '../models/validator.dart';
import 'game_controller.dart';

class OpponentController extends ChangeNotifier {
  
  static OpponentController instance = OpponentController();

  Opponent? get opponent => _playingIndex == -1 || _playingIndex == opponents.length ? null : opponents[_playingIndex];

  final Map<int, List> _opponentsProperties = {
    1: [
      OpponentProperties.top
    ],
    2: [
      OpponentProperties.topLeft,
      OpponentProperties.topRight
    ],
    3: [
      OpponentProperties.bottomLeft,
      OpponentProperties.top,
      OpponentProperties.bottomRight
    ],
    4: [
      OpponentProperties.bottomLeft,
      OpponentProperties.topLeft,
      OpponentProperties.topRight,
      OpponentProperties.bottomRight
    ]
  };

  int numberOfOpponents = 1;
  List<Opponent> opponents = [];
  int _playingIndex = -1;
  Opponent? winner;

  void reset() {
    winner = null;
    opponents = [];
    _playingIndex = -1;
  }

  void initializeOpponents() {
    reset();
    for (int i = 0; i < numberOfOpponents; i++) {
      opponents.add(Opponent(false, _opponentsProperties[numberOfOpponents]![i]));
    }
    if (numberOfOpponents == 4) {
      opponents[1].tiltStyle = OpponentProperties.tiltLeftToRight;
      opponents[2].tiltStyle = OpponentProperties.tiltRightToLeft;
    }
  }

  void organizeOpponentsCards() {
    for (var opponent in opponents) {
      opponent.organizeCards();
    }
  }

  int getWinnerNumber() {
    return opponents.indexOf(winner!) + 1;
  }

  static Map<String, double> getCardPosition(Opponent opponent, GameCard card) {
    if (card == opponent.cardDiscarded) {
      return TrashController.instance.getTopOfTrashDefaultPosition();
    }
    int index = opponent.cards.indexOf(card);
    int length = opponent.cards.length;
    return getCardPositionByIndex(opponent, index, length);
  }

  static Map<String, double> getCardPositionByIndex(Opponent opponent, int index, int length) {
    if (opponent.isHorizontal()) {
      return CardAnimationController.getHorizontalPosition(opponent, index, length);
    }
    return CardAnimationController.getVerticalPosition(opponent.properties, index, length);
  }

  void callNextPlayer() {
    _playingIndex++;
    opponent?.startBuy();
  }

  Future<bool> checkOpponentsTurn() async {
    if (_isOpponentsTurn()) {
      if (opponent!.shoudBuy) {
        _buy();
      } else if (opponent!.bought) {
        _finishBuyingAnimation();
      } else if (opponent!.shouldDiscard) {
        _discard();
      } else if (opponent!.discarded) {
        _finishDiscardAnimation();
      } else {
        return true;
      }
    }
    return false;
  }

  bool _isOpponentsTurn() {
    return opponent != null;
  }

  void _buy() async {
    bool boughtFromTrash = await _opponentBuy();
    if (boughtFromTrash) {
      TrashController.instance.notifyListeners();  
    } else {
      PackController.instance.notifyListeners();
    }
  }

  Future<bool> _opponentBuy() async {
    return Future.delayed(
      // Duration(seconds: Random().nextInt(10) + 2),
      const Duration(seconds: 2),
      () {
        GameCard? topOfTrash = GameController.instance.table.topOfTrash();
        bool buyFromTrash = topOfTrash != null && opponent!.checkBuyFromTrash(topOfTrash);

        GameController.instance.table.buy(opponent!, buyFromTrash);
        print('Opponent bought from ${buyFromTrash ? 'trash' : 'pack'}');
    
        return buyFromTrash;
      }
    );
  }

  void onBuyAnimationEnd() {
    if (opponent!.buying) {
      opponent!.finishBuy();
      notifyListeners();
    }
  }

  void _finishBuyingAnimation() {
    GameController.instance.table.finishOpponentBuy(opponent!);
    opponent!.startDiscard();
    TrashController.instance.notifyListeners();
    PackController.instance.notifyListeners();
    notifyListeners();
  }

  void _discard() async {
    bool opponentWon = await _opponentDiscard();
    if (opponentWon) {
      GameController.instance.notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void onDiscardAnimationEnd() {
    if (opponent!.discarding) {
      opponent!.finishDiscard();
      notifyListeners();
    }
  }

  Future<bool> _opponentDiscard() async {
    if (await _checkOpponentWon(opponent!)) {
      return true;
    }

    return Future.delayed(
      // Duration(seconds: Random().nextInt(5) + 5),
      const Duration(seconds: 1),
      () {
        GameCard cardToDiscard = opponent!.chooseCardToDiscard();
        GameController.instance.table.discard(opponent!, cardToDiscard);
        print('Opponent discarded $cardToDiscard');
        opponent!.organizeCards();

        return false;
      }
    );
  }

  void _finishDiscardAnimation() {
    opponent!.finish();
    GameController.instance.table.finishOpponentDiscard(opponent!);
    callNextPlayer();
    if (_playingIndex == opponents.length) {
      _playingIndex = -1;
      GameController.instance.blockActions = false;
    }
    TurnMarkerController.instance.notifyListeners();
    TrashController.instance.notifyListeners();
    PackController.instance.notifyListeners();
    notifyListeners();
  }

  Future<bool> _checkOpponentWon(Opponent opponent) async {
    return Future.delayed(
      // Duration(seconds: Random().nextInt(3) + 2),
      const Duration(seconds: 1),
      () {
        if (validateHand(opponent.cards)) {
          StatisticsController.instance.addLost();
          opponent.organizeCards();
          opponent.cards.removeLast();
          opponent.finish();
          winner = opponent;
          opponent.showHand = true;
          _playingIndex = -1;
          return true;
        }
        return false;
      }
    );
  }
}