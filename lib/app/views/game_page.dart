import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/buying_area.dart';
import 'package:pife_mobile/app/components/game_app_bar.dart';
import 'package:pife_mobile/app/components/opponents_hand.dart';
import 'package:pife_mobile/app/components/player_hand.dart';
import 'package:pife_mobile/app/components/table/pack.dart';
import 'package:pife_mobile/app/components/table/trash.dart';
import 'package:pife_mobile/app/components/turn_marker.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/controllers/options_controller.dart';

import '../components/game_over_dialog.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  _GamePageState() {
    GameController.instance.newGame();
  }

  @override
  void initState() {
    super.initState();
    GameController.instance.addListener(_setStateMethod);
    OptionsController.instance.addListener(_setStateMethod);
  }

  void _setStateMethod() {
    setState(() {
      if (OpponentController.instance.winner != null) {
        _showGameOverDialog();
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    GameController.instance.removeListener(_setStateMethod);
    OptionsController.instance.removeListener(_setStateMethod);
    OpponentController.instance.reset();
    super.dispose();
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
              height: CardAnimationController.screenHeight,
              child: Stack(
                children: [
                  Pack(),
                  Trash(),
                  OpponentsHand(),
                  PlayerHand(),
                  BuyingArea(),
                  TurnMarker(),
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