class DeckCard {
  int number;
  int suit;
  // bool isRevealed = false;

  DeckCard({
    required this.number,
    required this.suit,
  });

  String imgPath() {
    String card = "";
    switch (number) {
      case 1:
        card += "A";
        break;
      case 11:
        card += "J";
        break;
      case 12:
        card += "Q";
        break;
      case 13:
        card += "K";
        break;
      default:
        card += number.toString();
    }
    switch (suit) {
      case 1:
        card += "C";
        break;
      case 2:
        card += "D";
        break;
      case 3:
        card += "H";
        break;
      case 4:
        card += "S";
        break;
    }
    return "assets/cards/$card.png";
  }
}
