import 'package:flutter/material.dart';
import 'package:campus_app/citm.dart';
import 'package:html/parser.dart';

class MailDetailScreen extends StatefulWidget {
  final Mail mail;
  const MailDetailScreen({Key? key, required this.mail}) : super(key: key);

  @override
  State<MailDetailScreen> createState() => _MailDetailScreenState();
}

class _MailDetailScreenState extends State<MailDetailScreen> {
  List<String> mailTextList = [];
  bool _loaded = false;

  getMailText(String id) async {
    String data = await CITM.fetch('missatge.php', params: {
      "id_mensaje": id,
    });
    final html = parse(data);

    final mailTextQuery = html.querySelectorAll('.Arial11Black')[1].children;

    for (int i = 0; i < mailTextQuery.length; i++) {
      mailTextList.add(mailTextQuery[i].text);
    }

    for (int i = 0; i < mailTextList.length; i++) {
      debugPrint(mailTextList[i]);
    }
    debugPrint('${mailTextList.length}');
    setState(() {
      _loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getMailText(widget.mail.id);
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
