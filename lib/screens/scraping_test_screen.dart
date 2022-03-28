import 'package:campus_app/scraper.dart';
import 'package:flutter/material.dart';

class ScrapingTestScreen extends StatelessWidget {
  const ScrapingTestScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Scraper.getDataMails();
              },
              child: const Text('GO!'),
            ),
          ],
        ),
      ),
    );
  }
}
