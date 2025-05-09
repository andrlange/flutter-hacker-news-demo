import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/v4.dart';

import '../core/logger.dart';
import 'news_cache.dart';
import 'news_source.dart';
import '../models/item_model.dart';

class NewsDbProvider implements NewsSource, NewsCache {
  late Box<String> _box;

  final String _uuid = UuidV4().generate();

  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitialized = false;

  NewsDbProvider() {
    Logger.info('NewsDbProvider created id:$_uuid', runtimeType: runtimeType);
    init();
  }

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _box = await Hive.openBox<String>('items');

      // Mark as initialized
      _isInitialized = true;

      // Complete the initialization completer
      _initCompleter.complete();

      Logger.info('NewsDbProvider initialized id:$_uuid', runtimeType: runtimeType);
    } catch (e) {
      // If initialization fails, complete with error
      _initCompleter.completeError(e);
      throw e;
    }
  }

  // Helper method to ensure initialization before any operation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initCompleter.future;
    }
  }

  @override
  Future<List<int>> fetchTopIds() async {
    await _ensureInitialized();
    final List<int> ids =
        _box.keys.map((key) => int.parse(key.substring(5))).toList();
    return ids;
  }

  @override
  Future<ItemModel> addItem(ItemModel item) async {
    await _ensureInitialized();
    if(_box.keys.contains(item.hiveId) && item.cachedAt!=null) return item;
    final newItem = item.copyWith(cachedAt: _getDateTimeNow());

    _box.put(newItem.hiveId, jsonEncode(newItem.toJson()));
    Logger.info('cached item: $newItem', runtimeType: runtimeType);
    return newItem;
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
    await _ensureInitialized();
    final Map<String, dynamic>? item = jsonDecode(_box.get('item_$id') ?? '{}');
    if (item == null || item.isEmpty) return null;
    return ItemModel.fromJson(item);
  }

  @override
  Future<void> clearCache() async {
    await _ensureInitialized();
    await _box.clear();
  }

  @override
  Future<void> removeItem(int id) async {
    await _ensureInitialized();
    await _box.delete('item_$id');
    Logger.info('Deleting item with id: $id', runtimeType: runtimeType);
  }

  String _getDateTimeNow() {
    return DateTime.now().toIso8601String();
  }

  Future<void> dispose() async {
    await _ensureInitialized();
    await _box.close();
  }
}

final newsDbProvider = NewsDbProvider();
