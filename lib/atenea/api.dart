import 'dart:convert';
import 'package:http/http.dart' as http;

class Moodle {
  static String userToken = "02254ae7f5688e1f4a51819c30619d14";
  static String host = "atenea.upc.edu";

  static Future apiGet<T>(String function, Map<String, dynamic> args) async {
    final uri = Uri(
      scheme: "https",
      host: host,
      path: "/webservice/rest/server.php",
      queryParameters: {
        "wstoken": userToken,
        "wsfunction": function,
        "moodlewsrestformat": "json",
        ...args
      },
    );
    final response = await http.get(uri);

    return jsonDecode(response.body);
  }
}

DateTime fromEpoch(int moodleEpoch) {
  return DateTime.fromMillisecondsSinceEpoch(moodleEpoch * 1000);
}

final semesterRegexp = RegExp(r'([0-9]{4})\/[0-9]{2}-0([12]):');

class Course {
  int id;
  String shortname, fullname;
  DateTime startDate;
  int enrolled;

  Course.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        shortname = json['shortname'],
        fullname = json['fullname'],
        startDate =
            DateTime.fromMillisecondsSinceEpoch(json['startdate'] * 1000),
        enrolled = json['enrolledusercount'];

  String get semesterId {
    final match = semesterRegexp.firstMatch(shortname);
    if (match == null) {
      return "<unknown>";
    }
    final year = int.parse(match.group(1)!);
    final semid = match.group(2);
    return semid == "1" ? "${year}T" : "${year + 1}P";
  }

  int get code => int.parse(fullname.substring(0, 6));
}

Future<Map<String, List<Course>>> getCourseList(int userid) async {
  final List jsonCourseList = await Moodle.apiGet(
    "core_enrol_get_users_courses",
    {"userid": "$userid"},
  );

  Map<String, List<Course>> courses = {};
  for (final jsonCourse in jsonCourseList) {
    final course = Course.fromJson(jsonCourse);
    final key = course.semesterId;
    courses.putIfAbsent(key, () => []);
    courses[key]!.add(course);
  }
  return courses;
}

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

Future<List<Assignment>> getAssignments(List<Course> activeCourses) async {
  Map<String, dynamic> coursesIds = {};
  for (int i = 0; i < activeCourses.length; i++) {
    coursesIds["courseids[$i]"] = activeCourses[i].id.toString();
  }
  final Map<String, dynamic> json = await Moodle.apiGet(
    "mod_assign_get_assignments",
    coursesIds,
  );
  List<Assignment> assignments = [];
  for (int i=0; i<activeCourses.length;i++) {
    for (final assignJson in json['courses'][i]['assignments']) {
    assignments.add(Assignment.fromJson(assignJson));
  }
  }

  assignments.sort((a, b) => b.due.compareTo(a.due));
  return assignments;
}