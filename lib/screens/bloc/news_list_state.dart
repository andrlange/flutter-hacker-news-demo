part of 'news_list_cubit.dart';

abstract class NewsListState extends Equatable {
  const NewsListState();

  @override
  List<Object?> get props => [];
}

class NewsListInitial extends NewsListState {
  const NewsListInitial();
}

class NewsRefreshing extends NewsListState {
  const NewsRefreshing();
}

class NewsListIdsReceived extends NewsListState {

  final List<int> ids;
  const NewsListIdsReceived({required this.ids});

  @override
  List<Object?> get props => [ids];
}




