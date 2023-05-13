import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pife_mobile/app/controllers/statistics_controller.dart';

import '../components/game_app_bar.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  @override
  void initState() {
    super.initState();
    StatisticsController.instance.addListener(_setStateMethod);
  }

  void _setStateMethod() {
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: const GameAppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              DataTable(
                showBottomBorder: true,
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text(AppLocalizations.of(context)!.opponents)),
                  DataColumn(label: Expanded(child: Text(AppLocalizations.of(context)!.gamesPlayed, textAlign: TextAlign.center))),
                  DataColumn(label: Expanded(child: Text(AppLocalizations.of(context)!.gamesWon, textAlign: TextAlign.center))),
                  DataColumn(label: Expanded(child: Text(AppLocalizations.of(context)!.gamesLost, textAlign: TextAlign.center))),
                ],
                rows: List<DataRow>.generate(
                  StatisticsController.instance.playerStatistics.length,
                  (index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return index.isOdd ? Color.fromRGBO(46, 125, 50, 1) : Color.fromRGBO(46, 135, 50, 1);
                      }
                    ),
                    cells: <DataCell>[
                      DataCell(
                        SizedBox(
                          width: constraints.maxWidth * .19,
                          child: Text(StatisticsController.instance.playerStatistics[index].numberOfOpponents, textAlign: TextAlign.center,))),
                      DataCell(
                        SizedBox(
                          width: constraints.maxWidth * .1,
                          child: Text(StatisticsController.instance.playerStatistics[index].gamesPlayed, textAlign: TextAlign.right))),
                      DataCell(
                        SizedBox(
                          width: constraints.maxWidth * .22,
                          child: Text(StatisticsController.instance.playerStatistics[index].won, textAlign: TextAlign.right)
                        )
                      ),
                      DataCell(
                        SizedBox(
                          width: constraints.maxWidth * .22,
                          child: Text(StatisticsController.instance.playerStatistics[index].lost, textAlign: TextAlign.right)
                        )
                      ),
                    ]
                  )
                )
              ),
              const SizedBox(height: 15,),
              ElevatedButton(
                onPressed: () => StatisticsController.instance.resetStatistics(),
                child: Text(AppLocalizations.of(context)!.resetStatistics)
              ),
            ],
          ),
        ),
      ),
    );
  }
}