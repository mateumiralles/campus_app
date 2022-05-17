import 'package:flutter/material.dart';

import '../citm.dart';

class MailUsersScreen extends StatefulWidget {
  const MailUsersScreen({Key? key}) : super(key: key);

  @override
  State<MailUsersScreen> createState() => _MailUsersScreenState();
}

class _MailUsersScreenState extends State<MailUsersScreen> {
  List<String> UsersList = [];
  bool loaded = false;

  getDataUsers() async {
    CITM.getMailUsers();

    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DESTINATARIS'),
        ),
        body: const Center(child: Text('PANTALLA DE DESTINATARIS')));
  }
}
