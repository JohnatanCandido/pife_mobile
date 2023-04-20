import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/opponent.dart';

import '../components/card_widget.dart';
import 'card_animation_controller.dart';

class TrashController extends ChangeNotifier {

  static TrashController instance = TrashController();

  Map<String, double> getTopOfTrashPosition() {
    Opponent? opponent = OpponentController.instance.opponent;
    if (_opponentBoughtFromTrash(opponent)) {
      return OpponentController.getCardPositionByIndex(opponent!, 9, 10);
    }
    return getTopOfTrashDefaultPosition();
  }

  bool _opponentBoughtFromTrash(Opponent? opponent) {
    return opponent != null
            && GameController.instance.table.trash.isNotEmpty
            && GameController.instance.table.trash.last == opponent.boughtCard;
  }

  Map<String, double> getTopOfTrashDefaultPosition() {
    return {
        'x': CardAnimationController.screenWidth / 2 + 10,
        'y': CardAnimationController.screenHeight / 2 - CardWidget.imgHeight,
        'angle': 0
    };
  }
}