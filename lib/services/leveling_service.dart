class LevelingService {
  LevelingService._();

  /// Calculates the maximum experience bound required to complete the specified level.
  static int getMaxExpForLevel(int level) {
    double exp = 100;
    for (int i = 1; i < level; i++) {
      exp *= 1.25;
    }
    return exp.toInt();
  }

  /// Calculates the total cumulative experience earned since level 1.
  static int getTotalExp(int level, int currentExp) {
    int total = currentExp;
    for (int l = 1; l < level; l++) {
      total += getMaxExpForLevel(l);
    }
    return total;
  }
}
