import 'package:campus_app/scraper.dart';
import 'package:campus_app/widgets/classInfo.dart';
import 'package:campus_app/widgets/mainScreenBtn.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Scraper.getDataClasses();
    Scraper.getDataMails();
    return Scaffold(
        backgroundColor: Colors.blue[200],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                classInfo(),
                const SizedBox(height: 20),
                const Expanded(
                  child: MainScreenBtn('MISSATGES', Icons.mail_rounded),
                ),
                const SizedBox(height: 20),
                const Expanded(
                  child: MainScreenBtn('TASQUES', Icons.task_rounded),
                ),
              ],
            ),
          ),
        ));
  }
}
