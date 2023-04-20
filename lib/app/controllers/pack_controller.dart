import 'package:flutter/material.dart';

import '../components/card_widget.dart';
import '../models/opponent.dart';
import 'card_animation_controller.dart';
import 'game_controller.dart';
import 'opponent_controller.dart';

class PackController extends ChangeNotifier {

  static PackController instance = PackController();

  Map<String, double> getTopOfPackPosition() {
    Opponent? opponent = OpponentController.instance.opponent;
    if (_opponentBoughtFromPack(opponent)) {
      return OpponentController.getCardPositionByIndex(opponent!, 9, 10);
    }
    return {
        'x': CardAnimationController.screenWidth / 2 - CardWidget.imgWidth - 10,
        'y': CardAnimationController.screenHeight / 2 - CardWidget.imgHeight
    };
  }

  bool _opponentBoughtFromPack(Opponent? opponent) {
    return opponent != null
            && GameController.instance.table.pack.isNotEmpty
            && GameController.instance.table.pack.last == opponent.boughtCard;
  }

}