import 'package:campus_app/widgets/mail_form.dart';
import 'package:flutter/material.dart';

class SendMailScreen extends StatelessWidget {
  const SendMailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nou missatge'),
      ),
      body: const Center(
          child: 
          MailForm(),
        ),
    );
  }
}
