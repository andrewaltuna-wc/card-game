import 'dart:math';

import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final double height;
  final String imgPath;
  final VoidCallback function;
  final AnimationController animationController;
  final double angle;
  final int flipDuration;

  bool isBack = true;

  CardWidget({
    Key? key,
    required this.height,
    required this.imgPath,
    required this.angle,
    required this.flipDuration,
    required this.function,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TweenAnimationBuilder(
        key: ValueKey(context),
        tween: Tween<double>(begin: 0, end: angle),
        duration: Duration(milliseconds: flipDuration),
        builder: (buildContext, value, child) {
          if (value >= (pi / 2)) {
            isBack = false;
          } else {
            isBack = true;
          }
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            child: isBack
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/cards/card_back.png"),
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isBack ? () => function() : null,
                              child: _tapGuide(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: Image.asset(imgPath),
                  ),
          );
        },
      ),
    );
  }

  Widget _tapGuide() {
    return Center(
      child: Opacity(
        opacity: isBack ? 1 : 0,
        child: AnimatedBuilder(
          animation: animationController.view,
          builder: (buildContext, child) {
            return AnimatedOpacity(
                opacity: animationController.value,
                duration: const Duration(milliseconds: 100),
                child: child);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.8),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text(
              "TAP TO FLIP",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
