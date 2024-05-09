import 'package:flutter/material.dart';
import 'package:hive_sample2/models/note.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class NoteDataBase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initalize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  final List<Note> currentNotes = [];

  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;

    await isar.writeTxn(() => isar.notes.put(newNote));

    fetchedNotes();
  }

  Future<void> fetchedNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  Future<void> updateNote(int id, String newText) async {
    final extistingNote = await isar.notes.get(id);
    if (extistingNote != null) {
      extistingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(extistingNote));
      await fetchedNotes();
    }
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchedNotes();
  }
}
