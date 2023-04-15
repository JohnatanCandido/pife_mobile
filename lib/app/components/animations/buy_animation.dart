import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/components/game_over_dialog.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class BuyAnimation extends StatefulWidget {
  const BuyAnimation({super.key});

  @override
  State<BuyAnimation> createState() => _BuyAnimationState();
}

class _BuyAnimationState extends State<BuyAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _onComplete();
        });
      }
    });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (OpponentController.cardToAnimate == null) {
      return Container();
    }

    return SlideTransition(
      position: _buildAnimation(),
      child: _buildCardWidget(),
    );
  }

  Animation<Offset> _buildAnimation() {
    Map<String, double> initialPosition = OpponentController.getAnimatedCardInitialPosition();
    Map<String, double> finalPosition = OpponentController.getAnimatedCardFinalPosition();
    return Tween<Offset>(
      begin: Offset(initialPosition['x']!, initialPosition['y']!),
      end: Offset(finalPosition['x']!, finalPosition['y']!),
    ).animate(_controller);
  }

  CardWidget _buildCardWidget() {
    GameCard cardToAnimate = OpponentController.cardToAnimate!;
    Map<String, double> position = OpponentController.getAnimatedCardInitialPosition();
    bool showCard = OpponentController.cardAnimationType == OpponentController.buyFromTrash;
    return CardWidget(position['x']!, position['y']!, position['angle']!, cardToAnimate, showCard: showCard, cardScale: 1);
  }

  void _onComplete() async {
    GameController.instance.updateGamePage(() {
      OpponentController.instance.finishBuyingAnimation();
    });
    bool opponentWon = await OpponentController.instance.opponentDiscard();
    GameController.instance.updateGamePage(() {
      if (!opponentWon) {
        OpponentController.cardAnimationType = OpponentController.discard;
      } else {
        _showGameOverDialog();
      }
    });
  }

  Future<void> _showGameOverDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return const GameOverDialog();
      },
    );
  }
}