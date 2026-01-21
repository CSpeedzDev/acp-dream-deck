import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/dream.dart';
import 'dart:math';

class DreamProvider extends ChangeNotifier {
  static const String _boxName = 'dreams';
  Box<Dream>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<Dream>(_boxName);
    notifyListeners();
  }

  List<Dream> get allDreams {
    return _box?.values.toList() ?? [];
  }

  List<Dream> get activeDreams {
    return allDreams
        .where((dream) => !dream.isCompleted && !dream.isSnoozed)
        .toList();
  }

  List<Dream> get completedDreams {
    return allDreams.where((dream) => dream.isCompleted).toList()
      ..sort((a, b) => (b.completedAt ?? b.createdAt)
          .compareTo(a.completedAt ?? a.createdAt));
  }

  Dream? getRandomDream() {
    final active = activeDreams;
    if (active.isEmpty) return null;
    final random = Random();
    return active[random.nextInt(active.length)];
  }

  Future<void> addDream(Dream dream) async {
    await _box?.put(dream.id, dream);
    notifyListeners();
  }

  Future<void> deleteDream(String id) async {
    await _box?.delete(id);
    notifyListeners();
  }

  Future<void> updateDream(Dream dream) async {
    await dream.save();
    notifyListeners();
  }
}
