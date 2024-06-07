import 'package:lesson53_todo/views/screens/home_screen.dart';
import 'package:lesson53_todo/views/screens/note_field.dart';

class AppRoute {
  static final routes = {
    RouteNames.home: (ctx) => const HomeScreen(),
    RouteNames.noteField: (ctx) => const NoteField(),
  };
}

class RouteNames {
  static const String home = "/";
  static const String noteField = "/note-field";
}
