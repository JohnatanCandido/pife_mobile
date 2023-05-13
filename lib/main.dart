import 'package:flutter/material.dart';
import 'package:pife_mobile/app/views/game_page.dart';
import 'package:pife_mobile/app/views/how_to_play.dart';
import 'package:pife_mobile/app/views/options_page.dart';
import 'package:pife_mobile/app/views/statistics.dart';

import 'app/views/home_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pife Mobile',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/play': (context) => GamePage(),
        '/options': (context) => OptionsPage(),
        '/how-to-play': (context) => const HowToPlay(),
        '/statistics': (context) => const Statistics(),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt')
      ],
    );
  }
}