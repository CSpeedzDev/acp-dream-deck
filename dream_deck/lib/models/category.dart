import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class DreamCategoryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String emoji;

  @HiveField(3)
  int colorValue; // Store color as int

  @HiveField(4)
  bool isDefault; // True for predefined categories

  DreamCategoryModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.colorValue,
    this.isDefault = false,
  });

  Color get color => Color(colorValue);

  // Predefined categories
  static DreamCategoryModel quickWin = DreamCategoryModel(
    id: 'quick_win',
    title: 'Quick Win',
    emoji: '⚡',
    colorValue: 0xFFFF9800, // Orange
    isDefault: true,
  );

  static DreamCategoryModel bigDream = DreamCategoryModel(
    id: 'big_dream',
    title: 'Big Dream',
    emoji: '🌟',
    colorValue: 0xFFAB47BC, // Purple
    isDefault: true,
  );

  static DreamCategoryModel chill = DreamCategoryModel(
    id: 'chill',
    title: 'Chill',
    emoji: '🌊',
    colorValue: 0xFF42A5F5, // Blue
    isDefault: true,
  );

  static DreamCategoryModel outdoor = DreamCategoryModel(
    id: 'outdoor',
    title: 'Outdoor',
    emoji: '🏕️',
    colorValue: 0xFF66BB6A, // Green
    isDefault: true,
  );

  static DreamCategoryModel learning = DreamCategoryModel(
    id: 'learning',
    title: 'Learning',
    emoji: '📚',
    colorValue: 0xFFEC407A, // Pink
    isDefault: true,
  );

  static List<DreamCategoryModel> get defaultCategories => [
        quickWin,
        bigDream,
        chill,
        outdoor,
        learning,
      ];

  // Generate a random color
  static Color generateRandomColor() {
    final colors = [
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }
}
