import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          title: Text(GameController.instance.won ? 'You win!' : 'You Lose'),
          content: _buildGameOverDialogContent(),
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
                GameController.instance.newGame();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again')
            )
          ],
        ),
      ],
    );
  }

  Widget _buildGameOverDialogContent() {
    if (GameController.instance.won) {
      return const Center(child: Text('You won this match! Do you want to play again?'));
    }
    return SizedBox(
      width: CardAnimationController.screenWidth,
      height: 250,
      child: Stack(children: _buildWinnerHand(),)
    );
  }

  List<Widget> _buildWinnerHand() {
    List<Widget> objects = [];
    objects.add(Text('The winner is ${OpponentController.instance.getWinnerName()}!'));

    Opponent winner = OpponentController.instance.winner!;
    for (GameCard card in winner.cards) {
      var cardPosition = CardAnimationController.getGameOverHandPosition(winner.cards.indexOf(card), winner.cards.length);
      CardWidget cardWidget = CardWidget(cardPosition['x']!, cardPosition['y']!, cardPosition['angle']!, card);
      objects.add(_buildPositioned(cardWidget));
    } 
    return objects;
  }

  Positioned _buildPositioned(CardWidget cardWidget) {
    return Positioned(
      left: cardWidget.x,
      bottom: cardWidget.y,
      child: cardWidget,
    );
  }
}