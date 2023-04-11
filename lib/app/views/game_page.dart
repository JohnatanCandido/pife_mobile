import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/opponents_hand.dart';
import 'package:pife_mobile/app/components/player_hand.dart';
import 'package:pife_mobile/app/components/table_center_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/options_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  _GamePageState() {
    GameController.instance.newGame();
  }

  PlayerWidget player = PlayerWidget();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: GameController.instance, builder: (context, child) {
      return Scaffold(
        backgroundColor: Colors.green[800],
        appBar: AppBar(
          actions: [
            ElevatedButton(
              onPressed: () => {Navigator.of(context).pushReplacementNamed('/')},
              child: const Text('Sair'))
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  OpponentsWidget(),
                  TableCenterWidget(),
                  PlayerWidget(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildBuyingArea(context)
                    ],
                  )
                ]
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  GameController.instance.checkWin();
                });
                if (GameController.instance.won) {
                    _showGameOverDialog(context);
                }
              },
            )
          ]
        ),
      );
    });
  }

  Future<void> _showGameOverDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDialog(
              title: const Text('You win!'),
              content: const Center(child: Text('You won this match! Do you want to play again?'),),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text('Title Screen')
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      GameController.instance.newGame();  
                    });
                    Navigator.of(context).pop();
                  }, child: const Text('Play Again')
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildBuyingArea(BuildContext context) {
    if (GameController.instance.buying && GameController.instance.showBuyingArea) {
      return Container(
        height: 275,
        padding: const EdgeInsets.only(left: 30, right: 30),
        // margin: EdgeInsets.only(top: getMarginBottomBuyingArea(context)),
        child: DragTarget<GameCard>(
          builder:(context, candidateData, rejectedData) {
            return Container();
          },
          onAccept: (GameCard card) {
            setState(() {
              GameController.instance.buy(card);
            });
          },
        ),
      );
    }
    return Container();
  }

  double getMarginBottomBuyingArea(BuildContext context) {
    int length = GameController.instance.player.cards.length;
    double relativePosition = (length - 1) / 2;
    double percent = relativePosition * OptionsController.instance.handArch - OptionsController.instance.cardHeigth + 1;
    print(percent);
    return percent * MediaQuery.of(context).size.height / 100;
  }
}