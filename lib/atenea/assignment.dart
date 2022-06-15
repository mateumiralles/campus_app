import 'api.dart';

class Assignment {
  int id;
  int courseid;
  String name;
  DateTime due;

  Assignment.fromJson(Map<String, dynamic> json)
      : id = json['cmid'],
        courseid = json['course'],
        due = DateTime.fromMillisecondsSinceEpoch(json['duedate'] * 1000),
        name = json['name'];
}

Future<List<Assignment>> getAssignments(int courseid /* List<int> courseIdList */) async {
  final Map<String, dynamic> json = await Moodle.apiGet(
    "mod_assign_get_assignments",
    // TODO: Afegir tots els ids dels cursos aquí
    {"courseids[0]": "$courseid"},
  );
  List<Assignment> assignments = [];
  // TODO: Extreure de cada curs els assignments
  for (final assignJson in json['courses'][0]['assignments']) {
    assignments.add(Assignment.fromJson(assignJson));
  }
  assignments.sort((a, b) => a.due.compareTo(b.due));
  return assignments;
}
