import 'package:campus_app/citm.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class ReceivedMailsList extends StatefulWidget {
  const ReceivedMailsList({
    Key? key,
  }) : super(key: key);

  @override
  State<ReceivedMailsList> createState() => _ReceivedMailsListState();
}

class _ReceivedMailsListState extends State<ReceivedMailsList> {
  List<Mail> receivedMails = [];
  bool _loaded = false;
  bool _isLoading = false;

  final ScrollController _controller = ScrollController();

  getDataReceivedMails() async {
    List<Mail> auxList = [];

    receivedMails.clear(); //restart list

    int numPages = await CITM.mailsPageCount(folder: 'Received');

    for (int i = 0; i < numPages; i++) {
      String data =
          await CITM.fetch('missatges_llistat.php', params: {"carpeta_actual": "0", "pag": "$i"});

      final html = parse(data);

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
        if (mailUnreadQuery[j].attributes.toString().split('.')[0].split('_')[1].trim() ==
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

      for (int i = 0; i < mailAuthorsList.length; i++) {
        auxList.add(Mail(mailUnreadCheckList[i], mailAuthorsList[i], mailSubjectList[i],
            DateTime.parse('${mailDateList[i]} ${mailTimeList[i]}:00')));
      }
      debugPrint("${auxList.length}");
    }

    setState(() {
      receivedMails = auxList;
      _loaded = true;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getDataReceivedMails();
    _controller.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _isLoading = true;
      });
      getDataReceivedMails();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _controller,
      itemCount: _isLoading ? receivedMails.length + 1 : receivedMails.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.blue.shade100,
          thickness: 1,
          height: 1,
        );
      },
      itemBuilder: (context, index) {
        if (receivedMails.length == index) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: receivedMails[index].unread
                    ? const Icon(Icons.mark_email_unread_rounded, color: Colors.blue)
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
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              )
                            : Text(
                                '${receivedMails[index].time.day}/${receivedMails[index].time.month}/${receivedMails[index].time.year} - ${receivedMails[index].time.hour}:0${receivedMails[index].time.minute}',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                        Text(
                          receivedMails[index].author,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(receivedMails[index].subject,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
