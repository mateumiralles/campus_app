import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final phpSessionRegexp = RegExp(r"PHPSESSID=([^;]*)");

final loginUriCitm = Uri.parse("https://citm.fundacioupc.com/index.php?next=");

final loginUriAtenea = Uri.parse(
    "https://sso.upc.edu/CAS/login?service=https%3A%2F%2Fatenea.upc.edu%2Flogin%2Findex.php%3FauthCAS%3DCAS");

const formDataHeaders = {
  "Content-Type": "application/x-www-form-urlencoded",
};

class Session {
  List<Credentials> credentialsList = [];
  String? ateneaUserId, ateneaUserToken;

  void setCredentials(
      {required int index, required String user, required String pass}) {
    credentialsList.insert(
        index, Credentials.getCredentials(user: user, pass: pass));

    for (int i = 0; i < credentialsList.length; i++) {
      debugPrint(
          '$i: ( user: ${credentialsList[i].username}, pass: ${credentialsList[i].password})');
    }
  }

  Future<bool> checkCitmCredentials(context) async {
    final credentials = {
      "username": credentialsList[0].username,
      "password": credentialsList[0].password,
    };

    final response = await http.post(loginUriCitm,
        headers: formDataHeaders, body: credentials);

    if (response.statusCode != 302) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Credencials incorrectes o error al iniciar sessió")));

      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkAteneaCredentials(context) async {
    final credentials = {
      "adAS_mode": "authn",
      "adAS_username": credentialsList[1].username,
      "adAS_password": credentialsList[1].password,
    };

    final response = await http.post(loginUriAtenea,
        headers: formDataHeaders, body: credentials);

    if (response.statusCode != 302) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Credencials incorrectes o error al iniciar sessió")));
      return false;
    } else {
      return true;
    }
  }

  Future<void> storeCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userCitm', credentialsList[0].username);
    await prefs.setString('passCitm', credentialsList[0].password);
    await prefs.setString('userAtenea', credentialsList[1].username);
    await prefs.setString('passAtenea', credentialsList[1].password);
  }

}

String extractSessionID(Map<String, String> headers) {
  if (!headers.containsKey('set-cookie')) {
    throw "Set-Cookie not found!";
  }
  final setCookie = headers['set-cookie']!;
  final matches = phpSessionRegexp.firstMatch(setCookie);
  if (matches == null) {
    return "PHPSESSID not found!";
  }
  return matches.group(1)!;
}

class Mail {
  bool unread;
  String id, author, subject;
  DateTime time;

  Mail(
    this.id,
    this.unread,
    this.author,
    this.subject,
    this.time,
  );
}

class CITM {
  static String? _sessionId, _username, _password;

  static void init(String username, String password) {
    _username = username;
    _password = password;
  }

  static Future<void> login() async {
    final credentials = {
      "username": _username,
      "password": _password,
    };
    final response = await http.post(loginUriCitm,
        headers: formDataHeaders, body: credentials);
    if (response.statusCode != 302) {
      // they use a redirect to the initial page (inici.php)
      throw "Couldn't login (status ${response.statusCode}).";
    }
    _sessionId = extractSessionID(response.headers);
  }

  static Future<String> fetch(String path,
      {Map<String, dynamic>? params}) async {
    if (_sessionId == null) {
      await login();
    }
    final uri = Uri(
      scheme: "https",
      host: "citm.fundacioupc.com",
      path: path,
      queryParameters: params,
    );
    final response = await http.get(uri, headers: {
      "Cookie": "PHPSESSID=$_sessionId",
    });
    if (response.statusCode != 200) {
      throw "Request failed with status ${response.statusCode}";
    }
    return response.body.toString();
  }

