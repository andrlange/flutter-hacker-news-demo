import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/logger.dart';
import 'widgets/list_element.dart';
import 'bloc/news_list_cubit.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Hacker News'),
        backgroundColor: Colors.blue,
        actions:
            kIsWeb || kIsWasm
                ? [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed:
                        BlocProvider.of<NewsListCubit>(context).refreshData,
                  ),
                ]
                : null,
      ),
      body: Center(
        child: Container(
          width: 400.0,
          decoration: BoxDecoration(color: Colors.grey),
          child: _createNewsList(),
        ),
      ),
    );
  }

  Widget _createNewsList() {
    return BlocBuilder<NewsListCubit, NewsListState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<NewsListCubit>(context);
        List<int> newsIds = [];
        if (state is NewsListIdsReceived) {
          newsIds = state.ids;
          Logger.info(
            'News IDs received: ${newsIds.length}',
            runtimeType: runtimeType,
          );
        }
        if (state is NewsRefreshing) {
          newsIds.clear();
        }
        return RefreshIndicator(
          onRefresh: bloc.refreshData,
          child: ListView.builder(
            itemCount: newsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: bloc.fetchItem(newsIds[index]),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      _getHeader(index, newsIds.length),
                      ListElement(
                        item: snapshot.data,
                        isPlaceholder: !snapshot.hasData,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _getHeader(int index, int num) {
    return index < 1
        ? Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('$num Top Stories'),
        )
        : SizedBox(height: 0.0);
  }
}
