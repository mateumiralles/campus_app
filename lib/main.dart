import 'package:campus_app/scraper.dart';
import 'package:campus_app/screens/main_screen.dart';
import 'package:campus_app/screens/received_mails_screen.dart';
import 'package:campus_app/screens/scraping_test_screen.dart';
import 'package:flutter/material.dart';

void main() {
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

