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

  List<Positioned> _buildHand() {
    List<Positioned> cardList = [];
    List<GameCard> cards = OptionsController.instance.getCards();
    int length = cards.length;
    for (GameCard card in cards) {
      int index = cards.indexOf(card);
      double relativePosition = index - (length - 1) / 2;
      var position = OptionsController.instance.getCardPositionTemp(relativePosition);
      CardWidget cardWidget = CardWidget(
        position['x']!,
        position['y']!,
        position['angle']!,
        card,
      );
      cardList.add(_buildPositioned(cardWidget));
    }
    return cardList;
  }

  Positioned _buildPositioned(CardWidget cardWidget) {
    return Positioned(
      left: cardWidget.x,
      bottom: cardWidget.y,
      child: cardWidget,
    );
  }
}