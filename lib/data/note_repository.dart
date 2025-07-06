import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taker/models/note_model.dart';

class NoteRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<Note>> getNotes() async {
    final userId = _auth.currentUser?.uid;
    final snapshot = await _firestore.collection('notes')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Note.fromDocument(doc)).toList();
  }

  Future<void> addNote(String text, String? title) async {
    final userId = _auth.currentUser?.uid;
    await _firestore.collection('notes').add({
      'text': text,
      'title': title,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String id, String text, String? title) async {
    await _firestore.collection('notes').doc(id).update({
      'text': text,
      'title': title,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
