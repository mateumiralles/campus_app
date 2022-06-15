import 'package:campus_app/citm.dart';
import 'package:campus_app/screens/mails_screen.dart';
import 'package:campus_app/screens/main_screen.dart';
import 'package:campus_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userCitm = prefs.getString('userCitm');
  final passCitm = prefs.getString('passCitm');
  debugPrint(userCitm);
  debugPrint(passCitm);
  bool loadedCredentials = false;

  if ((userCitm != null) && (passCitm != null)) {
    CITM.init(userCitm, passCitm);
    loadedCredentials = true;
  }

  runApp(MyApp(loadedCredentials));
}

class MyApp extends StatelessWidget {
  const MyApp(this.loadedCredentials, {Key? key}) : super(key: key);
  final bool loadedCredentials;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: ScrapingTestScreen(),
        // home: MailsScreen(),
        home: loadedCredentials ? const MainScreen() : const WelcomeScreen()
        // home: MainScreen(),
        );
  }
}
