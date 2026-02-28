import 'package:flutter/material.dart';

class Note {
  final String title;
  final String content;
  final int colorValue; // Store color as int
  final DateTime date;

  Note({
    required this.title,
    required this.content,
    required Color color,
    required this.date,
  }) : colorValue = color.value;

  // Getter to convert int back to Color
  Color get color => Color(colorValue);

  // Method to create a Note from JSON-like data
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'] as String,
      content: map['content'] as String,
      color: Color(map['colorValue'] as int? ?? Colors.blue.value),
      date: map['date'] is DateTime
          ? map['date'] as DateTime
          : DateTime.parse(map['date'] as String),
    );
  }

  // Method to convert Note to map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'colorValue': colorValue,
      'date': date.toIso8601String(),
    };
  }
}
