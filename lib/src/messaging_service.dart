import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagingService {
  static void showSnackBarMessage(
      final BuildContext context, final String content) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(content),
          duration:
              Duration(milliseconds: _getDynamicDuration(content.length))));
  }

  /// Approximation of human reading speed to calucate required SnackBar duration
  static int _getDynamicDuration(int characterCount) {
    const double averageWordLength = 6.47;
    const int humanAverageWordsPerMinute = 200;
    const double humanAverageCharactersPerSecond =
        humanAverageWordsPerMinute * averageWordLength / 60;
    int minDurationMilliseconds = 2000;
    int requiredMilliseconds =
        (characterCount / humanAverageCharactersPerSecond).round() * 1000;

    return (requiredMilliseconds <= minDurationMilliseconds) ? minDurationMilliseconds : requiredMilliseconds;
  }
}
