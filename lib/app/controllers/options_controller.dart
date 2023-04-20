import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class OptionsController extends ChangeNotifier {

  static OptionsController instance = OptionsController();

  bool tenthCard = true;

  final double _defaultCardSpacing = 20;
  final double _defaultDistanceFromBottom = 75;
  final double _defaultHandArch = 1;
  final double _defaultCardAngle = 0.2;

  double cardSpacing = 20;
  double distanceFromBottom = 75;
  double handArch = 1;
  double cardAngle = 0.2;

  double cardSpacingTemp = 20;
  double distanceFromBottomTemp = 75;
  double handArchTemp = 1;
  double cardAngleTemp = 0.2;

  void applyChanges() {
    cardSpacing = cardSpacingTemp;
    distanceFromBottom = distanceFromBottomTemp;
    handArch = handArchTemp;
    cardAngle = cardAngleTemp;
    notifyListeners();
  }

  void cancel() {
    cardSpacingTemp = cardSpacing;
    distanceFromBottomTemp = distanceFromBottom;
    handArchTemp = handArch;
    cardAngleTemp = cardAngle;
  }

  void defaultValues() {
    cardSpacing = _defaultCardSpacing;
    distanceFromBottom = _defaultDistanceFromBottom;
    handArch = _defaultHandArch;
    cardAngle = _defaultCardAngle;
    cardSpacingTemp = _defaultCardSpacing;
    distanceFromBottomTemp = _defaultDistanceFromBottom;
    handArchTemp = _defaultHandArch;
    cardAngleTemp = _defaultCardAngle;
  }

  void toggleTenthCard() {
    tenthCard = !tenthCard;
  }

  List<GameCard> getCards() {
    int size = tenthCard ? 10 : 9;
    List<GameCard> cards = [];
    for (int i = 1; i <= size; i++) {
      GameCard card = GameCard(i, i.toString(), '', 'assets/img_cartas/${i}_copas.png');
      cards.add(card);
    }
    return cards;
  }

  Map<String, double> getCardPosition(double relativePosition) {
    return _getCardPosition(
      relativePosition,
      cardSpacing,
      handArch,
      distanceFromBottom,
      cardAngle
    );
  }

  Map<String, double> getCardPositionTemp(double relativePosition) {
    return _getCardPosition(
      relativePosition,
      cardSpacingTemp,
      handArchTemp,
      distanceFromBottomTemp,
      cardAngleTemp
    );
  }

  Map<String, double> _getCardPosition(double relativePosition, double spacing, double archHeight, double bottomDistance, double angle) {
    double screenWidth = CardAnimationController.screenWidth - 70;
    return {
      'x': relativePosition * spacing + (screenWidth / 2),
      'y': -pow(relativePosition * archHeight, 2) + bottomDistance,
      'angle':  relativePosition * angle
    };
  }
}