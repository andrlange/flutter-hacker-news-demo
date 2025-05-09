import '../models/item_model.dart';

abstract class NewsSource {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}
