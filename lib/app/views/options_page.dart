import 'package:flutter/material.dart';
import 'package:pife_mobile/app/components/game_app_bar.dart';
import 'package:pife_mobile/app/components/options_hand_display.dart';
import 'package:pife_mobile/app/controllers/game_controller.dart';
import 'package:pife_mobile/app/controllers/options_controller.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
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
              padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Card Spacing:'),
                  Slider(
                    value: OptionsController.instance.cardSpacingTemp,
                    max: 0.20,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.cardSpacingTemp = value;
                      })
                  }),
                  const Text('Heigth:'),
                  Slider(
                    value: OptionsController.instance.cardHeigthTemp,
                    max: 0.5,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.cardHeigthTemp = value;
                      })
                  }),
                  const Text('Hand Arch:'),
                  Slider(
                    value: OptionsController.instance.handArchTemp,
                    max: 0.15,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.handArchTemp = value;
                      })
                  }),
                  const Text('Card Angle:'),
                  Slider(
                    value: OptionsController.instance.cardAngleTemp,
                    max: 0.35,
                    onChanged: (value) => {
                      setState(() {
                        OptionsController.instance.cardAngleTemp = value;
                      })
                  }),
                  Row(
                    children: [
                      const Text('10 Cards'),
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
                    onPressed: () => {
                      GameController.instance.updateGamePage(() {
                        OptionsController.instance.applyChanges();
                        Navigator.of(context).pop();
                      })
                    },
                    child: const Text('Apply')
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      setState(() {
                        OptionsController.instance.cancel();
                        Navigator.of(context).pop();
                      })
                    },
                    child: const Text('Cancel')
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: OptionsHandDisplay()
            )
          ],
        )
      ),
    );
  }
}