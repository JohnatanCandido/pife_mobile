import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';

import '../controllers/opponent_controller.dart';

class OpponentsHand extends StatefulWidget {
  const OpponentsHand({super.key});

  @override
  State<OpponentsHand> createState() => _OpponentsHandState();
}

class _OpponentsHandState extends State<OpponentsHand> {

  @override
  Widget build(BuildContext context) {
    return Stack(children: _buildOpponentsHands());
  }

  List<Stack> _buildOpponentsHands() {
    List<Stack> hands = [];
    for (Opponent opponent in OpponentController.instance.opponents) {
      hands.add(_buildOpponentHand(opponent, OpponentController.instance.opponents.indexOf(opponent)));
    }
    
    return hands;
  }

  Stack _buildOpponentHand(Opponent opponent, int opponentIndex) {
    List<CardWidget> cards = [];
    for (GameCard card in opponent.cards) {
      var cardPosition = OpponentController.instance.getCardPosition(opponent, opponentIndex, card);
      CardWidget cardWidget = CardWidget(cardPosition['x']!, cardPosition['y']!, cardPosition['angle']!, card, showCard: opponent.showHand, cardScale: 0.5,);
      cards.add(cardWidget);
    }
    return Stack(children: cards);
  }
}