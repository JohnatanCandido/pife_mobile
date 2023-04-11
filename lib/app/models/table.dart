import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/exceptions.dart';
import 'package:pife_mobile/app/models/opponent.dart';
import 'package:pife_mobile/app/models/validator.dart';

class GameTable {

  late List<GameCard> pack;
  late List<GameCard> trash;

  void newGame() {
    trash = [];
    pack = [];

    for (int i = 0; i < 4; i++) {
      for (int j = 1; j <= 13; j++) {
        String imgPath = 'assets/img_cartas/${j}_${GameCard.suits[i]}.png';
        pack.add(GameCard(j + (13 * i), j.toString(), GameCard.suits[i], imgPath));
      }
    }
    pack.shuffle();
  }

  void deal(List<BasePlayer> players) {
    for (int i = 0; i < 9; i++) {
      for (BasePlayer player in players) {
        player.cards.add(pack.removeLast());
      }
    }
  }

  bool play(Opponent player) {
    bool buyFromTrash = trash.isNotEmpty && player.checkBuyFromTrash(trash.last);
    buy(player, buyFromTrash);

    GameCard cardToDiscard = player.chooseCardToDiscard();
    discard(player, cardToDiscard);

    player.organizeCards();

    return validateHand(player.cards);
  }

  void buy(BasePlayer player, bool fromTrash) {
    if (player.cards.length == 10) {
      throw AlreadyBoughtException();
    }
    if (fromTrash) {
      if (trash.isNotEmpty) {
        GameCard trashCard = trash.removeLast();
        player.add(trashCard);
        player.trashCard = trashCard;
      } else {
        throw NoCardInTrashException();
      }
    } else {
      checkRefillPack();
      player.add(pack.removeLast());
    }
  }

  void discard(BasePlayer player, GameCard card) {
    if (player.cards.length < 10) {
      throw AlreadyDiscardedException();
    }
    if (player.trashCard == card) {
      throw InvalidDiscardException();
    }
    player.remove(card);
    player.trashCard = null;
    trash.add(card);
  }

  void checkRefillPack() {
    if (pack.isEmpty) {
      GameCard lastOfTrash = trash.removeLast();
      pack = List.from(trash);
      trash.clear();
      trash.add(lastOfTrash);
    }
  }

  GameCard getTopOfPack() {
    if (pack.isEmpty) {
        checkRefillPack();
    }
    return pack.first;
  }

  GameCard? getSecondToLastFromTrash() {
    if (trash.length > 1) {
      return trash[trash.length-2];
    }
    return null;
  }
}
