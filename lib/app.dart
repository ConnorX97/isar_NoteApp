import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_sample2/components/drawer.dart';
import 'package:hive_sample2/components/note_tile.dart';
import 'package:hive_sample2/models/note.dart';
import 'package:hive_sample2/models/note_database.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create"),
        backgroundColor: Theme.of(context).colorScheme.background,
        content: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              cursorColor: Theme.of(context).colorScheme.inversePrimary,
              keyboardType: TextInputType.multiline,
              controller: textController,
              decoration: InputDecoration(
                hintText: "New note",
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NoteDataBase>().addNote(textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }

  void readNotes() {
    context.read<NoteDataBase>().fetchedNotes();
  }

  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Note"),
        content: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              cursorColor: Theme.of(context).colorScheme.inversePrimary,
              keyboardType: TextInputType.multiline,
              controller: textController,
              decoration: InputDecoration(
                hintText: "Edit note",
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<NoteDataBase>()
                  .updateNote(note.id, textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void deleteNote(int id) {
    context.read<NoteDataBase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDataBase = context.watch<NoteDataBase>();

    List<Note> currentNotes = noteDataBase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "Notes",
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                final note = currentNotes[index];
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note),
                  onDeletePressed: () => deleteNote(note.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
