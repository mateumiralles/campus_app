import 'package:campus_app/citm.dart';
import 'package:campus_app/env.dart';
import 'package:campus_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  final env = await readEnvFile();
  CITM.init(env.username, env.password);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: ScrapingTestScreen(),
      //home: ReceivedMailsScreen(),
      home: MainScreen(),
    );
  }
}
