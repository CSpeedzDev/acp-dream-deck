import 'package:hive/hive.dart';

part 'manifest_item.g.dart';

@HiveType(typeId: 2)
class ManifestItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String dreamId;

  @HiveField(2)
  String title;

  @HiveField(3)
  List<ChecklistItem> checklist;

  @HiveField(4)
  Map<String, double> goalValues;

  @HiveField(5)
  DateTime startedAt;

  @HiveField(6)
  DateTime? completedAt;

  @HiveField(7)
  bool isCompleted;

  ManifestItem({
    required this.id,
    required this.dreamId,
    required this.title,
    required this.checklist,
    required this.goalValues,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
  });

  double get progress {
    // Numeric progress mode
    if (hasGoalValues && goalValues.containsKey('current') && goalValues.containsKey('max')) {
      final current = goalValues['current'] ?? 0;
      final max = goalValues['max'] ?? 1;
      if (max == 0) return 0.0;
      return (current / max).clamp(0.0, 1.0);
    }
    // Checklist mode
    if (checklist.isEmpty) return 0.0;
    final completed = checklist.where((item) => item.isCompleted).length;
    return completed / checklist.length;
  }

  bool get hasGoalValues => goalValues.isNotEmpty;
  
  bool get isNumericMode => hasGoalValues && goalValues.containsKey('max');
  
  bool get isChecklistMode => checklist.isNotEmpty;
  
  void updateNumericProgress(double newCurrent) {
    if (isNumericMode) {
      goalValues['current'] = newCurrent;
      save();
    }
  }

  void markAsCompleted() {
    isCompleted = true;
    completedAt = DateTime.now();
    save();
  }
}

@HiveType(typeId: 3)
class ChecklistItem {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  DateTime? completedAt;

  ChecklistItem({
    required this.title,
    this.isCompleted = false,
    this.completedAt,
  });

  void toggle() {
    isCompleted = !isCompleted;
    completedAt = isCompleted ? DateTime.now() : null;
  }
}
