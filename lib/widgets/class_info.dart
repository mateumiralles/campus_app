import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../citm.dart';

class ClassInfo extends StatefulWidget {
  const ClassInfo({Key? key}) : super(key: key);

  @override
  State<ClassInfo> createState() => _ClassInfoState();
}

class _ClassInfoState extends State<ClassInfo> {
  List<NextClass> closeClasses = [];
  bool loaded = false;

  getDataClasses() async {
    List<String> classesInfoList = [];
    String data = await CITM.fetch('/inici.php');

    closeClasses.clear(); //restart list

    final html = parse(data);

    final classesTableQuery = html.querySelectorAll(
        'html > body > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td > table > tbody');
    if (classesTableQuery.isNotEmpty) {
      final classesTableQuery0 = classesTableQuery[0];
      final classesNameQuery = html.querySelectorAll(
          'html > body > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td.Arial11Black > a ');

      for (int i = 1; i < classesTableQuery0.nodes.length; i++) {
        if (classesTableQuery0.nodes[i].text.toString().trim() != "") {
          classesInfoList.add(classesTableQuery0.nodes[i].text.toString().trim());
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

        closeClasses.add(NextClass(DateTime.parse('$year-$month-$day $time:00'), teacherName, className, classroom));
      }
      debugPrint('NumClasses: ${closeClasses.length}');
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: const Center(
                child: Text(
                  "PRÒXIMES CLASSES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
            ),
            Expanded(
              child: loaded
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${closeClasses[index].time.day}/${closeClasses[index].time.month}/${closeClasses[index].time.year} - ${closeClasses[index].time.hour}:${closeClasses[index].time.minute == 0 ? '00' : closeClasses[index].time.minute}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(closeClasses[index].name, style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                          subtitle: closeClasses[index].classroom.length <= 15
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(closeClasses[index].teacher, style: const TextStyle(fontSize: 13)),
                                    Text(closeClasses[index].classroom, style: const TextStyle(fontSize: 13)),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(closeClasses[index].teacher, style: const TextStyle(fontSize: 13)),
                                    Text(closeClasses[index].classroom,
                                        textAlign: TextAlign.end, style: const TextStyle(fontSize: 13)),
                                  ],
                                ),
                        );
                      },
                      itemCount: closeClasses.length,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
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
