import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class GameWinnerHandWidget extends StatelessWidget {
  const GameWinnerHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: buildHand(),);
  }

  List<CardWidget> buildHand() {
    List<CardWidget> cards = [];
    List<GameCard> winnerCards = GameController.instance.winner!.cards;
    for (GameCard card in winnerCards) {
      int index = winnerCards.indexOf(card);
      int length = winnerCards.length;
      double relativePosition = index - (length - 1) / 2;
      double x = relativePosition * 0.15;
      double y = relativePosition.abs() * 0.02 + 0.9;
      double angle = relativePosition * 0.15;
      CardWidget cardWidget = CardWidget(x, y, angle, card);
      cards.add(cardWidget);
    }
    return cards;
  }
}