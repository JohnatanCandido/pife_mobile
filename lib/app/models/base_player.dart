import 'package:pife_mobile/app/models/card.dart';

class BasePlayer {

  BasePlayer(this.showHand);

  List<GameCard> cards = [];
  bool showHand;
  GameCard? trashCard;

  void add(GameCard card) {
    cards.add(card);
  }

  void remove(GameCard card) {
    cards.remove(card);
  }
}