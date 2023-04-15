import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class Pack extends StatefulWidget {
  const Pack({super.key});

  @override
  State<Pack> createState() => _PackState();
}

class _PackState extends State<Pack> {

  @override
  Widget build(BuildContext context) {
    CardWidget cardWidget = CardWidget(0, 0.9, 0, GameController.instance.table.getTopOfPack(), showCard: false, cardScale: 1,);
    if (!GameController.instance.buying || GameController.instance.blockActions) {
      return cardWidget;
    }
    return Draggable<GameCard>(
      data: cardWidget.card,
      feedback: cardWidget.getImage(), // widget that's being carried
      dragAnchorStrategy: pointerDragAnchorStrategy,
      childWhenDragging: _getTopOfPackWhileDragging(),
      child: cardWidget, // initial state
      onDragStarted: () => setState(() {
        GameController.instance.setShowBuyingArea(true);
      }),
      onDragEnd: (details) => setState(() {
        GameController.instance.setShowBuyingArea(false);
      }),
    );
  }

  Widget _getTopOfPackWhileDragging() {
    bool onlyOneCard = GameController.instance.table.pack.length == 1;
    if (onlyOneCard) {
      return _getEmptyTrashMarking();
    }
    return CardWidget(0.5, 0.9, 0, GameController.instance.table.getTopOfPack(), showCard: false, cardScale: 1,);
  }

  Container _getEmptyTrashMarking() {
    return Container(
      color: Colors.green[700],
      width: 71,
      height: 96,
    );
  }
}