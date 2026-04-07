import 'dart:math';

/// Centralised random number generator for the game.
/// Avoids creating new [Random] instances on each call.
class GameRandom {
  GameRandom._();
  static final Random _instance = Random();

  /// Random integer in range [0, max).
  static int nextInt(int max) => _instance.nextInt(max);

  /// Roll a d100: returns `true` if the roll is within [chance] (0.0–100.0).
  static bool chance(double chance) {
    return _instance.nextDouble() * 100 <= chance;
  }
}
