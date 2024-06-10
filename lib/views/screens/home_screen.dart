import 'package:flutter/material.dart';
import 'package:lesson53_todo/models/note.dart';
import 'package:lesson53_todo/utils/routes.dart';
import 'package:lesson53_todo/viewmodels/note_viewmodel.dart';
import 'package:lesson53_todo/views/widgets/note_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final noteViewModel = NotesController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
  }

  void addNote() async {
    final response = await Navigator.pushNamed(
      context,
      RouteNames.noteField,
    );

    if (response != null) {
      await noteViewModel.addNote(
        (response as Map)['title'],
        response['subtitle'],
        response['time'],
      );
      setState(() {});
    }
  }

  void editNote(Note note) async {
    final response = await Navigator.pushNamed(
      context,
      RouteNames.noteField,
      arguments: note,
    );

    if (response != null) {
      await noteViewModel.editNote(
        note.id,
        (response as Map)['title'],
        response['subtitle'],
        response['time'],
      );
      setState(() {});
    }
  }

  void deleteNote(Note note) async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: Text("You are about to delete ${note.title}."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Yes, delete"),
            ),
          ],
        );
      },
    );

    if (response == true) {
      await noteViewModel.deleteNote(note.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: FutureBuilder(
        future: noteViewModel.notesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final notes = snapshot.data;
          return notes == null || notes.isEmpty
              ? const Center(
                  child: Text("No notes available."),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: notes.length,
                  itemBuilder: (ctx, index) {
                    return NoteWidget(
                      note: notes[index],
                      onEdit: () {
                        editNote(notes[index]);
                      },
                      onDelete: () {
                        deleteNote(notes[index]);
                      },
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: addNote,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
