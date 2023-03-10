import 'dart:math';

import 'package:cardgame/logic/card_game.dart';
import 'package:cardgame/widgets/card_history_widget.dart';
import 'package:cardgame/widgets/card_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late double _deviceHeight, _deviceWidth;
  late bool _isPortrait;
  late AnimationController _fadeInOutAnimationController;

  final CardGame _cardGame = CardGame();
  final int _flipDuration = 500;
  bool _disableButtons = true;
  bool _shouldFadeHeart = false;
  bool _shouldFadeHistory = false;
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    // Initializes card game
    _cardGame.newGame();
    _fadeInOutAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.3,
      upperBound: 1,
    );
    _fadeInOutAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    _fadeInOutAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: _isPortrait && !kIsWeb
          ? AppBar(
              title: const Text("Card Game"),
              actions: [
                IconButton(
                  onPressed: () => _gameResetDialog(),
                  icon: const Icon(Icons.refresh),
                )
              ],
            )
          // Remove AppBar if not in portrait and/or is in webview
          : null,
      body: SafeArea(
        child: Center(
          child: Container(
            color: const Color.fromRGBO(27, 38, 59, 1.0),
            constraints: const BoxConstraints(maxWidth: 800),
            height: _deviceHeight,
            width: _deviceWidth,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: _isPortrait || (kIsWeb && _deviceHeight > 520)
                // Portrait/Web
                ? _portraitLayout()
                // Landscape
                : _landscapeLayout(),
          ),
        ),
      ),
    );
  }

  // WIDGETS
  Widget _portraitLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _scoreWidget(),
        _livesWidget(heartSize: 30),
        _cardWidget(height: _deviceHeight * 0.3),
        _gameButtonsWidget(sizedBoxHeight: 5),
        _cardHistoryWidget(
            containerHeight: _deviceHeight * 0.12, sizedBoxWidth: 5),
      ],
    );
  }

  Widget _landscapeLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: _cardHistoryWidget(containerHeight: 90, sizedBoxWidth: 5),
        ),
        _cardWidget(height: _deviceHeight * 0.6),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _scoreWidget(),
            _livesWidget(heartSize: 30),
            _gameButtonsWidget(sizedBoxHeight: 5),
          ],
        )
      ],
    );
  }

  Widget _cardHistoryWidget(
      {required double containerHeight, required double sizedBoxWidth}) {
    return CardHistoryWidget(
      shouldFadeHistory: _shouldFadeHistory,
      lastFiveCards: _cardGame.lastFiveCards,
      fadeInOutAnimationController: _fadeInOutAnimationController,
      containerHeight: containerHeight,
      sizedBoxWidth: sizedBoxWidth,
    );
  }

  Widget _cardWidget({required double height}) {
    return CardWidget(
      height: height,
      imgPath: _cardGame.currentCard().imgPath(),
      angle: _angle,
      flipDuration: _flipDuration,
      function: () {
        setState(() {
          _flipCard();
          _disableButtons = false;
        });
      },
      animationController: _fadeInOutAnimationController,
    );
  }

  Widget _scoreWidget() {
    return Card(
      color: const Color.fromRGBO(65, 90, 119, 1.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          "Score: ${_cardGame.score.toString()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _livesWidget({required double heartSize}) {
    return AnimatedOpacity(
      opacity: _shouldFadeHeart ? 0 : 1,
      duration: const Duration(milliseconds: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Red hearts
          for (var i = _cardGame.lives; i > 0; i--) ...[
            Text(
              "???",
              style: TextStyle(fontSize: heartSize),
            ),
          ],
          // Empty hearts
          for (var i = 3 - _cardGame.lives; i > 0; i--) ...[
            Text(
              "????",
              style: TextStyle(fontSize: heartSize),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buttonWidget({required String text, required bool cond}) {
    return ElevatedButton(
      onPressed: _disableButtons || _cardGame.isGameDone
          ? null
          : () {
              _nextCard();
              if (cond) {
                return _wrongAnswer();
              }
              _cardGame.score++;
            },
      child: Text(text),
    );
  }

  Widget _gameButtonsWidget({required double sizedBoxHeight}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Less-than button
        _buttonWidget(text: "LESS THAN", cond: !_cardGame.isLessThanCurrent()),
        SizedBox(
          height: sizedBoxHeight,
        ),
        const Text(
          "OR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: sizedBoxHeight),
        // Greater-than or equal to button
        _buttonWidget(
            text: "GREATER/EQUAL", cond: _cardGame.isLessThanCurrent()),
        if (kIsWeb || _isPortrait == false) ...[
          SizedBox(height: sizedBoxHeight * 4),
          ElevatedButton(
            onPressed: () => _gameResetDialog(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("RESET"),
          )
        ]
      ],
    );
  }

  Future _gameResetDialog({bool? isWin}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: isWin == null
            // Reset title
            ? const Text("Reset Game")
            // Game end title
            : Text(isWin ? "You Won!" : "Game Over!"),
        content: Text(isWin == null
            // Reset content
            ? "Are you sure you want to reset your game?"
            // Game end content
            : "You scored ${_cardGame.score} point/s! Would you like to start another game?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BACK"),
          ),
          TextButton(
            onPressed: () => _newGame(),
            child: const Text("CONFIRM"),
          ),
        ],
      ),
    );
  }

  void _newGame() {
    _cardGame.newGame();
    setState(() {
      _angle = 0;
      _disableButtons = true;
    });
    Navigator.pop(context);
  }

  void _nextCard() {
    setState(() {
      _flipCard();
      _disableButtons = true;
      _cardGame.updateHistory();
      _shouldFadeHistory = true;

      Future.delayed(Duration(milliseconds: _flipDuration ~/ 2), () {
        setState(() {
          _shouldFadeHistory = false;
          _cardGame.nextCard();
          if (_cardGame.isWin()) {
            _gameResetDialog(isWin: true);
          }
        });
      });
    });
  }

  void _flipCard() {
    _angle = (_angle + pi) % (2 * pi);
  }

  void _wrongAnswer() {
    setState(
      () {
        _cardGame.subtractLife();
        _shouldFadeHeart = true;

        // Heart animation
        Future.delayed(
          const Duration(milliseconds: 300),
          () => setState(() => _shouldFadeHeart = false),
        );

        if (_cardGame.isGameDone) {
          _gameResetDialog(isWin: false);
        }
      },
    );
  }
}
