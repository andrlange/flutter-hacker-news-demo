import '../models/item_model.dart';

abstract class NewsCache {
  Future<ItemModel> addItem(ItemModel item);
  Future<void> removeItem(int id);
  Future<void> clearCache();
}
