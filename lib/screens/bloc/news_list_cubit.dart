import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/locator.dart';
import '../../core/logger.dart';
import '../../resources/news_repository.dart';
import '../../models/item_model.dart';

part 'news_list_state.dart';

class NewsListCubit extends Cubit<NewsListState> {

  final newsRepository = locator.get<NewsRepository>();

  NewsListCubit() : super(NewsListInitial()) {
    Logger.info('NewsListCubit created', runtimeType: runtimeType);
    initialLoad();
  }

  Future<void> initialLoad({bool clearCache = false}) async {
    final ids = await newsRepository.fetchTopIds(clearCache: clearCache);
    emit(NewsListIdsReceived(ids: ids));
  }


  Future<ItemModel?> fetchItem(int itemId) async {
    final item= await newsRepository.fetchItem(itemId);
    return (item!= null && item.title !=null) ? item : null;
  }

  Future<void> refreshData() async {
    Logger.info('Refreshing data', runtimeType: runtimeType);
    emit(const NewsRefreshing());
    initialLoad(clearCache: true);
  }

  @override
  Future<void> close() {
    Logger.info('NewsListCubit closed', runtimeType: runtimeType);
    return super.close();
  }
}
