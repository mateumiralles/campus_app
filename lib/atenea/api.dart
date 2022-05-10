import 'dart:convert';

import 'package:http/http.dart' as http;

class Moodle {
  static String userToken = "49befd892ca0c963ab6ba55ce3b7513e";
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
    //print(response.body);
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
  int? groupid;

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
  print(courses.values.first[0].fullname);
  return courses;
}

void main() {
  //Moodle.apiGet("core_enrol_get_users_courses", {"userid": "135123"});
  getCourseList(135123);
}
