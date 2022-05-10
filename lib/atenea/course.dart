import 'api.dart';

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
  return courses;
}
