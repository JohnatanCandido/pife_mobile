import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/card_widget.dart';
import 'package:pife_mobile/app/controllers/ad_controller.dart';
import 'package:pife_mobile/app/controllers/card_animation_controller.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/opponent_controller.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameOverDialog extends StatefulWidget {
  const GameOverDialog({super.key});

  @override
  State<GameOverDialog> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> {

  @override
  Widget build(BuildContext context) {
    String dialogTitle = GameController.instance.won ? AppLocalizations.of(context)!.youWin : AppLocalizations.of(context)!.youLose;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          title: Text(dialogTitle),
          content: _buildGameOverDialogContent(context),
          actions: [
            TextButton(
              onPressed: () => _checkShowAd(false),
              child: Text(AppLocalizations.of(context)!.titleScreen)
            ),
            TextButton(
              onPressed: () => _checkShowAd(true),
              child: Text(AppLocalizations.of(context)!.playAgain)
            )
          ],
        ),
      ],
    );
  }

  Widget _buildGameOverDialogContent(BuildContext context) {
    if (GameController.instance.won) {
      return Center(child: Text(AppLocalizations.of(context)!.winnerText));
    }
    return SizedBox(
      width: CardAnimationController.screenWidth,
      height: 250,
      child: Stack(children: _buildWinnerHand(context),)
    );
  }

  List<Widget> _buildWinnerHand(BuildContext context) {
    List<Widget> objects = [];
    objects.add(Text(AppLocalizations.of(context)!.loserText(OpponentController.instance.getWinnerNumber())));

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

  void _startNewGame() {
    GameController.instance.newGame();
    Navigator.of(context).pop();
  }

  void _goToTitleScreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _checkShowAd(bool startNewGame) {
    if (startNewGame) {
      AdController.instance.checkShowAd(_startNewGame);
    } else {
      AdController.instance.checkShowAd(_goToTitleScreen);
    }
  }
}