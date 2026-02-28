import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final int colorValue; // Store color as int

  @HiveField(3)
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
