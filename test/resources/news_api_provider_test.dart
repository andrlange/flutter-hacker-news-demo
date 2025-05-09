import 'package:hacker_news/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

main() {
  test('fetchTopIds returning a list of Ids', () async {
    // setup of test case
    final newsApiProvider = NewsApiProvider();
    MockClient mockClient = MockClient((request) async {
      return Response(jsonEncode([1, 2, 3, 4]), 200);
    });

    newsApiProvider.client = mockClient;
    final ids = await newsApiProvider.fetchTopIds();

    // expected result
    expect(ids, [1, 2, 3, 4], reason: 'Expected top 4 news ids');
  });

  test('fetchItem returning a Item Model', () async {
    // setup of test case
    final newsApiProvider = NewsApiProvider();
    MockClient mockClient = MockClient((request) async {
      final jsonMap = {
        'id': 123,
        'title': 'This is a test title',
        'url': 'https://example.com',
        'type': 'Story',
      };

      return Response(jsonEncode(jsonMap), 200);
    });

    newsApiProvider.client = mockClient;
    final item = await newsApiProvider.fetchItem(999);

    // expected result
    print(item);
    expect(item?.id, 123, reason: 'Failed to fetch item id');

  });

}
