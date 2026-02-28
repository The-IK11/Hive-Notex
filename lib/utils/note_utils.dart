import 'package:flutter/material.dart';

/// Utilities class for helper functions
class NotePadUtils {
  /// Get a random color from the predefined color palette
  static Color getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];
    colors.shuffle();
    return colors.first;
  }

  /// Format date to readable string
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final noteDate = DateTime(date.year, date.month, date.day);

    if (noteDate == today) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (noteDate == yesterday) {
      return 'Yesterday at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  /// Validate if note content is not empty
  static bool isValidNote(String content) {
    return content.trim().isNotEmpty;
  }

  /// Extract title from content (first line)
  static String extractTitle(String content) {
    return content.split('\n').first;
  }
}
