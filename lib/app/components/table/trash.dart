import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class Trash extends StatefulWidget {
  const Trash({super.key});

  @override
  State<Trash> createState() => TrashState();
}

class TrashState extends State<Trash> {

  @override
  Widget build(BuildContext context) {
    if (GameController.instance.blockActions) {
      return _getTopOfTrash();
    }
    if (GameController.instance.buying) {
      return _buildTrashBuying();
    }
    return _buildTrashDiscarding();
  }

  DragTarget<GameCard> _buildTrashDiscarding() {
    return DragTarget(
      builder:(context, candidateData, rejectedData) {
      return _getTopOfTrash();
      },
      onAccept:(GameCard card) {
        setState(() {
          GameController.instance.discard(card);
        });
      },
    );
  }

  Widget _getTopOfTrash() {
    if (GameController.instance.table.trash.isEmpty) {
      return _getEmptyTrashMarking();
    }
    return CardWidget(0.5, 0.9, 0, GameController.instance.table.trash.last, cardScale: 1,);
  }

  Widget _buildTrashBuying() {
    Widget topOfTrash = _getTopOfTrash();
    if (topOfTrash is Container) {
      return topOfTrash;
    }

    CardWidget cardWidget = topOfTrash as CardWidget;
    return Draggable<GameCard>(
      data: cardWidget.card,
      feedback: cardWidget.getImage(), // widget that's being carried
      dragAnchorStrategy: pointerDragAnchorStrategy,
      childWhenDragging: _getTopOfTrashWhileDragging(),
      child: cardWidget, // initial state
      onDragStarted: () => setState(() {
        GameController.instance.setShowBuyingArea(true);
      }),
      onDragEnd: (details) => setState(() {
        GameController.instance.setShowBuyingArea(false);
      }),
    );
  }

  Widget _getTopOfTrashWhileDragging() {
    GameCard? card = GameController.instance.table.getSecondToLastFromTrash();
    if (card == null) {
      return _getEmptyTrashMarking();
    }
    return CardWidget(0.5, 0.9, 0, card, cardScale: 1,);
  }

  Container _getEmptyTrashMarking() {
    return Container(
      color: Colors.green[700],
      width: 71,
      height: 96,
      child: const Center(
        child: Text('Trash'),
      ),
    );
  }
}