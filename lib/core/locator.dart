import 'package:get_it/get_it.dart';
import 'package:hacker_news/core/logger.dart';
import '../resources/news_repository.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  Logger.info('Setup locator for singleton registration', runtimeType:
  locator.runtimeType);

  locator.registerSingleton<NewsRepository>(NewsRepository());
}