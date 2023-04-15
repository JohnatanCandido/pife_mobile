import 'dart:math';

import 'package:pife_mobile/app/models/base_player.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/validator.dart';

class Opponent extends BasePlayer {

  GameCard? boughtCard;
  GameCard? cardDiscarded;
  bool playing = false;
  Set<GameCard> cardsInSets = {};
  Set<GameCard> cardsInPairs = {};

  Opponent(super.showHand);

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
    unusedCards.sort((a, b) => a.cardId.compareTo(b.cardId));
    cards = usedCards + unusedCards;
   }
}