import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/bloc/news_list_cubit.dart';
import '../screens/news_list_screen.dart';

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom App',
      home: BlocProvider(
        create: (context) => NewsListCubit(),
        child: NewsListScreen(),
      ),
    );
  }

}