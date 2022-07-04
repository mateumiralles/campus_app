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
        title:  Text('${widget.mail.subject}'),
      ),
      body: Center(
        child: _loaded
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text('Data: ${widget.mail.time.day}/${widget.mail.time.month}/${widget.mail.time.year}  ${widget.mail.time.hour}:${widget.mail.time.minute > 9 ? widget.mail.time.minute : '0${widget.mail.time.minute}'}'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mailTextList.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text('${mailTextList[i]}'),
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
