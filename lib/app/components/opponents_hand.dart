import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
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
  void initState() {
    super.initState();
    OpponentController.instance.addListener(_checkBuyDiscard);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    OpponentController.instance.removeListener(_checkBuyDiscard);
    super.dispose();
  }

  void _checkBuyDiscard() async {
    OpponentController.instance.checkOpponentsTurn();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _buildOpponentsHands());
  }

  List<Widget> _buildOpponentsHands() {
    List<Widget> cards = [];
    for (Opponent opponent in OpponentController.instance.opponents) {
      cards.addAll(_buildOpponentHand(opponent));
    }

    return cards;
  }

  List<Widget> _buildOpponentHand(Opponent opponent) {
    List<Widget> cards = [];
    for (GameCard card in opponent.cards) {
      var cardPosition = OpponentController.getCardPosition(opponent, card);
      CardWidget cardWidget = CardWidget(cardPosition['x']!, cardPosition['y']!, cardPosition['angle']!, card, showCard: opponent.showHand, cardScale: 0.5,);
      cards.add(_buildCardWidget(opponent, cardPosition, cardWidget));
    }
    return cards;
  }

  Widget _buildCardWidget(Opponent opponent, Map<String, double> position, CardWidget cardWidget) {
    if (opponent.discarding) {
      return _buildAnimatedPositioned(position, cardWidget);
    }
    return _buildPositioned(position, cardWidget);
  }

  Positioned _buildPositioned(Map<String, double> position, CardWidget cardWidget) {
    return Positioned(
      left: position['x'],
      top: position['y'],
      child: cardWidget,
    );
  }

  AnimatedPositioned _buildAnimatedPositioned(Map<String, double> position, CardWidget cardWidget) {
    return AnimatedPositioned(
      duration: CardAnimationController.animationDuration,
      left: position['x'],
      top: position['y'],
      onEnd: OpponentController.instance.onDiscardAnimationEnd,
      child: cardWidget,
    );
  }
}