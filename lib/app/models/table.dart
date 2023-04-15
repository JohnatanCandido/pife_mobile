import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/exceptions.dart';
import 'package:pife_mobile/app/models/opponent.dart';

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

  void buy(BasePlayer player, bool fromTrash) {
    if (player.cards.length == 10) {
      throw AlreadyBoughtException();
    }
    late GameCard boughtCard;
    if (fromTrash) {
      if (trash.isNotEmpty) {
        boughtCard = trash.removeLast();
        player.trashCard = boughtCard;
      } else {
        throw NoCardInTrashException();
      }
    } else {
      _checkRefillPack();
      boughtCard = pack.removeLast();
    }
    if (player is Opponent) {
      (player).boughtCard = boughtCard;
    } else {
      player.add(boughtCard);
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
    if (player is Opponent) {
      (player).cardDiscarded = card;
    } else {
      player.trashCard = null;
      trash.add(card);
    }
  }

  void finishOpponentDiscard(Opponent opponent) {
    opponent.trashCard = null;
    trash.add(opponent.cardDiscarded!);
    opponent.cardDiscarded = null;
  }

  void _checkRefillPack() {
    if (pack.isEmpty) {
      GameCard lastOfTrash = trash.removeLast();
      pack = List.from(trash);
      trash.clear();
      trash.add(lastOfTrash);
    }
  }

  GameCard getTopOfPack() {
    if (pack.isEmpty) {
      _checkRefillPack();
    }
    return pack.first;
  }

  GameCard? topOfTrash() {
    if (trash.isNotEmpty) {
      return trash.last;
    }
    return null;
  }

  GameCard? getSecondToLastFromTrash() {
    if (trash.length > 1) {
      return trash[trash.length-2];
    }
    return null;
  }
}
