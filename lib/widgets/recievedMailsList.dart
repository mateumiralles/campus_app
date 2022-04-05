import 'package:campus_app/functions.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../screens/mails_screen.dart';

class RecievedMailsList extends StatefulWidget {
  const RecievedMailsList({
    Key? key,
  }) : super(key: key);

  @override
  State<RecievedMailsList> createState() => _RecievedMailsListState();
}

class _RecievedMailsListState extends State<RecievedMailsList> {
  List<Mail> receivedMails = [];
  bool _loaded = false;

  getDataRecievedMails() async {
    String data =
        await fetch(url: 'https://citm.fundacioupc.com/missatges_llistat.php?carpeta_actual=0');
    final html = parse(data);

    receivedMails.clear(); //restart list

    final mailInfoQuery = html.querySelectorAll(
        'html > body > table > tbody > tr > td > form > table > tbody > tr > td > table > tbody > tr > td.Arial10Black');

    final mailUnreadQuery = html.querySelectorAll('[width="16"] img');

    final mailSubjectQuery = html.querySelectorAll('[rowspan="2"]');

    List<String> mailAuthorsList = [];
    List<String> mailDateList = [];
    List<String> mailTimeList = [];
    for (int i = 1; i < mailInfoQuery.length; i += 2) {
      mailAuthorsList.add(mailInfoQuery[i].text.trim());
      mailDateList.add(
          '${mailInfoQuery[i + 1].text.trim().split(' ')[0].split("/")[2]}-${mailInfoQuery[i + 1].text.trim().split(' ')[0].split("/")[1]}-${mailInfoQuery[i + 1].text.trim().split(' ')[0].split("/")[0]}');
      mailTimeList.add(mailInfoQuery[i + 1].text.trim().split(' ')[1]);
    }

    List<bool> mailUnreadCheckList = [];
    for (int j = 0; j < mailUnreadQuery.length; j++) {
      if (mailUnreadQuery[j]
              .attributes
              .toString()
              .split('.')[0]
              .split('_')[1]
              .trim() ==
          'tancat') {
        mailUnreadCheckList.add(true);
      } else {
        mailUnreadCheckList.add(false);
      }
    }

    List<String> mailSubjectList = [];
    for (int i = 0; i < mailAuthorsList.length; i++) {
      mailSubjectList.add(mailSubjectQuery[i].text);
    }

    receivedMails = [];

    setState(() {
      for (int i = 0; i < mailAuthorsList.length; i++) {
        receivedMails.add(Mail(
            mailUnreadCheckList[i],
            mailAuthorsList[i],
            mailSubjectList[i],
            DateTime.parse('${mailDateList[i]} ${mailTimeList[i]}:00')));
      }
      _loaded = true;
    });
    print(receivedMails.length);
  }

  @override
  void initState() {
    super.initState();
    getDataRecievedMails();
  }

  @override
  Widget build(BuildContext context) {
    return _loaded ? ListView.separated(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: receivedMails[index].unread
                    ? const Icon(Icons.mark_email_unread_rounded,
                        color: Colors.blue)
                    : const Icon(
                        Icons.email_rounded,
                        color: Colors.grey,
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        receivedMails[index].time.minute >= 10
                            ? Text(
                                '${receivedMails[index].time.day}/${receivedMails[index].time.month}/${receivedMails[index].time.year} - ${receivedMails[index].time.hour}:${receivedMails[index].time.minute}',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              )
                            : Text(
                                '${receivedMails[index].time.day}/${receivedMails[index].time.month}/${receivedMails[index].time.year} - ${receivedMails[index].time.hour}:0${receivedMails[index].time.minute}',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                        Text(
                          receivedMails[index].author,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(receivedMails[index].subject,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: receivedMails.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.blue.shade100,
          thickness: 1,
          height: 1,
        );
      },
    ) : const Center(child: CircularProgressIndicator());
  }
}
