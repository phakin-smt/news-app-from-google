import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/model/news_model.dart';

class LocalStore {
  static const _kSaved = 'saved_articles';
  static const _kCacheToday = 'cache_today';

  Future<void> saveCacheToday(List<Item> list) async {
    final sp = await SharedPreferences.getInstance();
    final json = jsonEncode(list.map((e) => e.toJson()).toList());
    await sp.setString(_kCacheToday, json);
  }

  Future<List<Item>> readCacheToday() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kCacheToday);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return list.map(Item.fromJson).toList();
    } catch (_) {
      await sp.remove(_kCacheToday);
      return [];
    }
  }

  Future<List<Item>> readSaved() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kSaved);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return list.map(Item.fromJson).toList();
    } catch (_) {
      await sp.remove(_kSaved);
      return [];
    }
  }

  Future<void> toggleSave(Item a) async {
    final sp = await SharedPreferences.getInstance();
    final cur = await readSaved();
    final exists = cur.any((e) => e.stableId == a.stableId);
    final next = exists
        ? cur.where((e) => e.stableId != a.stableId).toList()
        : [
            ...cur,
            a
          ];
    await sp.setString(
      _kSaved,
      jsonEncode(next.map((e) => e.toJson()).toList()),
    );
  }
}
