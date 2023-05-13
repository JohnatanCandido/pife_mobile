import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/game_app_bar.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: const GameAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.howToPlay1, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 50,),
            Text(AppLocalizations.of(context)!.howToPlay2, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 18),),
          ],
        ),
      ),
    );
  }
}