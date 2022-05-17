import 'package:campus_app/citm.dart';
import 'package:campus_app/screens/mail_users_screen.dart';

import 'package:flutter/material.dart';

class SendMailScreen extends StatelessWidget {
  const SendMailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOU MISSATGE'),
      ),
      body: Center(
          child: Column(
        children: [
          const Text('PANTALLA DE NOU MISSATGE!'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const MailUsersScreen();
                }));
                CITM.getMailUsers();
              },
              child: const Text('DESTINATARIS!')),
          ElevatedButton(
              onPressed: () {
                debugPrint('Enviar msg!');
                CITM.sendMsg();
              },
              child: const Text('ENVIAR!'))
        ],
      )),
    );
  }
}
