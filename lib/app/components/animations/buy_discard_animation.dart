import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/animations/buy_animation.dart';
import 'package:pife_mobile/app/components/animations/discard_animation.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';

class BuyDiscardAnimation extends StatelessWidget {
  const BuyDiscardAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    if (OpponentController.cardAnimationType == null) {
      OpponentController.instance.checkOpponentsTurn();
    }
    if (OpponentController.cardAnimationType == OpponentController.discard) {
      return const DiscardAnimation();
    }
    if ([OpponentController.buyFromPack, OpponentController.buyFromTrash].contains(OpponentController.cardAnimationType)) {
      return const BuyAnimation();
    }
    return Container();
  }
}