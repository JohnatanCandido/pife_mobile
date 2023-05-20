import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/opponent_quantity_menu.dart';
import 'package:pife_mobile/app/controllers/statistics_controller.dart';
import 'package:provider/provider.dart';

import '../components/game_app_bar.dart';
import '../controllers/ad_controller.dart';
import '../controllers/card_animation_controller.dart';
import '../controllers/opponent_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/ad_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    StatisticsController.instance.addListener(_setStateMethod);
  }

  void _setStateMethod() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    AdController.instance.initialize(adState);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    StatisticsController.instance.removeListener(_setStateMethod);
    super.dispose();
  }

  void setNumberOfOpponents(int? numberOfOpponents) {
    setState(() {
      if (numberOfOpponents != null) {
        OpponentController.instance.numberOfOpponents = numberOfOpponents;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CardAnimationController.screenWidth = MediaQuery.of(context).size.width;
    CardAnimationController.screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const GameAppBar(),
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
                onPressed: _checkShowAd,
                child: Text(AppLocalizations.of(context)!.play)
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/options'),
                child: Text(AppLocalizations.of(context)!.options),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/how-to-play'),
                child: Text(AppLocalizations.of(context)!.howToPlay),
              ),
              ElevatedButton(
                onPressed: StatisticsController.instance.statisticsLoaded ? () => Navigator.of(context).pushNamed('/statistics') : null,
                child: Text(AppLocalizations.of(context)!.statistics),
              ),
            ],
          ),
        ),
      );
  }

  void _checkShowAd() {
    AdController.instance.checkShowAd(_startNewGame);
  }

  void _startNewGame() {
    Navigator.of(context).pushNamed('/play');
  }
}
