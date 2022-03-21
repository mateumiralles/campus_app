import 'package:http/http.dart' as http;
import 'dart:io';

void citmFetch() async {
  const filename = 'login_citm.html';
  const filename2 = 'msg_citm.html';

  Future<String> homeFetch() async {
    var url = 'https://citm.fundacioupc.com/inici.php';
    var headers = {"Cookie": "PHPSESSID=c4hd53fpp3s6u09gf5dsq541tv"};

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final htmlCitm = response.body.toString();
      return htmlCitm;
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<String> msgFetch() async {
    var url = 'https://citm.fundacioupc.com/missatges_llistat.php';
    var headers = {"Cookie": "PHPSESSID=c4hd53fpp3s6u09gf5dsq541tv"};

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final htmlCitm = response.body.toString();
      return htmlCitm;
    } else {
      throw Exception('Failed to load data!');
    }
  }

  final homeResponse = await homeFetch();
  File('../assets/$filename').writeAsString(homeResponse);

  final msgResponse = await msgFetch();
  File('../assets/$filename2').writeAsString(msgResponse);
}

void main() async {
  citmFetch();
  // Do something with the file.
}
