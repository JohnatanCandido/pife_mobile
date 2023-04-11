import 'package:pife_mobile/app/models/card.dart';
import 'package:trotter/trotter.dart';

bool validateHand(List<GameCard> hand) {
  List<List<GameCard>> validSets = getValidSets(hand);
  if (validSets.length < 3) {
    return false;
  }
  Combinations<List<GameCard>> winningSets = Combinations(3, validSets);
  for (List<List<GameCard>> winningSetList in winningSets()) {
    Set<GameCard> winningSet = winningSetList.expand((i) => i).toSet();
    if (winningSet.length == 9) {
      return true;
    }
  }
  return false;
}

Set<GameCard> getBestSetCombination(List<GameCard> hand) {
  List<List<GameCard>> validSets = getValidSets(hand);
  Set<GameCard> bestSetCombination = {};
  if (validSets.length > 2) {
    bestSetCombination = getBestSetCombinationDynamicSize(validSets, bestSetCombination, 3);
  }
  if (validSets.length > 1) {
    bestSetCombination = getBestSetCombinationDynamicSize(validSets, bestSetCombination, 2);
  } else if (validSets.isNotEmpty) {
    bestSetCombination = validSets[0].toSet();
  }

  return bestSetCombination;
}

Set<GameCard> getBestSetCombinationDynamicSize(List<List<GameCard>> validSets, Set<GameCard> bestSetCombination, int setQuantity) {
  Combinations<List<GameCard>> setCombinations = Combinations(setQuantity, validSets);

  for (List<List<GameCard>> setCombination in setCombinations()) {
    Set<GameCard> combinatedSet = setCombination.expand((set) => set).toSet();
    if (combinatedSet.length % 3 == 0 &&
        combinatedSet.length > bestSetCombination.length) {
      bestSetCombination = combinatedSet;
    }
  }

  return bestSetCombination;
}

Set<GameCard> getBestPairCombination(List<GameCard> hand, Set<GameCard> bestSetCombination) {
  List<List<GameCard>> validPairs = getValidPairs(hand);
  validPairs.removeWhere((pair) => bestSetCombination.intersection(pair.toSet()).isNotEmpty);
  return validPairs.expand((pair) => pair).toSet();
}

List<List<GameCard>> getValidSets(List<GameCard> hand) {
  Combinations<GameCard> sets = Combinations(3, hand);
  List<List<GameCard>> validSets = sets().toList();
  validSets.retainWhere((set) => isValidSet(set));

  return validSets;
}


bool isValidSet(List<GameCard> cards) {
  cards.sort((a, b) => a.cardId.compareTo(b.cardId));
  GameCard c1 = cards[0];
  GameCard c2 = cards[1];
  GameCard c3 = cards[2];

  return isSequence(c1, c2, c3) || isTriplet(c1, c2, c3);
}

bool isSequence(GameCard c1, GameCard c2, GameCard c3) {
  if (c1.suit == c2.suit && (c1.suit == c3.suit || c3.value == 'joker')) {
    if (((c1.cardId + 1) == c2.cardId || (c1.cardId + 2) == c2.cardId)
     && ((c1.cardId + 2) == c3.cardId || c3.value == 'joker')) {
        return true;
    }
    if ((c1.value == '1' && (c2.value == '12' || c2.value == '13'))
     && (c3.value == '13' || c3.value == 'joker')) {
        return true;
    }
  }
  return false;
}

bool isTriplet(GameCard c1, GameCard c2, GameCard c3) {
  if ({c1.value, c2.value, c3.value}.length == 1) {
    if ({c1.suit, c2.suit, c3.suit}.length == 3) {
      return true;
    }
  }
  if (c1.value == c2.value && c3.value == 'joker') {
    if (c1.suit != c2.suit) {
      return true;
    }
  }
  return false;
}

List<List<GameCard>> getValidPairs(List<GameCard> hand) {
  Combinations<GameCard> pairs = Combinations(2, hand);
  List<List<GameCard>> validPairs = pairs().toList();
  validPairs.retainWhere((pair) => isValidPair(pair));

  return validPairs;
}

bool isValidPair(List<GameCard> cards) {
  return isPairTriplet(cards) || isPairSequence(cards);
}

bool isPairTriplet(List<GameCard> cards) {
  return cards[0].value == cards[1].value && cards[0].suit != cards[1].suit;
}

bool isPairSequence(List<GameCard> cards) {
  cards.sort((a, b) => a.cardId.compareTo(b.cardId));
  return (cards[0].suit == cards[1].suit 
          && ((cards[0].cardId + 1) == cards[1].cardId || (cards[0].cardId + 2) == cards[1].cardId));
}