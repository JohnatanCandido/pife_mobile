import 'package:flutter_test/flutter_test.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/validator.dart';

void main() {
  test('', () => shouldWin());
  test('', () => shouldNotWin());
}

void shouldWin() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.spades),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('8', GameCard.spades),
  ];

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

  expect(validateHand(hand), false);
}