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
}
