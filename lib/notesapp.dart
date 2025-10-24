import 'package:flutter/material.dart';
import 'package:flutter_application_1/databasehelper.dart';
// 👈 apni helper file ka import

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  final dbHelper = DatabaseHelper.instance;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  List<Map<String, dynamic>> notes = [];

  // void fetchNotes() async {
  //   final data = await dbHelper.getNotes();
  //   setState(() {
  //     notes = data;
  //   });
  //   print(notes);
  // }

Future<void> fetchNotes() async {
  final data = await dbHelper.getNotes();
  setState(() {
    notes = data;
  });
  print("Fetched Notes: $notes"); // 👈 ye confirm karega DB se kya aa raha hai
}
  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  // void addNote() async {
  //   await dbHelper.insertNote(titleController.text, contentController.text);
  //   titleController.clear();
  //   contentController.clear();
  //   fetchNotes();
  //   print(notes);
  // }

  void addNote() async {
  if (titleController.text.isEmpty || contentController.text.isEmpty) return;

  await dbHelper.insertNote(titleController.text, contentController.text);

  titleController.clear();
  contentController.clear();

  await fetchNotes(); // wait for updated data
}

  void deleteNote(int id) async {
    await dbHelper.deleteNote(id);
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Notes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
                ElevatedButton(
                  onPressed: addNote,
                  child: const Text("Add Note"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['content']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteNote(note['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
