import 'package:flutter/material.dart';

class OptionsController {

  static OptionsController instance = OptionsController();

  bool tenthCard = true;

  double cardSpacing = 0.15;
  double cardHeigth = 0.1;
  double handArch = 0.02;
  double cardAngle = 0.15;

  double cardSpacingTemp = 0.15;
  double cardHeigthTemp = 0.1;
  double handArchTemp = 0.02;
  double cardAngleTemp = 0.15;

  void applyChanges() {
    cardSpacing = cardSpacingTemp;
    cardHeigth = cardHeigthTemp;
    handArch = handArchTemp;
    cardAngle = cardAngleTemp;
  }

  void cancel() {
    cardSpacingTemp = cardSpacing;
    cardHeigthTemp = cardHeigth;
    handArchTemp = handArch;
    cardAngleTemp = cardAngle;
  }

  void setTenthCard(bool value) {
    tenthCard = value;
  }
}