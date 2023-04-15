import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';

import '../../controllers/opponent_controller.dart';
import '../../models/card.dart';
import '../card_widget.dart';

class DiscardAnimation extends StatefulWidget {
  const DiscardAnimation({super.key});

  @override
  State<DiscardAnimation> createState() => _DiscardAnimationState();
}

class _DiscardAnimationState extends State<DiscardAnimation> with SingleTickerProviderStateMixin {

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

  Widget _buildCardWidget() {
    GameCard cardToAnimate = OpponentController.cardToAnimate!;
    Map<String, double> position = OpponentController.getAnimatedCardInitialPosition();
    return CardWidget(position['x']!, position['y']!, position['angle']!, cardToAnimate, showCard: true, cardScale: 1);
  }

  void _onComplete() async {
    GameController.instance.updateGamePage(() {
      OpponentController.instance.finishDiscardAnimation();
    });
  }
}