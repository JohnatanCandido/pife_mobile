import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/controllers/options_controller.dart';
import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/opponent.dart';
import 'package:pife_mobile/app/models/opponent_display_properties.dart';

class TurnMarkerController extends ChangeNotifier {

  static TurnMarkerController instance = TurnMarkerController();

  BasePlayer get _currentPlayer => OpponentController.instance.opponent == null ? GameController.instance.player : OpponentController.instance.opponent!;

  Map<String, double> getPosition() {
    if (_currentPlayer is Opponent) {
      return _getOpponentMarkerPosition();
    }
    return _getPlayerMarkerPosition();
  }

  Map<String, double> _getOpponentMarkerPosition() {
    var properties = _getOpponentPosition();
    return {
      'left': properties['x']!,
      'top': properties['y']!,
    };
  }

  Map<String, double> _getOpponentPosition() {
    Opponent opponent = (_currentPlayer as Opponent);
    Map<String, double> position;

    if (opponent.isHorizontal()) {
      position = CardAnimationController.getHorizontalPosition(opponent, 5, 9);
    } else {
      position = CardAnimationController.getVerticalPosition(opponent.properties, 5, 9);
    }

    return _addOffset(opponent.properties, position);
  }

  Map<String, double> _addOffset(OpponentProperties? properties, Map<String, double> position) {
    double x = position['x']!;
    double y = position['y']!;
    if (properties == null) {
      x += 30;
      y += 435;
    }
    if ([OpponentProperties.top, OpponentProperties.topLeft, OpponentProperties.topRight].contains(properties)) {
      x += 41;
      y += 102;
    }
    if (properties == OpponentProperties.bottomLeft) {
      x += 90;
      y += 33;
    }
    if (properties == OpponentProperties.bottomRight) {
      x += -29;
      y += 53;
    }

    return {'x': x, 'y': y,};
  }

  Map<String, double> _getPlayerMarkerPosition() {
    var position = OptionsController.instance.getCardPosition(0);
    position = _addOffset(null, position);
    return {
      'left': position['x']!,
      'top': position['y']!,
    };
  }
}