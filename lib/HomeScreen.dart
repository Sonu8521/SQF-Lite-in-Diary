import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Note.dart';
import 'NotesRepository.dart';
import 'AddNoteScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await NotesRepository.getNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
      ),
      body: _notes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            leading: Image.network(
              'https://www.shutterstock.com/image-vector/may-31-vector-flat-daily-260nw-393566650.jpg', // Replace with your image URL
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Show error icon if image fails to load
              },
            ),
            title: Text(note.title),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  note.formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNoteScreen(note: note),
                ),
              );
              if (result == true) {
                _loadNotes();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(),
            ),
          );
          if (result == true) {
            _loadNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
