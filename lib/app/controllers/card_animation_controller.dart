import 'dart:math';

import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/opponent.dart';
import 'package:pife_mobile/app/models/opponent_display_properties.dart';

class CardAnimationController {

  static const _animationDuration = Duration(milliseconds: 500);

  static double screenWidth = 0;
  static double screenHeight = 0;

  static const double _tiltAngleLtR = -30;
  static const double _tiltAngleRtL = 30;


  static Duration get animationDuration => _getAnimationDuration();

  static Duration _getAnimationDuration() {
    Opponent? opponent = OpponentController.instance.opponent;
    if (opponent != null && (opponent.boughtCard != null || opponent.cardDiscarded != null)) {
      return _animationDuration;
    }
    return const Duration(milliseconds: 0);
  }

  static Map<String, double> getHorizontalPosition(Opponent opponent, int index, int length, {bool correctPosition=true}) {
    double relativePosition = _calculateRelativePosition(index, length);

    Map<String, double> cardPosition = {};

    cardPosition['x'] = relativePosition * 10 * opponent.properties.dir + opponent.properties.leftMargin;
    cardPosition['y'] = -pow(relativePosition * 0.7, 2) + opponent.properties.topMargin;
    cardPosition['angle'] = _getAngle(relativePosition, opponent.properties.angleBias);

    if (correctPosition) {
      _correctPosition(cardPosition, opponent, length);
    }

    return cardPosition;
  }

  static void _correctPosition(Map<String, double> cardPosition, Opponent opponent, int length) {
    if (opponent.tiltStyle == OpponentProperties.tiltLeftToRight) {
      Map<String, double> origin = getHorizontalPosition(opponent, 0, length, correctPosition: false);
      double newX = _getXCorrection(cardPosition['x']!, cardPosition['y']!, origin, _tiltAngleLtR);
      double newY = _getYCorrection(cardPosition['x']!, cardPosition['y']!, origin, _tiltAngleLtR);

      cardPosition['x'] = newX;
      cardPosition['y'] = newY;
      cardPosition['angle'] = cardPosition['angle']! - 0.7;

    } else if (opponent.tiltStyle == OpponentProperties.tiltRightToLeft) {
      Map<String, double> origin = getHorizontalPosition(opponent, length-1, length, correctPosition: false);
      double newX = _getXCorrection(cardPosition['x']!, cardPosition['y']!, origin, _tiltAngleRtL);
      double newY = _getYCorrection(cardPosition['x']!, cardPosition['y']!, origin, _tiltAngleRtL);

      cardPosition['x'] = newX;
      cardPosition['y'] = newY;
      cardPosition['angle'] = cardPosition['angle']! + 0.3;
    }
  }

  static double _getXCorrection(double x, double y, Map<String, double> origin, double tiltAngle) {
    double originX = origin['x']!;
    double originY = origin['y']!;

    return originX + cos(_radians(tiltAngle)) * (x - originX) - sin(_radians(tiltAngle)) * (y - originY);
  }

  static double _getYCorrection(double x, double y, Map<String, double> origin, double tiltAngle) {
    double originX = origin['x']!;
    double originY = origin['y']!;

    return originY + sin(_radians(tiltAngle)) * (x - originX) + cos(_radians(tiltAngle)) * (y - originY);
  }

  static double _radians(double degrees) {
    return degrees * pi / 180;
  }

  static Map<String, double> getVerticalPosition(OpponentProperties properties, int index, int length) {
    double relativePosition = _calculateRelativePosition(index, length);

    Map<String, double> cardPosition = {};

    cardPosition['x'] = -pow(relativePosition * 0.7, 2) * properties.cardOrientation + properties.topMargin;
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