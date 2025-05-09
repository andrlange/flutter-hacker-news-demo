import 'package:hacker_news/core/logger.dart';
import 'package:uuid/v4.dart';

import 'news_cache.dart';
import 'news_source.dart';
import '../models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';

class NewsRepository {
  final List<NewsSource> _newsSources = <NewsSource>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  final List<NewsCache> _newsCaches = <NewsCache>[newsDbProvider];

  NewsRepository() {
    Logger.info(
      "NewsRepository created id:${UuidV4().generate()}",
      runtimeType: runtimeType,
    );
  }

  Future<List<int>> fetchTopIds({bool clearCache = false}) async {
    List<int> ids = [];
    if(clearCache){
      for (NewsCache cache in _newsCaches) {
        cache.clearCache();
      }
    }

    for (NewsSource source in _newsSources) {
      ids = await source.fetchTopIds();
      if (ids.isNotEmpty && ids.length>499) break;
    }
    return ids;
  }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    NewsSource? source;

    for (source in _newsSources) {
      item = await source.fetchItem(id);

      if (item != null) break;
    }

    if (item != null) {
      for (NewsCache cache in _newsCaches) {
        if (source.hashCode != cache.hashCode) cache.addItem(item);
      }
    }

    Logger.info('Fetched item id:$id', runtimeType: runtimeType);
    return item;
  }
}
