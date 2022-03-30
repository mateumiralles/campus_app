import 'package:campus_app/widgets/mailList.dart';
import 'package:flutter/material.dart';

class ReceivedMailsScreen extends StatefulWidget {
  const ReceivedMailsScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedMailsScreen> createState() => _ReceivedMailsScreenState();
}

class _ReceivedMailsScreenState extends State<ReceivedMailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MISSATGES'),
      ),
      body: MailList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('NOU MISSATGE'),
              ),
              body: const Center(child: Text('PANTALLA DE NOU MISSATGE!')),
            );
          }));
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.draw_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

