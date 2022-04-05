import 'package:http/http.dart' as http;

Future<String> fetch({required String url}) async {
      var headers = {"Cookie": "PHPSESSID=t65nt3udd56lt73a8fqesma27n"};

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final htmlCitm = response.body.toString();
        return htmlCitm;
      } else {
        throw Exception('Failed to load data!');
      }
    }








