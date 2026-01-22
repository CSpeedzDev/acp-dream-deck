import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/manifest_item.dart';

class ManifestProvider extends ChangeNotifier {
  static const String _boxName = 'manifest_items';
  Box<ManifestItem>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<ManifestItem>(_boxName);
    notifyListeners();
  }

  List<ManifestItem> get allManifests {
    return _box?.values.toList() ?? [];
  }

  List<ManifestItem> get activeManifests {
    return allManifests.where((item) => !item.isCompleted).toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  List<ManifestItem> get completedManifests {
    return allManifests.where((item) => item.isCompleted).toList()
      ..sort((a, b) => (b.completedAt ?? b.startedAt)
          .compareTo(a.completedAt ?? a.startedAt));
  }

  ManifestItem? getManifestByDreamId(String dreamId) {
    try {
      return allManifests.firstWhere((item) => item.dreamId == dreamId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addManifest(ManifestItem item) async {
    await _box?.put(item.id, item);
    notifyListeners();
  }

  Future<void> updateManifest(ManifestItem item) async {
    await item.save();
    notifyListeners();
  }

  Future<void> deleteManifest(String id) async {
    await _box?.delete(id);
    notifyListeners();
  }
}
