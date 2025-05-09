import 'package:flutter/material.dart';
import 'core/app.dart';
import 'core/locator.dart';

void main() async{
  await initApp();
  runApp(App());
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
}