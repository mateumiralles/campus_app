import 'package:campus_app/citm.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    children:  [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            'Benvingut a la App del Campus del CITM',
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "Per accedir als continguts de l'aplicació hauràs d'iniciar sessió al campus virtual del CITM i a Atenea amb les teves credencials",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: OutlinedButton(
                    onPressed: () {
                      Session session = Session();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return  LoginScreen(numText: 1,text: 'Inicia sessió amb les credencials del CITM', session: session,);
                      }));
                    },
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      side: const BorderSide(width: 2, color: Colors.white),
                    ),
                    child: const Text(
                      'COMENÇAR',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            )
          ],
        )));
  }
}
