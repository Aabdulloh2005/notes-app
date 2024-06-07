import 'package:lesson53_todo/utils/extensions.dart';

class Note {
  int id;
  String title;
  String subtitle;
  String time;

  Note({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'].toString(),
      subtitle: map['subtitle'].toString(),
      time: map['time'],
    );
  }
}
