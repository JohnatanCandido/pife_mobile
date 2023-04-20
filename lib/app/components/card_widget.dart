import 'package:flutter/material.dart';
import 'package:pife_mobile/app/models/card.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(this.x, this.y, this.angle, this.card, {super.key, this.isBeingCarried=false, this.showCard=true, this.cardScale=1.5});

  static const double imgWidth = 71;
  static const double imgHeight = 96;

  final double x;
  final double y;
  final double angle;
  final GameCard card;
  final bool isBeingCarried;
  final double cardScale;
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: cardScale,
      child: Transform.rotate(
        angle: angle,
        child: getImage(),
      ),
    );
  }

  Widget getScaledImage() {
    return Transform.scale(
      scale: cardScale,
      child: getImage(),
    );
  }

  Widget getImage() {
    if (isBeingCarried) {
      return Container();
    }
    String imgPath = showCard ? card.imgPath : 'assets/img_cartas/fundo_carta.png';
    return Image(image: AssetImage(imgPath));
  }

  double getWidth() {
    return imgWidth * cardScale;
  }

  double getHeight() {
    return imgHeight * cardScale;
  }
}