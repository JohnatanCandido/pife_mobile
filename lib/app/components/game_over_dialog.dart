import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/card.dart';

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
                GameController.instance.updateGamePage(() {
                  GameController.instance.newGame();  
                });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('The winner is ${OpponentController.instance.getWinnerName()}!'),
        Padding(
          padding: const EdgeInsets.only(top: 90, bottom: 30),
          child: Stack(children: _buildWinnerHand(),),
        )
      ],
    );
  }

  List<CardWidget> _buildWinnerHand() {
    List<CardWidget> cards = [];
    List<GameCard> winnerCards = OpponentController.instance.winner!.cards;
    for (GameCard card in winnerCards) {
      int index = winnerCards.indexOf(card);
      int length = winnerCards.length;
      double relativePosition = index - (length - 1) / 2;
      double x = relativePosition * 0.15;
      double y = relativePosition.abs() * 0.02 + 0.9;
      double angle = relativePosition * 0.15;
      CardWidget cardWidget = CardWidget(x, y, angle, card);
      cards.add(cardWidget);
    }
    return cards;
  }
}