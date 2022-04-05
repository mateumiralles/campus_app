import 'package:campus_app/scraper.dart';
import 'package:flutter/material.dart';

class MailList extends StatelessWidget {
  const MailList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
    );
  }
}
