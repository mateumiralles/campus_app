import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<String> fetch({required String url}) async {
      var headers = {"Cookie": "PHPSESSID=joevoa6sutp059orj6ptn4s9gj"};

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final htmlCitm = response.body.toString();
        return htmlCitm;
      } else {
        throw Exception('Failed to load data!');
      }
    }

class Scraper {

  static void getDataMails() async {
    String data = await fetch(url: 'https://citm.fundacioupc.com/missatges_llistat.php');
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
    for (int i = 0; i < mailAuthorsList.length; i++) {
      receivedMails.add(Mail(
          mailUnreadCheckList[i],
          mailAuthorsList[i],
          mailSubjectList[i],
          DateTime.parse('${mailDateList[i]} ${mailTimeList[i]}:00')));
    }

    for (int i = 0; i < receivedMails.length; i++) {
      print('${i + 1}- No llegit? ${receivedMails[i].unread}');
      print('${i + 1}- Autor: ${receivedMails[i].author}');
      print('${i + 1}- Assumpte: ${receivedMails[i].subject}');
      print('${i + 1}- data: ${receivedMails[i].time}');
      print('---------------------------------------');
    }
  }
}

class Mail {
  bool unread;
  String author, subject;
  DateTime time;

  Mail(
    this.unread,
    this.author,
    this.subject,
    this.time,
  );
}

class NextClass {
  DateTime time;
  String teacher, name, classroom;

  NextClass(
    this.time,
    this.teacher,
    this.name,
    this.classroom,
  );
}

List<Mail> receivedMails = [];


/*  
  //COMPROVACIÓ .getDataClasses()
  for (int i = 0; i < closeClasses.length; i++) {
    print('${i+1}- Nom: ${closeClasses[i].name}');
    print('${i+1}- Profe: ${closeClasses[i].teacher}');
    print('${i+1}- Aula: ${closeClasses[i].classroom}');
    print('${i+1}- data: ${closeClasses[i].time}');
    print('---------------------------------------');
  }
*/

 /*
  //COMPROVACIÓ .getDataMails()
  for (int i = 0; i < receivedMails.length; i++) {
    print('${i+1}- No llegit? ${receivedMails[i].unread}');
    print('${i+1}- Autor: ${receivedMails[i].author}');
    print('${i+1}- Assumpte: ${receivedMails[i].subject}');
    print('${i+1}- data: ${receivedMails[i].time}');
    print('---------------------------------------');
  }
*/

