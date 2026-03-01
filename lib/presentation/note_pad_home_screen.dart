import 'package:flutter/material.dart';
import 'package:notex_with_hive/models/note_model.dart';
import 'package:notex_with_hive/services/note_hive_service.dart';
import 'package:notex_with_hive/utils/animations.dart';
import 'package:notex_with_hive/utils/note_utils.dart';
import 'package:notex_with_hive/presentation/widgets/note_card.dart';
import 'package:notex_with_hive/presentation/widgets/add_note_dialog.dart';
import 'package:notex_with_hive/presentation/widgets/edit_note_dialog.dart';

class NotePadHomeScreen extends StatefulWidget {
  const NotePadHomeScreen({super.key});

  @override
  State<NotePadHomeScreen> createState() => _NotePadHomeScreenState();
}

class _NotePadHomeScreenState extends State<NotePadHomeScreen>
    with TickerProviderStateMixin {
  late NotePadAnimations _animations;
  late List<Note> notes;
  final TextEditingController _noteController = TextEditingController();
  final NoteHiveService _noteService = NoteHiveService();

  @override
  void initState() {
    super.initState();

    // Initialize Hive service
    _noteService.initialize();

    // Initialize animations
    _animations = NotePadAnimations();
    _animations.initializeAnimations(this);

    // Load notes from Hive
    notes = _noteService.fetchAllNotes();

    // Start animations
    _animations.startAnimations();
  }

  @override
  void dispose() {
    _animations.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        noteController: _noteController,
        onSave: () {
          final newNote = Note(
            title: NotePadUtils.extractTitle(_noteController.text),
            content: _noteController.text,
            color: NotePadUtils.getRandomColor(),
            date: DateTime.now(),
          );
          _noteService.addNote(newNote);
          setState(() {
            notes.insert(0, newNote);
          });
          _noteController.clear();
        
        },
        onCancel: () {
          _noteController.clear();
        },
      ),
    );
  }

  void _editNote(int index) {
    showDialog(
      context: context,
      builder: (context) => EditNoteDialog(
        initialContent: notes[index].content,
        onSave: (updatedContent) {
          final updatedNote = Note(
            title: NotePadUtils.extractTitle(updatedContent),
            content: updatedContent,
            color: notes[index].color,
            date: notes[index].date,
          );
          _noteService.updateNote(index, updatedNote);
          setState(() {
            notes[index] = updatedNote;
          });
        },
        onCancel: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'My Notes',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${notes.length} Notes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: notes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteCard(
                  note: notes[index],
                  index: index,
                  totalNotes: notes.length,
                  animation: _animations.getListItemAnimation(
                    index,
                    notes.length,
                  ),
                  onEdit: () => _editNote(index),
                  onDelete: () {
                    _noteService.deleteNote(index);
                    setState(() {
                      notes.removeAt(index);
                    });
                  },
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Viewing: ${notes[index].title}'),
                        duration: const Duration(milliseconds: 800),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: notes[index].color,
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: ScaleTransition(
        scale: _animations.fabScale,
        child: RotationTransition(
          turns: _animations.fabRotation,
          child: FloatingActionButton(
            onPressed: _addNote,
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.note_outlined,
              size: 50,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notes Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first note to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
