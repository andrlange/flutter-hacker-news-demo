import 'dart:convert';
import 'package:hacker_news/core/logger.dart';
import 'news_source.dart';
import 'package:uuid/v4.dart';
import 'package:http/http.dart' show Client;

import '../models/item_model.dart';


class NewsApiProvider implements NewsSource {
  final _root = 'https://hacker-news.firebaseio.com/v0';
  Client client = Client();

  NewsApiProvider() {
    Logger.info('NewsApiProvider created id:${UuidV4().generate()}',
        runtimeType: runtimeType);
  }

  @override
  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.parse('$_root/topstories.json'));

    if (response.statusCode == 200) {
      final topIds = jsonDecode(response.body);
      return topIds.cast<int>();
    } else {
      return [];
    }
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
    final response = await client.get(Uri.parse('$_root/item/$id.json'));

    if (response.statusCode == 200) {
      final parsedItem = jsonDecode(response.body);
      return ItemModel.fromJson(parsedItem);
    } else {
      return null;
    }
  }
}
