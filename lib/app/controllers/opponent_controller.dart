import 'package:flutter/material.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';

import '../models/opponent_display_properties.dart';
import '../models/validator.dart';
import 'game_controller.dart';

class OpponentController extends ChangeNotifier {

  static const String buyFromTrash = "buy from trash";
  static const String buyFromPack = "buy from pack";
  static const String discard = "discard";

  static String? cardAnimationType;
  static GameCard? cardToAnimate;
  
  static OpponentController instance = OpponentController();

  OpponentController() {
    _opponentsCoordinates = {
    1: [
      _top
    ],
    2: [
      _topLeft,
      _topRight
    ],
    3: [
      _top,
      _topLeft,
      _topRight
    ],
    4: [
      _topLeft,
      _topRight,
      _bottomLeft,
      _bottomRight
    ]
  };
  }

  final _top = OpponentProperties(0, -0.9, 0.086, horizontal: true, dir: 1, angleBias: 0);
  final _topLeft = OpponentProperties(-0.9, -0.8, 0.1, dir: 1, angleBias: 1.5);
  final _topRight = OpponentProperties(0.9, -0.8, 0.1, dir: -1, angleBias: -1.5, cardOrientation: -1);
  final _bottomLeft = OpponentProperties(-0.9, 0, 0.1, dir: 1, angleBias: 1.5);
  final _bottomRight = OpponentProperties(0.9, 0, 0.1, dir: -1, angleBias: -1.5, cardOrientation: -1);

  late var _opponentsCoordinates;

  int numberOfOpponents = 1;
  late List<Opponent> opponents;
  int _playingIndex = -1;
  Opponent? winner;

  void initializeOpponents() {
    winner = null;
    opponents = [];
    _playingIndex = -1;
    _clearAnimation();
    for (int i = 0; i < numberOfOpponents; i++) {
      opponents.add(Opponent(false));
    }
  }

  void organizeOpponentsCards() {
    for (var opponent in opponents) {
      opponent.organizeCards();
    }
  }

  String getWinnerName() {
    return 'Opponent ${opponents.indexOf(winner!) + 1}';
  }

  Map<String, double> getCardPosition(Opponent opponent, int opponentIndex, GameCard card) {
    int index = opponent.cards.indexOf(card);
    int length = opponent.cards.length;
    double relativePosition = index - (length - 1) / 2;
    Map<String, double> cardPosition = {};

    if (_isHorizontal(opponentIndex)) {
      cardPosition['x'] = relativePosition * -0.06;
      cardPosition['y'] = -relativePosition.abs() * 0.01 + _getDouble(opponentIndex, 'y');
    } else {
      cardPosition['x'] = -relativePosition.abs() * 0.01 * _getDouble(opponentIndex, 'dir') + _getDouble(opponentIndex, 'x');
      cardPosition['y'] = relativePosition * _getDouble(opponentIndex, 'orientation') * 0.04 + _getDouble(opponentIndex, 'y');
    }

    cardPosition['angle'] = relativePosition * _getDouble(opponentIndex, 'angle') + _getDouble(opponentIndex, 'angleBias');

    return cardPosition;
  }

  double _getDouble(int index, String value) {
    return _opponentsCoordinates[OpponentController.instance.numberOfOpponents][index].getDouble(value);
  }

  bool _isHorizontal(int index) {
    return _opponentsCoordinates[OpponentController.instance.numberOfOpponents]![index].horizontal;
  }

  void callNextPlayer() {
    _playingIndex++;
  }

  void checkOpponentsTurn() async {
    if (_isOpponentsTurn()) {
      bool boughtFromTrash = await _opponentBuy();
      GameController.instance.updateGamePage(() {
        OpponentController.cardAnimationType = boughtFromTrash ? OpponentController.buyFromTrash : OpponentController.buyFromPack;
      });
    }
  }

  bool _isOpponentsTurn() {
    return 0 <= _playingIndex
        && _playingIndex < opponents.length
        && !opponents[_playingIndex].playing;
  }

  Future<bool> _opponentBuy() async {
    Opponent opponent = opponents[_playingIndex];
    opponent.playing = true;
    return Future.delayed(
      // Duration(seconds: Random().nextInt(10) + 2),
      const Duration(seconds: 2),
      () {
        GameCard? topOfTrash = GameController.instance.table.topOfTrash();
        bool buyFromTrash = topOfTrash != null && opponent.checkBuyFromTrash(topOfTrash);

        GameController.instance.table.buy(opponent, buyFromTrash);
        cardToAnimate = opponent.boughtCard;
        print('Opponent bought from ${buyFromTrash ? 'trash' : 'pack'}');
    
        return buyFromTrash;
      }
    );
  }

  Future<bool> opponentDiscard() async {
    Opponent opponent = opponents[_playingIndex];
    if (await _checkOpponentWon(opponent)) {
      return true;
    }

    return Future.delayed(
      // Duration(seconds: Random().nextInt(5) + 5),
      const Duration(seconds: 1),
      () {
        GameCard cardToDiscard = opponent.chooseCardToDiscard();
        GameController.instance.table.discard(opponent, cardToDiscard);
        cardToAnimate = cardToDiscard;
        print('Opponent discarded');
        opponent.organizeCards();

        return false;
      }
    );
  }

  Future<bool> _checkOpponentWon(Opponent opponent) async {
    return Future.delayed(
      // Duration(seconds: Random().nextInt(3) + 2),
      const Duration(seconds: 1),
      () {
        if (validateHand(opponent.cards)) {
          winner = opponent;
          opponent.showHand = true;
          _clearAnimation();
          return true;
        }
        return false;
      }
    );
  }

  static Map<String, double> getAnimatedCardInitialPosition() {
    if (cardAnimationType == null) {
      return {'x': 0, 'y': 0};
    }
    if (cardAnimationType! == buyFromPack) {
      return {
        'x': -0.07,
        'y': 0,
        'angle': 0
      };
    }
    if (cardAnimationType! == buyFromTrash) {
      return {
        'x': 0.07,
        'y': 0,
        'angle': 0
      };
    }
    // TODO: Get initial discard position
    return {
        'x': 0,
        'y': -0.5,
        'angle': 0
      };
  }

  static Map<String, double> getAnimatedCardFinalPosition() {
    if (cardAnimationType! == discard) {
      return {
        'x': 0.07,
        'y': 0,
        'angle': 0
      };
    }
    return {
        'x': 0,
        'y': -0.5,
        'angle': 0
      };
  }

  void finishBuyingAnimation() {
    Opponent playing = opponents[_playingIndex];
    playing.add(playing.boughtCard!);
    playing.boughtCard = null;
    _clearAnimation();
  }

  void finishDiscardAnimation() {
    opponents[_playingIndex].playing = false;
    GameController.instance.table.finishOpponentDiscard(opponents[_playingIndex]);
    _clearAnimation();
    callNextPlayer();
     if (_playingIndex == opponents.length) {
      _playingIndex = -1;
      GameController.instance.blockActions = false;
    }
  }

  void _clearAnimation() {
    cardAnimationType = null;
    cardToAnimate = null;
  }
}