import 'package:campus_app/citm.dart';
import 'package:flutter/material.dart';

class MailDetailScreen extends StatefulWidget {
  final Mail mail;
  const MailDetailScreen({Key? key, required this.mail}) : super(key: key);

  @override
  State<MailDetailScreen> createState() => _MailDetailScreenState();
}

class _MailDetailScreenState extends State<MailDetailScreen> {
  List<String> mailTextList = [];
  bool _loaded = false;

  getMailInfo() async {
   mailTextList= await CITM.getMailText(widget.mail.id);
    setState(() {
      _loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getMailInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MISSATGE DETAIL!'),
      ),
      body: Center(
        child: _loaded
            ? Column(
                children: [
                  Text('ID: ${widget.mail.id}'),
                  Text('Data: ${widget.mail.time}'),
                  Text('Assumpte: ${widget.mail.subject}'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mailTextList.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text('Parrafo $i: ${mailTextList[i]}'),
                        );
                      },
                    ),
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
