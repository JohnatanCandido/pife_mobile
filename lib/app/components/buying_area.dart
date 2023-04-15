import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

import '../controllers/options_controller.dart';

class BuyingArea extends StatefulWidget {
  const BuyingArea({super.key});

  @override
  State<BuyingArea> createState() => _BuyingAreaState();
}

class _BuyingAreaState extends State<BuyingArea> {

  @override
  Widget build(BuildContext context) {
    if (GameController.instance.buying && GameController.instance.showBuyingArea) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 275,
            padding: const EdgeInsets.only(left: 30, right: 30),
            // margin: EdgeInsets.only(top: _getMarginBottomBuyingArea(context)),
            child: DragTarget<GameCard>(
              builder:(context, candidateData, rejectedData) {
                return Container(color: Colors.yellow.withOpacity(0.2),);
              },
              onAccept: (GameCard card) {
                GameController.instance.updateGamePage(() {
                  GameController.instance.buy(card);
                });
              },
            ),
          ),
        ],
      );
    }
    return Container();
  }

  double _getMarginBottomBuyingArea(BuildContext context) {
    int length = GameController.instance.player.cards.length;
    double relativePosition = (length - 1) / 2;
    double percent = relativePosition * OptionsController.instance.handArch - OptionsController.instance.cardHeigth + 1;
    print(percent);
    return percent * MediaQuery.of(context).size.height / 100;
  }
}