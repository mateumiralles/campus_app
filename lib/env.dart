import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  String username, password;
  Env(this.username, this.password);
}

Future<Env> readEnvFile() async {
  await dotenv.load(fileName: ".env");
  if (!dotenv.env.containsKey('username')) {
    throw "No he trobat 'username' al fitxer .env";
  }
  if (!dotenv.env.containsKey("password")) {
    throw "No he trobat 'password' al fitxer .env";
  }
  return Env(dotenv.env['username']!, dotenv.env['password']!);
}
