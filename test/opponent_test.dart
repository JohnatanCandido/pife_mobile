import 'package:flutter_test/flutter_test.dart';
import 'package:pife_mobile/app/models/card.dart';
import 'package:pife_mobile/app/models/opponent.dart';
import 'package:pife_mobile/app/models/opponent_display_properties.dart';

void main() {
  test('', () => shouldBuyFromTrash());
  test('', () => shouldNotBuyFromTrash());
  test('', () => testDiscardLogic());
  test('', () => testCardOrganization());
}

void shouldBuyFromTrash() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.spades),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.clubs),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
  ];

  GameCard trash = GameCard.get('1', GameCard.diamonds);

  Opponent opponent = Opponent(false, OpponentProperties.top);
  opponent.cards = hand;

  expect(opponent.checkBuyFromTrash(trash), true);
}

void shouldNotBuyFromTrash() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.spades),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.clubs),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
  ];

  GameCard trash = GameCard.get('11', GameCard.clubs);

  Opponent opponent = Opponent(false, OpponentProperties.top);
  opponent.cards = hand;

  expect(opponent.checkBuyFromTrash(trash), false);
}

void testDiscardLogic() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('5', GameCard.spades),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('13', GameCard.clubs),
  ];

  List<GameCard> validCardsToDiscard = [hand.last];
  checkDiscardLogic(hand, validCardsToDiscard);
  
  hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('7', GameCard.spades),
    GameCard.get('13', GameCard.clubs),
  ];

  validCardsToDiscard = hand.sublist(8);
  checkDiscardLogic(hand, validCardsToDiscard);

  hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('10', GameCard.diamonds),
    GameCard.get('7', GameCard.spades),
    GameCard.get('13', GameCard.clubs),
  ];

  validCardsToDiscard = hand.sublist(7);
  checkDiscardLogic(hand, validCardsToDiscard);

  hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('8', GameCard.hearts),
    GameCard.get('10', GameCard.diamonds),
    GameCard.get('7', GameCard.spades),
    GameCard.get('13', GameCard.clubs),
  ];

  validCardsToDiscard = hand.sublist(6);
  checkDiscardLogic(hand, validCardsToDiscard);
}

void checkDiscardLogic(List<GameCard> hand, List<GameCard> validCardsToDiscard) {
  hand.shuffle();
  Opponent opponent = Opponent(false, OpponentProperties.top);
  opponent.cards = hand;
  opponent.organizeCards();
  GameCard chosenDiscard = opponent.chooseCardToDiscard();
  expect(validCardsToDiscard.contains(chosenDiscard), true);
}

void testCardOrganization() {
  List<GameCard> hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('5', GameCard.spades),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
  ];

  checkCardOrganization(hand, 9, 0);

  hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('10', GameCard.spades),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
    GameCard.get('1', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
  ];

  checkCardOrganization(hand, 6, 2);

  hand = [
    GameCard.get('5', GameCard.hearts),
    GameCard.get('5', GameCard.clubs),
    GameCard.get('10', GameCard.spades),
    GameCard.get('10', GameCard.diamonds),
    GameCard.get('12', GameCard.diamonds),
    GameCard.get('13', GameCard.diamonds),
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.hearts),
    GameCard.get('3', GameCard.hearts),
  ];

  checkCardOrganization(hand, 3, 6);

  hand = [
    GameCard.get('1', GameCard.hearts),
    GameCard.get('2', GameCard.clubs),
    GameCard.get('3', GameCard.diamonds),
    GameCard.get('4', GameCard.spades),
    GameCard.get('5', GameCard.hearts),
    GameCard.get('6', GameCard.clubs),
    GameCard.get('7', GameCard.diamonds),
    GameCard.get('8', GameCard.spades),
    GameCard.get('9', GameCard.hearts),
  ];

  checkCardOrganization(hand, 0, 0);
}

void checkCardOrganization(List<GameCard> hand, int cardsInSets, int cardsInPairs) {
  hand.shuffle();

  Opponent opponent = Opponent(false, OpponentProperties.top);
  opponent.cards = hand;
  opponent.organizeCards();
  expect(opponent.cardsInSets.length, cardsInSets);
  expect(opponent.cardsInPairs.length, cardsInPairs);
}