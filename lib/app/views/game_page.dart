import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/animations/buy_discard_animation.dart';
import 'package:pife_mobile/app/components/buying_area.dart';
import 'package:pife_mobile/app/components/game_app_bar.dart';
import 'package:pife_mobile/app/components/opponents_hand.dart';
import 'package:pife_mobile/app/components/player_hand.dart';
import 'package:pife_mobile/app/components/table/table_center.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';

import '../components/game_over_dialog.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  _GamePageState() {
    GameController.instance.updateGamePage = updateGamePage;
    GameController.instance.newGame();
  }

  void updateGamePage(Function function) {
    setState(() {
      function();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: GameController.instance, builder: (context, child) {
      return Scaffold(
        backgroundColor: Colors.green[800],
        appBar: const GameAppBar(),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  OpponentsHand(),
                  TableCenter(),
                  PlayerHand(),
                  BuyingArea(),
                  BuyDiscardAnimation(),
                ]
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  GameController.instance.checkWin();
                });
                if (GameController.instance.won) {
                    _showGameOverDialog();
                }
              },
            )
          ]
        ),
      );
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