import 'package:flutter/material.dart';
import 'package:campus_app/citm.dart';

class MailDetailScreen extends StatelessWidget {
  final Mail mail;
  const MailDetailScreen({Key? key, required this.mail}) : super(key: key);


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MISSATGE DETAIL!'),
      ),
      body: Center(
          child: Text('INFORMACIO DEL MISSATGE ${mail.id}!')),
    );
  }
}
