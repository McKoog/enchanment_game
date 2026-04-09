import 'package:enchantment_game/models/skills/skill_type.dart';

class Skill {
  final SkillType type;
  final String name;
  final int unlockLevel;
  final int baseCost;
  final int currentLevel;

  const Skill({
    required this.type,
    required this.name,
    required this.unlockLevel,
    required this.baseCost,
    this.currentLevel = 0,
  });

  int get upgradeCost {
    int cost = baseCost;
    for (int i = 0; i < currentLevel; i++) {
      cost *= 2;
    }
    return cost;
  }

  Skill copyWith({
    int? currentLevel,
  }) {
    return Skill(
      type: type,
      name: name,
      unlockLevel: unlockLevel,
      baseCost: baseCost,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'currentLevel': currentLevel,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    // Note: other fields (name, unlockLevel, baseCost) should be fetched from registry
    // Here we just restore what we need, or better we just store `Map<String, int>` in Character for skills
    throw UnimplementedError("Skills should be stored as Map<String, int> in Character");
  }
}
