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
    if (player is Opponent) {
      _opponentBuy(player, fromTrash);
    } else {
      _playerBuy(player, fromTrash);
    }
  }

  void _playerBuy(BasePlayer player, bool fromTrash) {
    if (fromTrash) {
      if (trash.isNotEmpty) {
        GameCard boughtCard = trash.removeLast();
        player.trashCard = boughtCard;
        player.add(boughtCard);
      } else {
        throw NoCardInTrashException();
      }
    } else {
      player.add(pack.removeLast());
      _checkRefillPack();
    }
  }

  void _opponentBuy(Opponent opponent, bool fromTrash) {
    late GameCard boughtCard;
    if (fromTrash) {
      if (trash.isNotEmpty) {
        boughtCard = trash.last;
        opponent.trashCard = boughtCard;
      } else {
        throw NoCardInTrashException();
      }
    } else {
      boughtCard = pack.last;
    }
    opponent.boughtCard = boughtCard;
  }

  void discard(BasePlayer player, GameCard card) {
    if (player.cards.length < 10) {
      throw AlreadyDiscardedException();
    }
    if (player.trashCard == card) {
      throw InvalidDiscardException();
    }
    if (player is Opponent) {
      (player).cardDiscarded = card;
    } else {
      player.remove(card);
      player.trashCard = null;
      trash.add(card);
    }
  }

  void finishOpponentBuy(Opponent opponent) {
    opponent.add(opponent.boughtCard!);
    if (pack.last == opponent.boughtCard!) {
      pack.removeLast();
      _checkRefillPack();
    } else {
      trash.removeLast();
    }
    opponent.boughtCard = null;
  }

  void finishOpponentDiscard(Opponent opponent) {
    opponent.remove(opponent.cardDiscarded!);
    trash.add(opponent.cardDiscarded!);
    opponent.trashCard = null;
    opponent.cardDiscarded = null;
  }

  void _checkRefillPack() {
    if (pack.isEmpty) {
      pack = List.from(trash);
      trash.clear();
    }
  }

  GameCard getTopOfPack() {
    if (pack.isEmpty) {
      _checkRefillPack();
    }
    return pack.last;
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

  GameCard? getSecondToLastFromPack() {
    if (pack.length > 1) {
      return pack[pack.length-2];
    }
    return null;
  }
}
