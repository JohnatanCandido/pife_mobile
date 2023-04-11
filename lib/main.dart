import 'package:flutter/material.dart';
import 'package:pife_mobile/app/views/game_page.dart';
import 'package:pife_mobile/app/views/options_page.dart';

import 'app/views/home_page.dart';

main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pife Mobile',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/':(context) => HomePage(),
        '/play':(context) => GamePage(),
        '/options': (context) => OptionsPage()
      },
    );
  }
}