import 'package:flutter/material.dart';
import 'package:lesson53_todo/models/note.dart';
import 'package:lesson53_todo/utils/extensions.dart';

class NoteField extends StatefulWidget {
  const NoteField({super.key});

  @override
  State<NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends State<NoteField> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> noteData = {};

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Navigator.pop(context, noteData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final note = ModalRoute.of(context)!.settings.arguments as Note?;
    if (note != null) {
      noteData = {
        "title": note.title,
        "subtitle": note.subtitle,
        "time": note.time,
      };
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          note == null ? "Add note" : "Edit note",
        ),
        actions: [
          IconButton(
            onPressed: submit,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              initialValue: noteData['title'],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Note Title",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter the note title";
                }

                return null;
              },
              onSaved: (value) {
                noteData['title'] = value;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: noteData['subtitle']?.toString(),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Note Subtitle",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter the note subtitle";
                }

                return null;
              },
              onSaved: (value) {
                noteData['subtitle'] = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  noteData['time'] ?? "Date not selected",
                ),
                TextButton(
                  onPressed: () async {
                    final response = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                      initialDate: DateTime.now(),
                    );

                    if (response != null) {
                      noteData['time'] = response.format();
                      setState(() {});
                    }
                  },
                  child: const Text("Select Date"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
