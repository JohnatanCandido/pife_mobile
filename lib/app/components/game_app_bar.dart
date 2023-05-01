import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameAppBar extends StatefulWidget implements PreferredSizeWidget {
  const GameAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  State<GameAppBar> createState() => _GameAppBarState();
}

class _GameAppBarState extends State<GameAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _getTitle(),
      actions: _buildActions(context),
    );
  }

  Widget _getTitle() {
    if (ModalRoute.of(context)!.settings.name == '/play') {
      return Text(AppLocalizations.of(context)!.title);
    }
    if (ModalRoute.of(context)!.settings.name == '/options') {
      return Text(AppLocalizations.of(context)!.options);
    }
    return const Text("");
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> widgets = [];
    if (ModalRoute.of(context)!.settings.name == '/play') {
      widgets.add(_newGameButton(context));
      widgets.add(_optionsButton(context));
    }
    return widgets;
  }

  TextButton _optionsButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/options'),
      child: Text(AppLocalizations.of(context)!.options)
    );
  }

  TextButton _newGameButton(BuildContext context) {
    return TextButton(
      onPressed: GameController.instance.newGame,
      child: Text(AppLocalizations.of(context)!.newGame)
    );
  }
}