import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pife_mobile/app/models/card.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(this.x, this.y, this.angle, this.card, {super.key, this.isBeingCarried=false, this.showCard=true, this.cardScale=1.5});

  final double x;
  final double y;
  final double angle;
  final GameCard card;
  final bool isBeingCarried;
  final double cardScale;
  final bool showCard;

  Transform getImage() {
    String imgPath = showCard ? card.imgPath : 'assets/img_cartas/fundo_carta.png';
    return Transform.scale(
      scale: cardScale,
      child: Image(image: AssetImage(imgPath))
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isBeingCarried) {
      return Container();
    }
    return Container(
      alignment: Alignment(x, y),
      child: Transform.rotate(
        angle: angle,
        child: getImage()
      )
    );
  }
}