  static Future<List<NextClass>> getCloseClasses() async {
    List<NextClass> closeClasses = [];
    List<String> classesInfoList = [];

    String data = await CITM.fetch('/inici.php');

    final html = parse(data);

    final classesTableQuery = html.querySelectorAll(
        'html > body > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td > table > tbody');

    final checkClassesQuery =
        html.querySelectorAll(' .Arial11BlancBold')[0].innerHtml;

    if (classesTableQuery.isNotEmpty &&
        (checkClassesQuery == 'Pròximes classes' ||
            checkClassesQuery == 'Próximas clases' ||
            checkClassesQuery == 'Next session')) {
      final classesTableQuery0 = classesTableQuery[0];
      final classesNameQuery = html.querySelectorAll(
          'html > body > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td.Arial11Black > a ');

      for (int i = 1; i < classesTableQuery0.nodes.length; i++) {
        if (classesTableQuery0.nodes[i].text.toString().trim() != "") {
          classesInfoList
              .add(classesTableQuery0.nodes[i].text.toString().trim());
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

        closeClasses.add(NextClass(DateTime.parse('$year-$month-$day $time:00'),
            teacherName, className, classroom));
      }
      debugPrint('NumClasses: ${closeClasses.length}');
    }

    return closeClasses;
  }

  static Future<int> mailsPageCount({required String folder}) async {
    String numFolder = folder == 'Received' ? '0' : '1';

    String data = await CITM
        .fetch('missatges_llistat.php', params: {"carpeta_actual": numFolder});

    final html = parse(data);

    final pagCountObject = html.querySelectorAll(
        'html > body > table > tbody > tr > td > form > table > tbody > tr > td > table > tbody > tr > td.BgColorAzulClaro.Arial10Black');

    int numPages = int.parse(pagCountObject[0].text.split(' ').last);

    debugPrint('Numero de pagines de mails: $numPages');
    return numPages;
  }

  static Future<List<Mail>> getMailListPage(String carpeta, int pagina) async {
    List<Mail> auxList = [];

    String data = await CITM.fetch('missatges_llistat.php', params: {
      "carpeta_actual": carpeta,
      "pag": "$pagina",
    });
    final html = parse(data);

    final mailInfoQuery = html.querySelectorAll(
        'html > body > table > tbody > tr > td > form > table > tbody > tr > td > table > tbody > tr > td.Arial10Black');

    final mailUnreadQuery = html.querySelectorAll('[width="16"] img');

    final mailSubjectQuery = html.querySelectorAll('[rowspan="2"]');

    final mailIdQuery = html.querySelectorAll('[align="left"]');

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

    List<String> mailIdList = [];
    for (int i = 0; i < mailIdQuery.length; i++) {
      if (i == 18 || ((i - 18) % 14 == 0 && i != 4)) {
        mailIdList.add(mailIdQuery[i].outerHtml.split('e=')[1].split('&')[0]);
      }
    }

    for (int i = 0; i < mailAuthorsList.length; i++) {
      auxList.add(Mail(
          mailIdList[i],
          mailUnreadCheckList[i],
          mailAuthorsList[i],
          mailSubjectList[i],
          DateTime.parse('${mailDateList[i]} ${mailTimeList[i]}:00')));
    }
    return auxList;
  }

  static Future<List<String>> getMailText(String id) async {
    List<String> mailTextList = [];
    String data = await CITM.fetch('missatge.php', params: {
      "id_mensaje": id,
    });
    final html = parse(data);

    final mailTextQuery = html.querySelectorAll('.Arial11Black')[1].children;

    for (int i = 0; i < mailTextQuery.length; i++) {
      mailTextList.add(mailTextQuery[i].text);
    }

    return mailTextList;
  }

  static Future<void> sendMsg(
      {required String destinataris,
      required String assumpte,
      String text = '',
      context}) async {
    final uri = Uri.parse('https://citm.fundacioupc.com/missatges_envia.php');
    var msgParameters = {
      'norefrescar': '',
      'accion': 'normal',
      'prioridad': '1',
      'para_logins': destinataris,
      'para': '',
      'campus_selec': '',
      'id_origen': '',
      'usuario_origen': '',
      'titolmissatge': assumpte,
      'textmissatge': '<p>$text<p>',
    };

    debugPrint('$msgParameters');
    http.Response response = await http.post(
      uri,
      headers: {
        "Cookie": "PHPSESSID=$_sessionId",
      },
      body: msgParameters,
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missatge enviat correctament!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El missatge no s'ha pogut enviar!")),
      );
    }
  }

  static Future<List<CitmUser>> getCitmUsers() async {
    List<String> scrappedUsersList = [];
    List<String> auxList = [];
    List<CitmUser> finalUserList = [];
    String data = await CITM.fetch('directori.php', params: {});
    final html = parse(data);

    final usersTextQuery =
        html.querySelector('#cinta100')!.querySelectorAll('.Arial11Black');

    for (int i = 0; i < usersTextQuery.length; i++) {
      //filtrar tots els noms i treure parentesis final
      if (usersTextQuery[i].text.contains(',')) {
        scrappedUsersList.add(usersTextQuery[i]
            .text
            .substring(0, usersTextQuery[i].text.length - 1));
      }
    }

    //Eliminar repetits
    auxList = scrappedUsersList.toSet().toList();

    //Primer reordenem el nom i treiem la ',' després posem el username a partir del '('
    for (int i = 0; i < auxList.length; i++) {
      finalUserList.add(CitmUser(
          auxList[i].split('(')[0].split(', ')[1] +
              auxList[i].split('(')[0].split(', ')[0],
          auxList[i].split('(')[1]));
    }

    return finalUserList;
  }
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

class CitmUser {
  String fullname, username;
  CitmUser(this.fullname, this.username);
}

class Credentials {
  String username, password;
  Credentials(this.username, this.password);

  static Credentials getCredentials(
      {required String user, required String pass}) {
    Credentials credentials = Credentials(user, pass);

    return credentials;
  }
}
