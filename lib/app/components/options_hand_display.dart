import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/models/card.dart';

import '../controllers/options_controller.dart';

class OptionsHandDisplay extends StatefulWidget {
  const OptionsHandDisplay({super.key});

  @override
  State<OptionsHandDisplay> createState() => _OptionsHandDisplayState();
}

class _OptionsHandDisplayState extends State<OptionsHandDisplay> {

  @override
  Widget build(BuildContext context) {
    return Stack(children: _buildHand());
  }

  List<CardWidget> _buildHand() {
    List<CardWidget> cardList = [];
    List<GameCard> cards = OptionsController.instance.getCards();
    int length = cards.length;
    for (GameCard card in cards) {
      int index = cards.indexOf(card);
      double relativePosition = index - (length - 1) / 2;
      double x = relativePosition * OptionsController.instance.cardSpacingTemp;
      double y = relativePosition.abs() * OptionsController.instance.handArchTemp - OptionsController.instance.cardHeigthTemp + 0.9;
      double angle = relativePosition * OptionsController.instance.cardAngleTemp;
      CardWidget cardWidget = CardWidget(x, y, angle, card);
      cardList.add(cardWidget);
    }
    return cardList;
  }
}