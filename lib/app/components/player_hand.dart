import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/controllers/options_controller.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {

  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return buildHand();
  }

  Stack buildHand() {
    List<Draggable<GameCard>> cards = [];
    for (GameCard card in GameController.instance.player.cards) {
      int index = GameController.instance.player.cards.indexOf(card);
      int length = GameController.instance.player.cards.length;
      double relativePosition = index - (length - 1) / 2;
      double x = relativePosition * OptionsController.instance.cardSpacing;
      double y = relativePosition.abs() * OptionsController.instance.handArch - OptionsController.instance.cardHeigth + 0.9;
      double angle = relativePosition * OptionsController.instance.cardAngle;
      CardWidget cardWidget = CardWidget(x, y, angle, card, isBeingCarried: card == GameController.instance.selectedCard,);
      cards.add(buildDraggable(cardWidget));
    }
    return Stack(children: cards);
  }

  Draggable<GameCard> buildDraggable(CardWidget cardWidget) {
    return Draggable<GameCard>(
      data: cardWidget.card,
      feedback: cardWidget.getImage(), // widget that's being carried
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () => setState(() {
        GameController.instance.selectedCard = cardWidget.card;
      }),
      onDragEnd: (details) => setState(() {
        
        GameController.instance.selectedCard = null;
      }),
      onDragUpdate: (details) => setState(() {
        GameController.instance.organizeCards(details.localPosition.dx, screenWidth);
      }),
      child: cardWidget, // initial state
    );
  }

  
}
