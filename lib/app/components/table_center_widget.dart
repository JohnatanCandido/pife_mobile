import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/components/game_winner_hand_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class TableCenterWidget extends StatefulWidget {
  const TableCenterWidget({super.key});

  @override
  State<TableCenterWidget> createState() => _TableCenterWidgetState();
}

class _TableCenterWidgetState extends State<TableCenterWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPack(),
            Container(width: 10,),
            buildTrash()
          ],
        )
      ],
    );
  }

  Widget buildPack() {
    CardWidget cardWidget = CardWidget(0, 0.9, 0, GameController.instance.table.getTopOfPack(), showCard: false, cardScale: 1,);
    if (!GameController.instance.buying || GameController.instance.blockActions) {
      return cardWidget;
    }
    return Draggable<GameCard>(
      data: cardWidget.card,
      feedback: cardWidget.getImage(), // widget that's being carried
      dragAnchorStrategy: pointerDragAnchorStrategy,
      child: cardWidget, // initial state
      onDragStarted: () => setState(() {
        GameController.instance.setShowBuyingArea(true);
      }),
      onDragEnd: (details) => setState(() {
        GameController.instance.setShowBuyingArea(false);
      }),
    );
  }

  Widget buildTrash() {
    if (GameController.instance.blockActions) {
      return getTopOfTrash();
    }
    if (GameController.instance.buying) {
      return buildTrashBuying();
    }
    return buildTrashDiscarding();
  }

  Widget buildTrashBuying() {
    Widget topOfTrash = getTopOfTrash();
    if (topOfTrash is Container) {
      return topOfTrash;
    }
    CardWidget cardWidget = topOfTrash as CardWidget;
    return Draggable<GameCard>(
      data: cardWidget.card,
      feedback: cardWidget.getImage(), // widget that's being carried
      dragAnchorStrategy: pointerDragAnchorStrategy,
      childWhenDragging: getTopOfTrashWhileDragging(),
      child: cardWidget, // initial state
      onDragStarted: () => setState(() {
        GameController.instance.setShowBuyingArea(true);
      }),
      onDragEnd: (details) => setState(() {
        GameController.instance.setShowBuyingArea(false);
      }),
    );
  }

  DragTarget<GameCard> buildTrashDiscarding() {
    return DragTarget(
      builder:(context, candidateData, rejectedData) {
      return getTopOfTrash();
      },
      onAccept:(GameCard card) {
        setState(() {
          GameController.instance.discard(card);
          
        });
        if (GameController.instance.lost) {
            _showGameOverDialog(context);
        }
      },
    );
  }

  Widget getTopOfTrash() {
    if (GameController.instance.table.trash.isEmpty) {
      return getEmptyTrashMarking();
    }
    return CardWidget(0.5, 0.9, 0, GameController.instance.table.trash.last, cardScale: 1,);
  }

  Widget getTopOfTrashWhileDragging() {
    GameCard? card = GameController.instance.table.getSecondToLastFromTrash();
    if (card == null) {
      return getEmptyTrashMarking();
    }
    return CardWidget(0.5, 0.9, 0, card, cardScale: 1,);
  }

  Container getEmptyTrashMarking() {
    return Container(
      color: Colors.green[700],
      width: 71,
      height: 96,
      child: const Center(
        child: Text('Trash'),
      ),
    );
  }

  Future<void> _showGameOverDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDialog(
              title: const Text('You Lose'),
              content: _getGameOverDialogContent(),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text('Title Screen')
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      GameController.instance.newGame();
                      Navigator.of(context).pop();
                    });
                  }, child: const Text('Play Again')
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _getGameOverDialogContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('The winner is ${GameController.instance.getWinnerName()}!'),
        const GameWinnerHandWidget()
      ],
    );
  }
}