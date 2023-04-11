import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/player_quantity_menu.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void setNumberOfOpponents(int? numberOfOpponents) {
    setState(() {
      if (numberOfOpponents != null) {
        GameController.instance.numberOfOpponents = numberOfOpponents;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlayerQuantityMenu(
                selectedNumber: GameController.instance.numberOfOpponents,
                onChanged: setNumberOfOpponents,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/play');
                },
                child: const Text('Jogar')
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/options');
                },
                child: const Text('Options')
              ),
            ],
          ),
        ),
      );
  }
}
