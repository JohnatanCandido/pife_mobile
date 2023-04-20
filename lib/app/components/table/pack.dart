import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/controllers/pack_controller.dart';
import 'package:pife_mobile/app/controllers/player_hand_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class Pack extends StatefulWidget {
  const Pack({super.key});

  @override
  State<Pack> createState() => _PackState();
}

class _PackState extends State<Pack> {

  @override
  void initState() {
    super.initState();
    PackController.instance.addListener(_setStateMethod);
  }

  void _setStateMethod() {
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    PackController.instance.removeListener(_setStateMethod);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];
    if (GameController.instance.table.pack.isNotEmpty) {
      cards.add(_buildPositioned(_getSecondToLastFromPack(), false));
    }
    cards.add(_buildPositioned(_buildPack(), GameController.instance.blockActions));
    return Stack(children: cards,);
  }

  Widget _buildPositioned(Widget child, bool animated) {
    if (animated) {
      Map<String, double> position = PackController.instance.getTopOfPackPosition();
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
      left: CardAnimationController.screenWidth / 2 - CardWidget.imgWidth - 10,
      child: child
    );
  }

  Widget _buildPack() {
    if (GameController.instance.blockActions || !GameController.instance.buying) {
      return _getTopOfPack();
    }
    return _buildPackBuying();
  }

  CardWidget _getTopOfPack() {
    return CardWidget(0.5, 0.9, 0, GameController.instance.table.getTopOfPack(), cardScale: 1,);
  }

  Widget _buildPackBuying() {
    CardWidget cardWidget = _getTopOfPack();
    return Draggable<GameCard>(
      data: cardWidget.card,
      feedback: cardWidget.getImage(), // widget that's being carried
      dragAnchorStrategy: pointerDragAnchorStrategy,
      childWhenDragging: Container(),
      child: cardWidget, // initial state
      onDragStarted: () => setState(() {
        PlayerHandController.instance.setShowBuyingArea(true);
      }),
      onDragEnd: (details) => setState(() {
        PlayerHandController.instance.setShowBuyingArea(false);
      }),
    );
  }

  Widget _getSecondToLastFromPack() {
    GameCard? card = GameController.instance.table.getSecondToLastFromPack();
    if (card == null) {
      return _getEmptyPackMarking();
    }
    return CardWidget(0.5, 0.9, 0, card, cardScale: 1,);
  }

  Container _getEmptyPackMarking() {
    return Container(
      color: Colors.green[700],
      width: CardWidget.imgWidth,
      height: CardWidget.imgHeight,
    );
  }
}