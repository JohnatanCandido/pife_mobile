import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/opponent_quantity_menu.dart';

import '../controllers/card_animation_controller.dart';
import '../controllers/opponent_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void setNumberOfOpponents(int? numberOfOpponents) {
    setState(() {
      if (numberOfOpponents != null) {
        OpponentController.instance.numberOfOpponents = numberOfOpponents;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(AppLocalizations.of(context));
    CardAnimationController.screenWidth = MediaQuery.of(context).size.width;
    CardAnimationController.screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OpponentQuantityMenu(
                selectedNumber: OpponentController.instance.numberOfOpponents,
                onChanged: setNumberOfOpponents,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/play');
                },
                child: Text(AppLocalizations.of(context)!.play)
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/options');
                },
                child: Text(AppLocalizations.of(context)!.options)
              ),
            ],
          ),
        ),
      );
  }
}
