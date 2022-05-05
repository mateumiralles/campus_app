import 'package:campus_app/citm.dart';
import 'package:campus_app/widgets/received_mails_list.dart';
import 'package:campus_app/widgets/sent_mails_list.dart';
import 'package:flutter/material.dart';

class MailsScreen extends StatefulWidget {
  const MailsScreen({Key? key}) : super(key: key);

  @override
  State<MailsScreen> createState() => _MailsScreenState();
}

class _MailsScreenState extends State<MailsScreen> {
  final List<String> _folders = ['Rebuts', 'Enviats'];
  bool _inbox = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missatges ${_inbox ? 'Rebuts' : 'Enviats'}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Center(
              child: DropdownButton(
                items: _folders
                    .map((String e) => DropdownMenuItem(
                          value: e,
                          //TODO: Treure Espai sobrant desplegable
                          child: Text(e,
                              style: const TextStyle(fontSize: 15), textAlign: TextAlign.right),
                          alignment: Alignment.centerRight,
                        ))
                    .toList(),
                onChanged: (_value) => {
                  setState(() {
                    _value == _folders[0] ? _inbox = true : _inbox = false;
                  })
                },
                hint: const Icon(Icons.folder),
                alignment: Alignment.centerRight,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: _inbox ? const ReceivedMailsList() : const SentMailsList() ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('NOU MISSATGE'),
              ),
              body: Center(child: Column(
                children: [
                  const Text('PANTALLA DE NOU MISSATGE!'),
                  ElevatedButton(onPressed: (){debugPrint('ete setx'); sendMsg();}, child: const Text('ENVIAR!'))
                ],
              )),
            );
          }));
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.draw_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
