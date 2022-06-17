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
  bool _loaded = false;
  bool _loaded2 = false;

  getActiveCourses() async {
    Map<String, List<Course>> coursesAuxList = await getCourseList(135123);
    String year = DateTime.now().year.toString();
    String quadri = DateTime.now().month <= 7 && DateTime.now().month!=1 ? "P" : 'T';
    
    coursesAuxList.forEach((key, value) {
      if (key == year + quadri) {
        coursesList = value;
      }
        setState(() {
          _loaded = true;
        });
    });
  }

  getCloseAssigments() async {
      assigmentsList = await getAssignments(coursesList);
   setState(() {
          _loaded2 = true;
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TASQUES'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(children: [ElevatedButton(
                onPressed: () => {getActiveCourses()},
                child: const Text('BUSCAR CURSOS')),
            Expanded(
              flex: 1,
              child: _loaded
                  ? ListView.builder(
                      itemCount: coursesList.length,
                      itemBuilder: (context, i) {
                        return ListTile(title: Text(coursesList[i].fullname, textAlign: TextAlign.center,));
                      })
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),]),
          ),
          Expanded(
            child: Column(children: [ElevatedButton(
                onPressed: () => {getCloseAssigments()},
                child: const Text('BUSCAR TAREAS')),
            Expanded(
              flex: 1,
              child: _loaded2
                  ? ListView.builder(
                      itemCount: assigmentsList.length,
                      itemBuilder: (context, i) {
                        return ListTile(title: Center(child: Text(assigmentsList[i].name, textAlign: TextAlign.center,)));
                      })
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),]),
          ),
          
        ],
      ),
    );
  }
}
