import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/controllers/player_hand_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

import '../../controllers/card_animation_controller.dart';
import '../../controllers/trash_controller.dart';

class Trash extends StatefulWidget {
  const Trash({super.key});

  @override
  State<Trash> createState() => TrashState();
}

class TrashState extends State<Trash> {

  @override
  void initState() {
    super.initState();
    TrashController.instance.addListener(_setStateMethod);
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
    TrashController.instance.removeListener(_setStateMethod);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];
    if (GameController.instance.table.trash.isNotEmpty) {
      cards.add(_buildPositioned(_getSecondToLastFromTrash(), false));
    }
    cards.add(_buildPositioned(_buildTrash(), GameController.instance.blockActions));
    return Stack(children: cards,);
  }

  Widget _buildPositioned(Widget child, bool animated) {
    if (animated) {
      Map<String, double> position = TrashController.instance.getTopOfTrashPosition();
      return AnimatedPositioned(
        duration: CardAnimationController.animationDuration,
        left: position['x'],
        top: position['y'],
        onEnd: OpponentController.instance.onBuyAnimationEnd,
        child: child,
      );
    }
    return Positioned(
      top: CardAnimationController.screenHeight / 2 - CardWidget.imgHeight,
      left: CardAnimationController.screenWidth / 2 + 10,
      child: child
    );
  }

  Widget _buildTrash() {
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
        PlayerHandController.instance.discard(card);
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
      childWhenDragging: _getSecondToLastFromTrash(),
      child: cardWidget, // initial state
      onDragStarted: () => setState(() {
        PlayerHandController.instance.setShowBuyingArea(true);
      }),
      onDragEnd: (details) => setState(() {
        PlayerHandController.instance.setShowBuyingArea(false);
      }),
    );
  }

  Widget _getSecondToLastFromTrash() {
    GameCard? card = GameController.instance.table.getSecondToLastFromTrash();
    if (card == null) {
      return _getEmptyTrashMarking();
    }
    return CardWidget(0.5, 0.9, 0, card, cardScale: 1,);
  }

  Container _getEmptyTrashMarking() {
    return Container(
      color: Colors.green[700],
      width: CardWidget.imgWidth,
      height: CardWidget.imgHeight,
      child: const Center(
        child: Text('Trash'),
      ),
    );
  }
}