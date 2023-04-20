import 'package:pife_mobile/app/models/card.dart';
import 'package:trotter/trotter.dart';

bool validateHand(List<GameCard> hand) {
  List<List<GameCard>> validSets = _getValidSets(hand);
  if (validSets.length < 3) {
    return false;
  }
  Combinations<List<GameCard>> winningSets = Combinations(3, validSets);
  for (List<List<GameCard>> winningSetList in winningSets()) {
    Set<GameCard> winningSet = winningSetList.expand((i) => i).toSet();
    if (winningSet.length == 9 && _isSetOfSetsValid(winningSet.toList())) {
      return true;
    }
  }
  return false;
}

Set<GameCard> getBestSetCombination(List<GameCard> hand) {
  List<List<GameCard>> validSets = _getValidSets(hand);
  Set<GameCard> bestSetCombination = {};
  if (validSets.length > 2) {
    bestSetCombination = _getBestSetCombinationDynamicSize(validSets, bestSetCombination, 3);
  }
  if (validSets.length > 1) {
    bestSetCombination = _getBestSetCombinationDynamicSize(validSets, bestSetCombination, 2);
  }
  if (bestSetCombination.isEmpty && validSets.isNotEmpty) {
    bestSetCombination = validSets[0].toSet();
  }

  return bestSetCombination;
}

Set<GameCard> _getBestSetCombinationDynamicSize(List<List<GameCard>> validSets, Set<GameCard> bestSetCombination, int setQuantity) {
  Combinations<List<GameCard>> setCombinations = Combinations(setQuantity, validSets);

  for (List<List<GameCard>> setCombination in setCombinations()) {
    Set<GameCard> combinatedSet = setCombination.expand((set) => set).toSet();
    if (_isSetOfSetsValid(combinatedSet.toList()) && combinatedSet.length > bestSetCombination.length) {
      bestSetCombination = combinatedSet;
    }
  }

  return bestSetCombination;
}

bool _isSetOfSetsValid(List<GameCard> cards) {
  if (cards.length % 3 != 0) {
    return false;
  }

  int validSets = 0;
  for (int i = 0; i < cards.length; i += 3) {
    if (_isValidSet(cards.sublist(i, i+3))) {
      validSets++;
    }
  }

  return cards.length / 3 == validSets;
}

Set<GameCard> getBestPairCombination(List<GameCard> hand, Set<GameCard> bestSetCombination) {
  List<List<GameCard>> validPairs = _getValidPairs(hand);
  validPairs.removeWhere((pair) => bestSetCombination.intersection(pair.toSet()).isNotEmpty);
  return validPairs.expand((pair) => pair).toSet();
}

List<List<GameCard>> _getValidSets(List<GameCard> hand) {
  Combinations<GameCard> sets = Combinations(3, hand);
  List<List<GameCard>> validSets = sets().toList();
  for (List<GameCard> set in validSets) {
    set.sort();
  }
  validSets.retainWhere((set) => _isValidSet(set));

  return validSets;
}

bool _isValidSet(List<GameCard> cards) {
  cards.sort();
  GameCard c1 = cards[0];
  GameCard c2 = cards[1];
  GameCard c3 = cards[2];

  return _isSequence(c1, c2, c3) || _isTriplet(c1, c2, c3);
}

bool _isSequence(GameCard c1, GameCard c2, GameCard c3) {
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

bool _isTriplet(GameCard c1, GameCard c2, GameCard c3) {
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

List<List<GameCard>> _getValidPairs(List<GameCard> hand) {
  Combinations<GameCard> pairs = Combinations(2, hand);
  List<List<GameCard>> validPairs = pairs().toList();
  validPairs.retainWhere((pair) => _isValidPair(pair));

  return validPairs;
}

bool _isValidPair(List<GameCard> cards) {
  return _isPairTriplet(cards) || _isPairSequence(cards);
}

bool _isPairTriplet(List<GameCard> cards) {
  return cards[0].value == cards[1].value && cards[0].suit != cards[1].suit;
}

bool _isPairSequence(List<GameCard> cards) {
  cards.sort();
  return (cards[0].suit == cards[1].suit 
          && ((cards[0].cardId + 1) == cards[1].cardId || (cards[0].cardId + 2) == cards[1].cardId));
}