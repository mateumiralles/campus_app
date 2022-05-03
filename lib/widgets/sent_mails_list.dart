import 'package:campus_app/citm.dart';
import 'package:flutter/material.dart';

class SentMailsList extends StatefulWidget {
  const SentMailsList({
    Key? key,
  }) : super(key: key);

  @override
  State<SentMailsList> createState() => _SentMailsListState();
}

class _SentMailsListState extends State<SentMailsList> {
  List<Mail> sentMails = [];
  int numPages = 1;
  int currPage = 0;
  bool _loaded = false;

  getFirstMailListPage() async {
    numPages = await CITM.mailsPageCount(folder: 'Sent');
    currPage = 0;
    List<Mail> loadedMessages = await CITM.getMailListPage("1", currPage);
    currPage++;
    setState(() {
      sentMails = loadedMessages;
      _loaded = true;
    });
  }

  getNextMailListPage() async {
    List<Mail> loadedMessages = await CITM.getMailListPage("1", currPage);
    currPage++;
    setState(() {
      sentMails.addAll(loadedMessages);
    });
  }

  @override
  void initState() {
    super.initState();
    getFirstMailListPage();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      getNextMailListPage();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _loaded
        ? NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  color: index % 2 == 0 ? Colors.blue.shade50 : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: sentMails[index].unread
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  sentMails[index].time.minute >= 10
                                      ? Text(
                                          '${sentMails[index].time.day}/${sentMails[index].time.month}/${sentMails[index].time.year} - ${sentMails[index].time.hour}:${sentMails[index].time.minute}',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12),
                                        )
                                      : Text(
                                          '${sentMails[index].time.day}/${sentMails[index].time.month}/${sentMails[index].time.year} - ${sentMails[index].time.hour}:0${sentMails[index].time.minute}',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12),
                                        ),
                                  Text(
                                    sentMails[index].author,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(sentMails[index].subject,
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
                  ),
                );
              },
              itemCount: sentMails.length,
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.blue.shade100,
                  thickness: 1,
                  height: 1,
                );
              },
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
