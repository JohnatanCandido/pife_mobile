import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/player_hand_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

import '../controllers/options_controller.dart';

class BuyingArea extends StatefulWidget {
  const BuyingArea({super.key});

  @override
  State<BuyingArea> createState() => _BuyingAreaState();
}

class _BuyingAreaState extends State<BuyingArea> {

  @override
  void initState() {
    super.initState();
    PlayerHandController.instance.addListener(_setStateMethod);
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
    PlayerHandController.instance.removeListener(_setStateMethod);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (GameController.instance.buying && PlayerHandController.instance.showBuyingArea) {
      return Positioned(
        left: 1,
        bottom: OptionsController.instance.getCardPosition(0)['y']!-100,
        child: SizedBox(
            height: 230,
            width: CardAnimationController.screenWidth,
            child: DragTarget<GameCard>(
              builder:(context, candidateData, rejectedData) {
                return Container(color: Colors.yellow.withOpacity(0.2),);
              },
              onAccept: (GameCard card) {
                  PlayerHandController.instance.buy(card);
              },
            ),
        ),
      );
    }
    return Container();
  }
}