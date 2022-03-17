import 'package:campus_app/scraper.dart';
// Scraper.getDataClasses()
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => {
                  Scraper.getDataMails(),
                },
                child: const Text('GO!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
