import 'package:flutter/material.dart';

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
    closeClasses = await CITM.getCloseClasses();
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
        decoration: const BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
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
            ),
            Expanded(
              child: loaded
                  ? Container(
                      child: closeClasses.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${closeClasses[index].time.day}/${closeClasses[index].time.month}/${closeClasses[index].time.year} - ${closeClasses[index].time.hour}:${closeClasses[index].time.minute == 0 ? '00' : closeClasses[index].time.minute}',
                                            style: const TextStyle(
                                                fontSize: 13, fontWeight: FontWeight.bold)),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(closeClasses[index].name,
                                            style: const TextStyle(fontSize: 15)),
                                      ]),
                                  subtitle: closeClasses[index].classroom.length <= 15
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(closeClasses[index].teacher,
                                                style: const TextStyle(fontSize: 13)),
                                            Text(closeClasses[index].classroom,
                                                style: const TextStyle(fontSize: 13)),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(closeClasses[index].teacher,
                                                style: const TextStyle(fontSize: 13)),
                                            Text(closeClasses[index].classroom,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                );
                              },
                              itemCount: closeClasses.length,
                            )
                          : const Center(child: Text('NO HI HAN PROPERES CLASSES!',style: TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold))),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
