import 'package:campus_app/screens/welcome_screen.dart';
import 'package:campus_app/widgets/class_info.dart';
import 'package:campus_app/widgets/main_screen_btn.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
        backgroundColor: Colors.blue[200],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ClassInfo(),
                const SizedBox(height: 20),
                const Expanded(
                  child: MainScreenBtn('MISSATGES', Icons.mail_rounded),
                ),
                const SizedBox(height: 20),
                const Expanded(
                  child: MainScreenBtn('TASQUES', Icons.task_rounded),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const WelcomeScreen();
                      }));
                    },
                    label: const Text(
                      'EXIT',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    icon: const Icon(
                      Icons.restart_alt_rounded,
                      size: 50,
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
