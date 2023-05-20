import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/user_data_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class OptionsController extends ChangeNotifier {

  static OptionsController instance = OptionsController();

  OptionsController() {
    init();
  }

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

  void init() async {
    print('Loading settings...');
    String? json = await UserDataController.load('preferences', 'string') as String?;
    String msg = 'No settings to load';
    if (json != null) {
      Map<String, dynamic> preferences = jsonDecode(json);
      cardSpacing = preferences['cardSpacing'];
      distanceFromBottom = preferences['distanceFromBottom'];
      handArch = preferences['handArch'];
      cardAngle = preferences['cardAngle'];
      cardSpacingTemp = preferences['cardSpacing'];
      distanceFromBottomTemp = preferences['distanceFromBottom'];
      handArchTemp = preferences['handArch'];
      cardAngleTemp = preferences['cardAngle'];
      msg = 'Settings loaded';
    }
    print(msg);
    notifyListeners();
  }

  void saveChanges() async {
    print('Saving settings...');
    Map<String, dynamic> json = {
      'cardSpacing': cardSpacing,
      'distanceFromBottom': distanceFromBottom,
      'handArch': handArch,
      'cardAngle': cardAngle
    };
    UserDataController.save('preferences', json);
    print('Settings saved.');
  }

  void applyChanges() {
    cardSpacing = cardSpacingTemp;
    distanceFromBottom = distanceFromBottomTemp;
    handArch = handArchTemp;
    cardAngle = cardAngleTemp;
    saveChanges();
    notifyListeners();
  }

  void cancel() {
    cardSpacingTemp = cardSpacing;
    distanceFromBottomTemp = distanceFromBottom;
    handArchTemp = handArch;
    cardAngleTemp = cardAngle;
  }

  void defaultValues() {
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