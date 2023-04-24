import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/player_hand_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class PlayerHand extends StatefulWidget {
  const PlayerHand({super.key});

  @override
  State<PlayerHand> createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {

  @override
  void initState() {
    super.initState();
    PlayerHandController.instance.addListener(_setStateMethod);
  }

  void _setStateMethod() {
    setState(() {});
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    PlayerHandController.instance.removeListener(_setStateMethod);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Positioned> cards = [];
    for (GameCard card in GameController.instance.player.cards) {
      var position = GameController.instance.getCardPosition(card);
      CardWidget cardWidget = CardWidget(
        position['x']!,
        position['y']!,
        position['angle']!,
        card,
        isBeingCarried: card == PlayerHandController.instance.selectedCard,
      );
      cards.add(_buildPositioned(cardWidget));
    }
    return Stack(children: cards);
  }

  Positioned _buildPositioned(CardWidget cardWidget) {
    return Positioned(
      left: cardWidget.x,
      bottom: cardWidget.y,
      child: _rotate(_scale(_buildDraggable(cardWidget), cardWidget.cardScale), cardWidget.angle),
    );
  }

  Widget _scale(Widget widget, double scale) {
    return Transform.scale(
      scale: scale,
      child: widget,
    );
  }

  Widget _rotate(Widget widget, double angle) {
    return Transform.rotate(
      angle: angle,
      child: widget,
    );
  }

  Draggable<GameCard> _buildDraggable(CardWidget cardWidget) {
    return Draggable<GameCard>(
      data: cardWidget.card,
      feedback: cardWidget.getScaledImage(), // widget that's being carried
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () {
        PlayerHandController.instance.selectCard(cardWidget.card);
      },
      onDragEnd: (details) {
        PlayerHandController.instance.dropCard();
      },
      onDragUpdate: (details) {
        PlayerHandController.instance.organizeCards(details.localPosition.dx);
      },
      child: cardWidget.getImage(), // initial state
    );
  }
}
