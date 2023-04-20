import 'dart:math';

import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/opponent.dart';
import 'package:pife_mobile/app/models/opponent_display_properties.dart';

class CardAnimationController {

  static const _animationDuration = Duration(milliseconds: 500);

  static double screenWidth = 0;
  static double screenHeight = 0;


  static Duration get animationDuration => _getAnimationDuration();

  static Duration _getAnimationDuration() {
    Opponent? opponent = OpponentController.instance.opponent;
    if (opponent != null && (opponent.boughtCard != null || opponent.cardDiscarded != null)) {
      return _animationDuration;
    }
    return const Duration(milliseconds: 0);
  }

  static Map<String, double> getHorizontalPosition(OpponentProperties properties, int index, int length) {
    double relativePosition = _calculateRelativePosition(index, length);

    Map<String, double> cardPosition = {};

    // cardPosition['x'] = relativePosition * 10 * opponent.properties.dir + opponent.properties.leftMargin;
    cardPosition['x'] = relativePosition * 10 * properties.dir + properties.leftMargin;
    // cardPosition['y'] = -pow(relativePosition * 0.7, 2) + opponent.properties.topMargin;
    cardPosition['y'] = -pow(relativePosition * 0.7, 2) + properties.topMargin;
    cardPosition['angle'] = _getAngle(relativePosition, properties.angleBias);

    return cardPosition;
  }

  static Map<String, double> getVerticalPosition(OpponentProperties properties, int index, int length) {
    double relativePosition = _calculateRelativePosition(index, length);

    Map<String, double> cardPosition = {};

    cardPosition['x'] = -pow(relativePosition * 0.7, 2) * properties.cardOrientation + properties.topMargin;
    // cardPosition['y'] = relativePosition * 10 * opponent.properties.dir * opponent.properties.cardOrientation + opponent.properties.leftMargin;
    cardPosition['y'] = relativePosition * 10 * properties.dir + properties.leftMargin;
    cardPosition['angle'] = _getAngle(relativePosition, properties.angleBias);

    return cardPosition;
  }

  static Map<String, double> getGameOverHandPosition(int index, int length) {
    double relativePosition = index - (length - 1) / 2;
    return {
      'x': relativePosition * 15 + (screenWidth * 0.265), // maybe 115
      'y': -pow(relativePosition, 2) + 50,
      'angle':  relativePosition * 0.2
    };
  }

  static double _calculateRelativePosition(int index, int length) {
    return index - (length - 1) / 2;
  }

  static double _getAngle(double relativePosition, double angleBias) {
    return relativePosition * 0.2 + angleBias; 
  }

}