import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:secret/actions/store.dart';
import 'package:secret/login.dart';

import 'actions/colors.dart';
import 'model/accounts.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox<Account>(AccountsBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🤫',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light, //TODO: implement dark mode
        colorScheme: const ColorScheme.light(
          primary: purpleLight,
          onPrimary: pinkStrong,
        ),
      ),
      home: LoginScreen(),
    );
  }
}
