import 'package:hive/hive.dart';
import 'dream_category.dart';

part 'dream.g.dart';

@HiveType(typeId: 0)
class Dream extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? notes;

  @HiveField(3)
  String? firstStep;

  @HiveField(4)
  int categoryIndex;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime? completedAt;

  @HiveField(8)
  DateTime? snoozedUntil;

  Dream({
    required this.id,
    required this.title,
    this.notes,
    this.firstStep,
    required this.categoryIndex,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.snoozedUntil,
  });

  DreamCategory get category => DreamCategory.values[categoryIndex];

  bool get isSnoozed {
    if (snoozedUntil == null) return false;
    return DateTime.now().isBefore(snoozedUntil!);
  }

  void snoozeFor24Hours() {
    snoozedUntil = DateTime.now().add(const Duration(hours: 24));
    save();
  }

  void markAsCompleted() {
    isCompleted = true;
    completedAt = DateTime.now();
    save();
  }

  void markAsActive() {
    isCompleted = false;
    completedAt = null;
    save();
  }
}
