import 'dart:math';

import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent_display_properties.dart';
import 'package:pife_mobile/app/models/validator.dart';

class Opponent extends BasePlayer {

  Opponent(super.showHand, this.properties);

  static const _idle = 'idle';
  static const _buying = 'buying';
  static const _bought = 'bought';
  static const _discarding = 'discarding';
  static const _discarded = 'discarded';

  bool get buying => state == _buying;
  bool get shoudBuy => buying && boughtCard == null;
  bool get bought => state == _bought;
  bool get discarding => state == _discarding;
  bool get shouldDiscard => discarding && cardDiscarded == null;
  bool get discarded => state == _discarded;

  GameCard? boughtCard;
  GameCard? cardDiscarded;
  String state = _idle;
  Set<GameCard> cardsInSets = {};
  Set<GameCard> cardsInPairs = {};
  OpponentProperties properties;

  bool checkBuyFromTrash(GameCard trash) {
    List<GameCard> hypotheticalHand = cards + [trash];
    Set<GameCard> setsWithTrash = getBestSetCombination(hypotheticalHand);
    Set<GameCard> pairsWithTrash = getBestPairCombination(hypotheticalHand, setsWithTrash);

    if (setsWithTrash.length > cardsInSets.length) {
      return true;
    }

    if (pairsWithTrash.length > cardsInPairs.length) {
      Set<GameCard> usedCards = {...setsWithTrash, ...pairsWithTrash};
      hypotheticalHand.removeWhere((card) => usedCards.contains(card));
      return hypotheticalHand.isNotEmpty;
    }
    return false;
   }

  GameCard chooseCardToDiscard() {
    Set<GameCard> usedCards = {...cardsInSets, ...cardsInPairs};
    List<GameCard> validCards = List.from(cards);
    validCards.removeWhere((card) => usedCards.contains(card) || card == trashCard);
    if (validCards.isEmpty) {
       GameCard? discard;
       int bestPairs = 0;
       for (int i = 0; i < cardsInPairs.length; i++) {
        List<GameCard> copiedPairs = List.from(cardsInPairs);
        GameCard target = copiedPairs.removeAt(i);
        Set<GameCard> pairCombination = getBestPairCombination(copiedPairs, cardsInSets);
        if (pairCombination.length > bestPairs) {
          bestPairs = pairCombination.length;
          discard = target;
        }
       }
       if (discard != null) {
        return discard;
       }
       validCards = List.from(cards);
       validCards.removeWhere((card) => cardsInSets.contains(card) || card == trashCard);
    }

    return validCards[Random().nextInt(validCards.length)];
   }

  void organizeCards() {
    cardsInSets = getBestSetCombination(cards);
    cardsInPairs = getBestPairCombination(cards, cardsInSets);
    List<GameCard> usedCards = [...cardsInSets, ...cardsInPairs];
    List<GameCard> unusedCards = List.from(cards);
    unusedCards.removeWhere((card) => usedCards.contains(card));
    unusedCards.sort();
    cards = usedCards + unusedCards;
  }

  double getProperty(String property) {
    return properties.getDouble(property);
  }

  bool isHorizontal() {
    return properties.horizontal;
  }

  void startBuy() {
    state = _buying;
  }

  void finishBuy() {
    state = _bought;
  }

  void startDiscard() {
    state = _discarding;
  }

  void finishDiscard() {
    state = _discarded;
  }

  void finish() {
    state = _idle;
  }
}