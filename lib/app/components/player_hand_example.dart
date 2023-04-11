import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';

import '../controllers/options_controller.dart';

class PlayerExampleWidget extends StatefulWidget {
  const PlayerExampleWidget({super.key});

  @override
  State<PlayerExampleWidget> createState() => _PlayerExampleWidgetState();
}

class _PlayerExampleWidgetState extends State<PlayerExampleWidget> {

  _PlayerExampleWidgetState() {
    for (int i = 1; i < 10; i++) {
      GameCard card = GameCard(i, i.toString(), '', 'assets/img_cartas/${i}_copas.png');
      player.cards.add(card);
    }
  }

  BasePlayer player = BasePlayer(true);
  GameCard tenthCard = GameCard(10, '10', '', 'assets/img_cartas/10_copas.png');

  void checkAddRemoveTenthCard() {
    if (OptionsController.instance.tenthCard && !player.cards.contains(tenthCard)) {
      player.cards.add(tenthCard);
    } else if (!OptionsController.instance.tenthCard) {
      player.cards.remove(tenthCard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: buildHand());
  }

  List<CardWidget> buildHand() {
    checkAddRemoveTenthCard();
    List<CardWidget> cards = [];
    for (GameCard card in player.cards) {
      int index = player.cards.indexOf(card);
      int length = player.cards.length;
      double relativePosition = index - (length - 1) / 2;
      double x = relativePosition * OptionsController.instance.cardSpacingTemp;
      double y = relativePosition.abs() * OptionsController.instance.handArchTemp - OptionsController.instance.cardHeigthTemp + 0.9;
      double angle = relativePosition * OptionsController.instance.cardAngleTemp;
      CardWidget cardWidget = CardWidget(x, y, angle, card);
      cards.add(cardWidget);
    }
    return cards;
  }
}