import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final String? title;
  final DateTime timestamp;

  Note({
    required this.id,
    required this.text,
    this.title,
    required this.timestamp,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      text: data['text'] ?? '',
      title: data['title'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}