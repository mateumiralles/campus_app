import 'dart:io';
import 'package:html/parser.dart';

class Scraper {
  static void getDataClasses() {
    List<String> classesInfoList = [];
    var data = File('login_citm.html').readAsStringSync();
    final html = parse(data);

    final classesTableQuery = html.querySelectorAll(
        'html > body > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td > table > tbody')[0];

    final classesNameQuery = html.querySelectorAll(
        'html > body > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td.Arial11Black > a ');

    for (int i = 1; i < classesTableQuery.nodes.length; i++) {
      if (classesTableQuery.nodes[i].text.toString().trim() != "") {
        classesInfoList.add(classesTableQuery.nodes[i].text.toString().trim());
      }
    }

    for (int j = 0; j < classesInfoList.length; j++) {
      List<String> splitAux = classesInfoList[j].split('(');

      //GET dateTime
      String dateTime = classesInfoList[j].substring(0, 16);

      //Parse dateTime
      String date, time;
      date = dateTime.split(' ')[0].trim();
      time = dateTime.split(' ')[1].trim();

      String year, month, day;

      year = date.split('-')[2].trim();
      month = date.split('-')[1].trim();
      day = date.split('-')[0].trim();

      //GET teacher
      String teacherName = splitAux[1].split(')')[0].toString();

      //GET classroom
      String classroom = splitAux[1].split(')')[1].toString().trim();

      //GET name
      String className = classesNameQuery[j].text.toString();

      /*
      print(teacherName);
      print(classroom);
      print(dateTime);
      print(className);
*/

      closeClasses.add(NextClass(DateTime.parse('$year-$month-$day $time:00'),
          teacherName, className, classroom));

      print(closeClasses[j].name);
    }
  }

  static void getDataMails() {
    //TODO: Error Lectura fitxer al debug
    var data = File('msg_citm.html').readAsStringSync();
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

    for (int i = 0; i < mailAuthorsList.length; i++) {
      recievedMails.add(Mail(mailUnreadCheckList[i], mailAuthorsList[i], mailSubjectList[i], DateTime.parse('${mailDateList[i]} ${mailTimeList[i]}:00')));
    }
    
  print("xdlolmafia");

    /*
    print(mailInfoQuery[1].text.trim());
    print(mailInfoQuery[2].text.trim());
    print(mailUnreadQuery[10].attributes);
    print(mailSubjectQuery[3].text);
    */
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

List<NextClass> closeClasses = [];
List<Mail> recievedMails = [];
void main() {
  Scraper.getDataMails();

/*  
  //COMPROVACIÓ .getDataClasses()
  for (int i = 0; i < closeClasses.length; i++) {
    print('${i + 1}- Nom: ${closeClasses[i].name}');
    print('${i + 1}- Profe: ${closeClasses[i].teacher}');
    print('${i + 1}- Aula: ${closeClasses[i].classroom}');
    print('${i + 1}- data: ${closeClasses[i].time}');
    print('---------------------------------------');
  }
*/

 /*
  //COMPROVACIÓ .getDataMails()
  for (int i = 0; i < recievedMails.length; i++) {
    print('${i + 1}- No llegit? ${recievedMails[i].unread}');
    print('${i + 1}- Autor: ${recievedMails[i].author}');
    print('${i + 1}- Assumpte: ${recievedMails[i].subject}');
    print('${i + 1}- data: ${recievedMails[i].time}');
    print('---------------------------------------');
  }
*/
}
