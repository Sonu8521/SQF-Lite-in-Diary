import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Note.dart';
import 'NotesRepository.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showDeleteDialog(context),
            ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: widget.note == null ? _insertNote : _updateNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Start typing here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNote();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _insertNote() async {
    try {
      final note = Note(
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
      );
      await NotesRepository.insert(note: note);
      print('Note inserted: $note');  // Debug print
      Navigator.pop(context, true); // Indicate success
    } catch (e) {
      print('Error inserting note: $e');
    }
  }

  void _updateNote() async {
    try {
      final note = Note(
        id: widget.note!.id!,
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: widget.note!.createdAt,
      );
      await NotesRepository.update(note: note);
      print('Note updated: $note');  // Debug print
      Navigator.pop(context, true); // Indicate success
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  void _deleteNote() async {
    try {
      await NotesRepository.delete(note: widget.note!);
      print('Note deleted: ${widget.note}');  // Debug print
      Navigator.pop(context, true); // Indicate success
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}
