import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pife_mobile/app/models/ad_state.dart';
import 'package:pife_mobile/app/views/game_page.dart';
import 'package:pife_mobile/app/views/how_to_play.dart';
import 'package:pife_mobile/app/views/options_page.dart';
import 'package:pife_mobile/app/views/statistics.dart';
import 'package:provider/provider.dart';

import 'app/views/home_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  await dotenv.load();
  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => const AppWidget()
    )
  );
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: dotenv.env['ENVIRONMENT'] != 'Production',
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