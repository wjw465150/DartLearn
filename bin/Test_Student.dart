import 'dart:math';
import 'package:args/args.dart';
import 'package:student/student.dart';

void main(List<String> args) {
  Point point = Point(0, 0);
  print(point);

  var parser = ArgParser();
  var results = parser.parse(args);
  print(results.arguments);

  var student = Student('Wang');
  student.id = '060806110006';
  print(student);
}
