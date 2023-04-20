import 'package:flutter_test/flutter_test.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/validator.dart';

void main() {
  test('', () => shouldWin());
  test('', () => shouldNotWin());
  test('', () => shouldNotWin2());
  test('', () => shouldHaveTwoSets());
  test('', () => shouldHaveOneSet());
}

void shouldWin() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.spades),
    GameCard.get('5', GameCard.diamonds),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('8', GameCard.spades),
  ];

  hand.shuffle();
  expect(validateHand(hand), true);
}

void shouldNotWin() {
  List<GameCard> hand = [
    GameCard.get('1', GameCard.hearts),
    GameCard.get('1', GameCard.spades),
    GameCard.get('1', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('5', GameCard.spades),
    GameCard.get('5', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('8', GameCard.spades),
  ];

  hand.shuffle();
  expect(validateHand(hand), false);
}

void shouldNotWin2() {
  List<GameCard> hand = [
    GameCard.get('10', GameCard.clubs),
    GameCard.get('10', GameCard.diamonds),
    GameCard.get('10', GameCard.spades),
    GameCard.get('11', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('12', GameCard.hearts),
    GameCard.get('12', GameCard.clubs),
    GameCard.get('6', GameCard.diamonds),
  ];

  hand.shuffle();
  expect(validateHand(hand), false);
}

void shouldHaveTwoSets() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('6', GameCard.hearts),
    GameCard.get('7', GameCard.hearts),
    GameCard.get('8', GameCard.hearts),
    GameCard.get('5', GameCard.diamonds),
    GameCard.get('5', GameCard.clubs),
  ];

  hand.shuffle();
  expect(getBestSetCombination(hand).length, 6);
}

void shouldHaveOneSet() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('6', GameCard.hearts),
    GameCard.get('7', GameCard.hearts),
    GameCard.get('8', GameCard.hearts),
    GameCard.get('6', GameCard.diamonds),
    GameCard.get('6', GameCard.clubs),
  ];

  hand.shuffle();
  expect(getBestSetCombination(hand).length, 3);
}