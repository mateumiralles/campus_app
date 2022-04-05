import 'package:campus_app/widgets/class_info.dart';
import 'package:campus_app/widgets/main_screen_btn.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[200],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                ClassInfo(),
                SizedBox(height: 20),
                Expanded(
                  child: MainScreenBtn('MISSATGES', Icons.mail_rounded),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: MainScreenBtn('TASQUES', Icons.task_rounded),
                ),
              ],
            ),
          ),
        ));
  }
}
