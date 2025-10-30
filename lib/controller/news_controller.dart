import 'dart:developer';
import 'package:get/get.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/services/endpoints.dart';
import 'package:news_app/services/local_store.dart';
import 'package:news_app/services/news_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsController extends GetxController {
  NewsController(this.api, this.store);
  final NewsApi api;
  final LocalStore store;

  final endpoint = NewsEndpoint.latest.obs;
  final today = <Item>[].obs;
  final saved = <Item>[].obs;
  final index = 0.obs;

  final loading = false.obs;
  final error = RxnString();

  static const int pageSize = 10;
  final page = 0.obs;

  Item? get current => today.isEmpty ? null : today[index()];

  int get totalPages => today.isEmpty ? 1 : ((today.length - 1) / pageSize).floor() + 1;

  List<Item> get pageItems {
    final start = (page.value * pageSize).clamp(0, today.length);
    final end = (start + pageSize).clamp(0, today.length);
    return today.sublist(start, end);
  }

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
    saved.assignAll(await store.readSaved());
    today.assignAll(await store.readCacheToday());
    if (today.isEmpty) await refreshData();
    if (today.isNotEmpty) {
      index.value = 0;
      page.value = 0;
    }
  }

  Future<void> refreshData() async {
    log('Refreshing articles for ${endpoint().path}');
    try {
      loading.value = true;
      error.value = null;

      final list = await api.fetchByEndpoint(endpoint());

      log('API returned ${list.length} items for ${endpoint().path}');
      today.assignAll(list);

      index.value = today.isEmpty ? 0 : 0;
      page.value = 0;

      await store.saveCacheToday(today);
      saved.assignAll(await store.readSaved());
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> setEndpoint(NewsEndpoint ep) async {
    if (endpoint() == ep) return;
    endpoint.value = ep;
    await refreshData();
  }

  void goPage(int p) {
    if (p < 0 || p > totalPages - 1) return;
    page.value = p;
  }

  void nextPage() => goPage(page.value + 1);
  void prevPage() => goPage(page.value - 1);

  void _syncPageToIndex() {
    page.value = (index.value / pageSize).floor();
  }

  void next() {
    if (today.isEmpty) return;
    if (index.value < today.length - 1) {
      index.value++;
      _syncPageToIndex();
    }
  }

  void prev() {
    if (today.isEmpty) return;
    if (index.value > 0) {
      index.value--;
      _syncPageToIndex();
    }
  }

  void openAt(int absoluteIndex) {
    if (absoluteIndex < 0 || absoluteIndex >= today.length) return;
    index.value = absoluteIndex;
    _syncPageToIndex();
  }

  Future<void> toggleSave() async {
    final a = current;
    if (a == null) return;
    await store.toggleSave(a);
    saved.assignAll(await store.readSaved());
  }

  Future<void> unsave(Item a) async {
    await store.toggleSave(a);
    saved.assignAll(await store.readSaved());
  }

  bool isSaved(String title) => saved.any((e) => e.title == title);
}
