import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

final phpSessionRegexp = RegExp(r"PHPSESSID=([^;]*)");

final loginUri = Uri.parse("https://citm.fundacioupc.com/index.php?next=");

const formDataHeaders = {
  "Content-Type": "application/x-www-form-urlencoded",
};

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

/*

postTest() async {
    final uri = 'https://na57.salesforce.com/services/oauth2/token';
    var requestBody = {
      'grant_type':'password',
      'client_id':'3MVG9dZJodJWITSviqdj3EnW.LrZ81MbuGBqgIxxxdD6u7Mru2NOEs8bHFoFyNw_nVKPhlF2EzDbNYI0rphQL',
      'client_secret':'42E131F37E4E05313646E1ED1D3788D76192EBECA7486D15BDDB8408B9726B42',
      'username':'example@mail.com.us',
      'password':'ABC1234563Af88jesKxPLVirJRW8wXvj3D'
    };

    http.Response response = await http.post(
        uri,
        body: requestBody,
    );

    print(response.body);
  }
*/

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
    final response = await http.post(loginUri, headers: formDataHeaders, body: credentials);
    if (response.statusCode != 302) {
      // they use a redirect to the initial page (inici.php)
      throw "Couldn't login (status ${response.statusCode}).";
    }
    _sessionId = extractSessionID(response.headers);
  }

  static Future<String> fetch(String path, {Map<String, dynamic>? params}) async {
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

  static Future<int> mailsPageCount({required String folder}) async {
    String numFolder = folder == 'Received' ? '0' : '1';

    String data = await CITM.fetch('missatges_llistat.php', params: {"carpeta_actual": numFolder});

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
      if (mailUnreadQuery[j].attributes.toString().split('.')[0].split('_')[1].trim() == 'tancat') {
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
      auxList.add(Mail(mailIdList[i], mailUnreadCheckList[i], mailAuthorsList[i],
          mailSubjectList[i], DateTime.parse('${mailDateList[i]} ${mailTimeList[i]}:00')));
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

  static Future<void> sendMsg({required String destinataris, required String assumpte, String text=''}) async {
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
    if (response.statusCode == 201) {
      debugPrint('Missatge Enivat!');
    } else {
      debugPrint("El missatge no s'ha enviat");
    }
  }

  static Future<List<String>> getMailUsers() async {
    List<String> usersList = [];
    String data = await CITM.fetch('directori.php', params: {});
    final html = parse(data);

    final usersTextQuery = html.querySelector('#cinta100')!.querySelectorAll('.Arial11Black');

    for (int i = 0; i < usersTextQuery.length; i++) {
      debugPrint(usersTextQuery[i].text);
      usersList.add(usersTextQuery[i].text);
    }

    return usersList;
  }
}
