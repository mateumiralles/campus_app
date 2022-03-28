import 'package:campus_app/scraper.dart';
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
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            minVerticalPadding: 20,
            //TODO: Align icon amb el tile
            leading: receivedMails[index].unread
                ? const Icon(Icons.mark_email_unread_rounded,
                    color: Colors.blue)
                : const Icon(Icons.email_rounded),
            title: Row(
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
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3),
                Text(receivedMails[index].subject,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){return Scaffold(appBar: AppBar(title: const Text('NOU MISSATGE'),),  body:const Center(child: Text('PANTALLA DE NOU MISSATGE!')),);}));
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
