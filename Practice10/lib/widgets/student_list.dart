import 'package:flutter/material.dart';

import '../api/fake_api.dart';

class StudentList extends StatelessWidget {
  const StudentList({super.key, required this.students, this.compact = false});

  final List<Student> students;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        return ListTile(
          dense: compact,
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(student.name),
          subtitle: Text('${student.group} • GPA: ${student.gpa ?? '—'}'),
        );
      },
    );
  }
}
