import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/game_app_bar.dart';
import 'package:pife_mobile/app/components/options_hand_display.dart';
import 'package:pife_mobile/app/controllers/options_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {

  @override
  void initState() {
    super.initState();
    OptionsController.instance.addListener(_setStateMethod);
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(AppLocalizations.of(context)!.cardSpacing),
                  Slider(
                    value: OptionsController.instance.cardSpacingTemp,
                    max: 30,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.cardSpacingTemp = value;
                      })
                  }),
                  Text(AppLocalizations.of(context)!.heigth),
                  Slider(
                    value: OptionsController.instance.distanceFromBottomTemp,
                    max: 170,
                    min: 25,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.distanceFromBottomTemp = value;
                      })
                  }),
                  Text(AppLocalizations.of(context)!.archHeigth),
                  Slider(
                    value: OptionsController.instance.handArchTemp,
                    max: 2,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.handArchTemp = value;
                      })
                  }),
                  Text(AppLocalizations.of(context)!.cardAngle),
                  Slider(
                    value: OptionsController.instance.cardAngleTemp,
                    max: 0.35,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.cardAngleTemp = value;
                      })
                    }
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.tenCards),
                      Checkbox(
                        value: OptionsController.instance.tenthCard,
                        onChanged: (value) => {
                          setState(() {
                            OptionsController.instance.toggleTenthCard();
                          })
                        }
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      OptionsController.instance.applyChanges();
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.apply)
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      setState(() {
                        OptionsController.instance.cancel();
                        Navigator.of(context).pop();
                      })
                    },
                    child: Text(AppLocalizations.of(context)!.cancel)
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      setState(() {
                        OptionsController.instance.defaultValues();
                      })
                    },
                    child: Text(AppLocalizations.of(context)!.optionsDefaultValues)
                  ),
                ],
              ),
            ),
            OptionsHandDisplay()
          ],
        )
      ),
    );
  }
}