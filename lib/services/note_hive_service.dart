import 'package:hive/hive.dart';
import 'package:notex_with_hive/models/note_model.dart';

/// Service class for managing all Hive database operations
class NoteHiveService {
  late Box<Note> _noteBox;

  /// Initialize the Hive service
  void initialize() {
    _noteBox = Hive.box<Note>('notes');
  }

  /// Add a new note to Hive
  Future<void> addNote(Note note) async {
    await _noteBox.add(note);
  }

  /// Delete a note from Hive by index
  Future<void> deleteNote(int index) async {
    await _noteBox.deleteAt(index);
  }

  /// Update a note in Hive by index
  Future<void> updateNote(int index, Note updatedNote) async {
    await _noteBox.putAt(index, updatedNote);
  }

  /// Fetch all notes from Hive
  List<Note> fetchAllNotes() {
    return _noteBox.values.toList().cast<Note>();
  }

  /// Read a specific note from Hive by index
  Note? readNote(int index) {
    try {
      return _noteBox.getAt(index);
    } catch (e) {
      return null;
    }
  }

  /// Clear all notes from Hive
  Future<void> clearAllNotes() async {
    await _noteBox.clear();
  }

  /// Get the total count of notes
  int getNoteCount() {
    return _noteBox.length;
  }

  /// Check if notes list is empty
  bool isEmpty() {
    return _noteBox.isEmpty;
  }
}
