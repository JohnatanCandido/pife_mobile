import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';

import '../models/opponent_display_properties.dart';

class OpponentsWidget extends StatefulWidget {
  const OpponentsWidget({super.key});

  @override
  State<OpponentsWidget> createState() => _OpponentsWidgetState();
}

class _OpponentsWidgetState extends State<OpponentsWidget> {

  _OpponentsWidgetState() {
    opponentsCoordinates = {
    1: [
      top
    ],
    2: [
      topLeft,
      topRight
    ],
    3: [
      top,
      topLeft,
      topRight
    ],
    4: [
      topLeft,
      topRight,
      bottomLeft,
      bottomRight
    ]
  };
  }

  var top = OpponentProperties(x: 0, y: -0.9, angle: 0.086, horizontal: true, dir: 1, angleBias: 0);
  var topLeft = OpponentProperties(x: -0.9, y: -0.8, angle: 0.1, dir: 1, angleBias: 1.5);
  var topRight = OpponentProperties(x: 0.9, y: -0.8, angle: 0.1, dir: -1, angleBias: -1.5, cardOrientation: -1);
  var bottomLeft = OpponentProperties(x: -0.9, y: 0, angle: 0.1, dir: 1, angleBias: 1.5);
  var bottomRight = OpponentProperties(x: 0.9, y: 0, angle: 0.1, dir: -1, angleBias: -1.5, cardOrientation: -1);

  late var opponentsCoordinates;

  @override
  Widget build(BuildContext context) {
    return Stack(children: buildOpponentsHands());
  }

  List<Stack> buildOpponentsHands() {
    List<Stack> hands = [];
    for (Opponent opponent in GameController.instance.opponents) {
      hands.add(buildOpponentHand(opponent, GameController.instance.opponents.indexOf(opponent)));
    }
    
    return hands;
  }

  Stack buildOpponentHand(Opponent opponent, int opponentIndex) {
    List<CardWidget> cards = [];
    for (GameCard card in opponent.cards) {
      int index = opponent.cards.indexOf(card);
      int length = opponent.cards.length;
      double relativePosition = index - (length - 1) / 2;
      double x = 0;
      double y = 0;
      
      if (isHorizontal(opponentIndex)) {
        x = relativePosition * -0.06;
        y = -relativePosition.abs() * 0.01 + getDouble(opponentIndex, 'y');
      } else {
        x = -relativePosition.abs() * 0.01 * getDouble(opponentIndex, 'dir') + getDouble(opponentIndex, 'x');
        y = relativePosition * getDouble(opponentIndex, 'orientation') * 0.04 + getDouble(opponentIndex, 'y');
      }
      double angle = relativePosition * getDouble(opponentIndex, 'angle') + getDouble(opponentIndex, 'angleBias');
      CardWidget cardWidget = CardWidget(x, y, angle, card, showCard: opponent.showHand, cardScale: 0.5,);
      cards.add(cardWidget);
    }
    return buildOpponentHandContainer(cards);
  }

  double getDouble(int index, String value) {
    return opponentsCoordinates[GameController.instance.numberOfOpponents][index].getDouble(value);
  }

  bool isHorizontal(int index) {
    return opponentsCoordinates[GameController.instance.numberOfOpponents]![index].horizontal;
  }

  Stack buildOpponentHandContainer(List<CardWidget> cards) {
    return Stack(children: cards);
  }
}