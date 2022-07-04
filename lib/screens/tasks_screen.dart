import 'package:campus_app/atenea/api.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Course> coursesList = [];
  List<Assignment> assigmentsList = [];
  bool _loaded2 = false;

  getActiveCourses() async {
    Map<String, List<Course>> coursesAuxList = await getCourseList(135123);
    String year = DateTime.now().year.toString();
    String quadri =
        DateTime.now().month <= 7 && DateTime.now().month != 1 ? "P" : 'T';

    coursesAuxList.forEach((key, value) {
      if (key == year + quadri) {
        coursesList = value;
      }
    });
    getCloseAssigments();
  }

  getCloseAssigments() async {
    assigmentsList = await getAssignments(coursesList);
    setState(() {
      _loaded2 = true;
    });
  }

  @override
  void initState() {
    getActiveCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasques'),
      ),
      body: _loaded2
          ? ListView.builder(
              itemCount: assigmentsList.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 6,
                  child: ListTile(
                    title: Text(
                      assigmentsList[i].name,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      'Venciment: ${assigmentsList[i].due.day}/${assigmentsList[i].due.month} a les ${assigmentsList[i].due.hour}:${assigmentsList[i].due.minute}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              })
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
