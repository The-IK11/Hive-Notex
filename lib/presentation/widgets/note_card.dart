import 'package:flutter/material.dart';
import 'package:notex_with_hive/models/note_model.dart';
import 'package:notex_with_hive/utils/note_utils.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  final int totalNotes;
  final Animation<Offset> animation;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const NoteCard({
    Key? key,
    required this.note,
    required this.index,
    required this.totalNotes,
    required this.animation,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SlideTransition(
        position: animation,
        child: GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            onEnter: (_) {
              // For hover effects on desktop
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: note.color.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Color indicator bar at top
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: note.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  // Note content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with delete button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                note.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: onDelete,
                              splashRadius: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Note content preview
                        Text(
                          note.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // Date
                        Text(
                          NotePadUtils.formatDate(note.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
