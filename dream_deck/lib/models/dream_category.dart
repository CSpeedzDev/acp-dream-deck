import 'package:flutter/material.dart';

enum DreamCategory {
  quickWin,
  bigDream,
  chill,
  outdoor,
  learning;

  String get displayName {
    switch (this) {
      case DreamCategory.quickWin:
        return 'Quick Win';
      case DreamCategory.bigDream:
        return 'Big Dream';
      case DreamCategory.chill:
        return 'Chill';
      case DreamCategory.outdoor:
        return 'Outdoor';
      case DreamCategory.learning:
        return 'Learning';
    }
  }

  String get emoji {
    switch (this) {
      case DreamCategory.quickWin:
        return '⚡';
      case DreamCategory.bigDream:
        return '✨';
      case DreamCategory.chill:
        return '🌸';
      case DreamCategory.outdoor:
        return '🌿';
      case DreamCategory.learning:
        return '📚';
    }
  }

  Color get color {
    switch (this) {
      case DreamCategory.quickWin:
        return const Color(0xFFFFA726); // Orange
      case DreamCategory.bigDream:
        return const Color(0xFFAB47BC); // Purple
      case DreamCategory.chill:
        return const Color(0xFFEC407A); // Pink
      case DreamCategory.outdoor:
        return const Color(0xFF26A69A); // Teal
      case DreamCategory.learning:
        return const Color(0xFF42A5F5); // Blue
    }
  }
}
