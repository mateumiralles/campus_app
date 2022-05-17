import 'package:campus_app/citm.dart';
import 'package:campus_app/screens/mail_users_screen.dart';

import 'package:flutter/material.dart';

import '../widgets/mail_form.dart';

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
      body: const Center(
          child: 
          MailForm(),
        ),
    );
  }
}
