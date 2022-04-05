/*

Programa per obtenir l'HTML del campus del CITM en fitxer
---------------------------------------------------------
Per executar-lo:
1. Canviar les constants usuari i password.
2. Obrir un terminal a la carpeta "lib" i fer:
   > dart run console_fetch.dart "inici.php"
   La última part és el path de la pàgina que es vol guardar en fitxer.

*/

import 'dart:io';

import 'citm.dart';

const usuari = "pablofd";
const password = "TowardsZenMaster2022@@";

void main(List<String> args) async {
  if (args.isEmpty) {
    stderr.write("Usage: console_fetch <path>");
    exit(1);
  }
  CITM.init(usuari, password);
  final html = await CITM.fetch(args[0]);
  await File("${args[0]}.html").writeAsString(html);
}
