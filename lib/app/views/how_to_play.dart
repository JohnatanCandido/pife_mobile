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
        child: ListView(
          children: [
            Text(AppLocalizations.of(context)!.howToPlayTitle1, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            const SizedBox(height: 25,),
            Text(AppLocalizations.of(context)!.howToPlay1, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 50,),
            Text(AppLocalizations.of(context)!.howToPlayTitle2, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25,),
            Text(AppLocalizations.of(context)!.howToPlay2, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 50,),
            Text(AppLocalizations.of(context)!.howToPlayTitle3, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25,),
            Text(AppLocalizations.of(context)!.howToPlay3, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 50,),
            Text(AppLocalizations.of(context)!.howToPlayEnd, style: const TextStyle(fontSize: 18),),
          ],
        ),
      ),
    );
  }
}