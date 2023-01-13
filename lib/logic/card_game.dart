import 'package:cardgame/models/card_model.dart';

class CardGame {
  int score = 0;
  List<DeckCard> cards = [];
  List<DeckCard> lastFiveCards = [];
  bool isGameDone = false;
  int lives = 3;

  void newGame() {
    // Reset gamestate
    score = 0;
    cards = [];
    lastFiveCards = [];
    isGameDone = false;
    lives = 3;
    // Generate cards
    for (var suit = 1; suit <= 4; suit++) {
      for (var number = 1; number <= 13; number++) {
        cards.add(DeckCard(number: number, suit: suit));
      }
    }
    // Randomize card order
    cards.shuffle();
  }

  DeckCard currentCard() {
    return cards[0];
  }

  bool isLessThanCurrent() {
    // Returns true if the current card is less than the previous
    return cards[1].number < cards[0].number ? true : false;
  }

  void nextCard() {
    // Ensures only the last 5 cards are stored
    if (lastFiveCards.length >= 5) {
      lastFiveCards.removeAt(0);
    }

    lastFiveCards.add(currentCard());
    cards.removeAt(0);

    // Game ends if there is only one card left
    if (cards.length == 1) {
      isGameDone = true;
    }
  }

  void subtractLife() {
    lives--;
    if (lives == 0) {
      isGameDone = true;
    }
  }

  bool isWin() {
    if (cards.length == 1) {
      return true;
    }
    return false;
  }
}
