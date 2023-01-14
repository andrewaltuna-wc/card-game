import 'package:flutter/material.dart';
import 'package:cardgame/models/card_model.dart';

class CardHistoryWidget extends StatelessWidget {
  const CardHistoryWidget({
    Key? key,
    required this.shouldFadeHistory,
    required this.lastFiveCards,
    required this.fadeInOutAnimationController,
    required this.containerHeight,
    required this.sizedBoxWidth,
  }) : super(key: key);

  final bool shouldFadeHistory;
  final List<DeckCard> lastFiveCards;
  final AnimationController fadeInOutAnimationController;
  final double containerHeight;
  final double sizedBoxWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.indigo,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            const Text(
              "CARD HISTORY:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: containerHeight,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.4),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black),
                      BoxShadow(
                          color: Colors.indigo, spreadRadius: 0, blurRadius: 10)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: shouldFadeHistory ? 0 : 1,
                      child: Row(
                        children: [
                          SizedBox(width: sizedBoxWidth),
                          for (DeckCard card in lastFiveCards) ...[
                            Image.asset(card.imgPath()),
                            SizedBox(width: sizedBoxWidth)
                          ]
                        ],
                      ),
                    ), // Initial spacing
                    if (lastFiveCards.isNotEmpty)
                      AnimatedBuilder(
                        animation: fadeInOutAnimationController.view,
                        builder: (buildContext, child) {
                          return AnimatedOpacity(
                              opacity: fadeInOutAnimationController.value,
                              duration: const Duration(milliseconds: 100),
                              child: child);
                        },
                        child: const Icon(
                          Icons.arrow_left,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
