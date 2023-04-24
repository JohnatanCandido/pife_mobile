import '../controllers/card_animation_controller.dart';

class OpponentProperties {

  const OpponentProperties({required this.leftMargin, required this.topMargin, this.horizontal=true, this.dir=-1, this.angleBias=0, this.cardOrientation=1, this.tilt=0});

  static final top = OpponentProperties(
    leftMargin: CardAnimationController.screenWidth * 0.4,
    topMargin: CardAnimationController.screenHeight * 0.01155,
  );
  static final topLeft = OpponentProperties(
    leftMargin: CardAnimationController.screenWidth * 0.15,
    topMargin: CardAnimationController.screenHeight * 0.0576,
  );
  static final topRight = OpponentProperties(
    leftMargin: CardAnimationController.screenWidth * 0.65,
    topMargin: CardAnimationController.screenHeight * 0.0576,
  );
  static final bottomLeft = OpponentProperties(
    leftMargin: CardAnimationController.screenHeight * 0.25,
    topMargin: CardAnimationController.screenWidth * 0.05,
    angleBias: 1.5,
    horizontal: false,
    dir: 1
  );
  static final bottomRight = OpponentProperties(
    leftMargin: CardAnimationController.screenHeight * 0.25,
    topMargin: CardAnimationController.screenWidth * 0.8,
    angleBias: 1.5,
    cardOrientation: -1,
    horizontal: false
  );

  final double leftMargin;
  final double topMargin;
  final double dir;
  final double angleBias;
  final double cardOrientation;
  final double tilt;
  final bool horizontal;

}