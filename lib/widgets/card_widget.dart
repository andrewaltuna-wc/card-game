import 'dart:ffi';

import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final double height;
  final String imgPath;
  final bool shouldFade;
  final VoidCallback function;
  final AnimationController animationController;

  const CardWidget(
      {Key? key,
      required this.height,
      required this.imgPath,
      required this.shouldFade,
      required this.function,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          child: Image.asset(imgPath),
        ),
        AnimatedOpacity(
          opacity: shouldFade ? 0 : 1,
          duration: shouldFade
              ? const Duration(milliseconds: 500)
              : const Duration(milliseconds: 0),
          child: SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/cards/card_back.png"),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: shouldFade
                            ? null
                            : () {
                                function();
                              },
                        child: Center(
                          child: Opacity(
                            opacity: shouldFade ? 0 : 1,
                            child: AnimatedBuilder(
                              animation: animationController!.view,
                              builder: (buildContext, child) {
                                return AnimatedOpacity(
                                    opacity: animationController!.value,
                                    duration: const Duration(milliseconds: 100),
                                    child: child);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
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
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
