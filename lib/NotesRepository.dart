import 'Note.dart';

class NotesRepository {
  static List<Note> _notes = [];

  static Future<List<Note>> getNotes() async {
    // Simulate a delay
    await Future.delayed(Duration(seconds: 1));
    return List.from(_notes);
  }

  static Future<void> insert({required Note note}) async {
    note.id = _notes.length + 1;
    _notes.add(note);
  }

  static Future<void> update({required Note note}) async {
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
    }
  }

  static Future<void> delete({required Note note}) async {
    _notes.removeWhere((n) => n.id == note.id);
  }
}
