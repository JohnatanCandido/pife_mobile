class GameCard {

  static const String hearts = 'copas';
  static const String clubs = 'paus';
  static const String diamonds = 'ouro';
  static const String spades = 'espadas';
  static const List<String> suits = [hearts, clubs, diamonds, spades];

  final int cardId;
  final String value;
  final String suit;
  final String imgPath;

  GameCard(this.cardId, this.value, this.suit, this.imgPath);

  static GameCard get(String value, String suit) {
    int suitIndex = suits.indexOf(suit);
    int cardId = int.parse(value) + (suitIndex * 13);
    return GameCard(cardId, value, suit, '');
  }

  @override
  String toString() {
    return '$value - $suit';
  }
}