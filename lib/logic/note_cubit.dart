// note_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:note_taker/data/note_repository.dart';
import 'package:note_taker/models/note_model.dart';


abstract class NoteState {}

class NoteInitial extends NoteState {}
class NoteLoading extends NoteState {}
class NoteLoaded extends NoteState {
  final List<Note> notes;
  NoteLoaded(this.notes);
}
class NoteFiltered extends NoteState {
  final List<Note> filteredNotes;
  NoteFiltered(this.filteredNotes);
}
class NoteGrouped extends NoteState {
  final Map<String, List<Note>> groupedNotes;
  NoteGrouped(this.groupedNotes);
}
class NoteError extends NoteState {
  final String message;
  NoteError(this.message);
}

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepository;
  List<Note> _allNotes = [];

  NoteCubit(this.noteRepository) : super(NoteInitial());

  Future<void> fetchNotes() async {
    emit(NoteLoading());
    try {
      _allNotes = await noteRepository.getNotes();
      emit(NoteLoaded(_allNotes));
    } catch (e) {
      emit(NoteError("Failed to load notes"));
    }
  }

  void filterNotes(String query) {
    final filtered = _allNotes.where((note) =>
      (note.title ?? '').toLowerCase().contains(query.toLowerCase())).toList();
    emit(NoteFiltered(filtered));
  }

  void groupNotesByDate() {
    final grouped = groupBy(_allNotes, (Note note) {
      return DateFormat('yyyy-MM-dd').format(note.timestamp);
    });
    emit(NoteGrouped(grouped));
  }

  Future<void> addNote(String text, String? title) async {
    try {
      await noteRepository.addNote(text, title);
      _allNotes = await noteRepository.getNotes();
      emit(NoteLoaded(_allNotes));
    } catch (e) {
      emit(NoteError("Failed to add note"));
    }
  }

  Future<void> updateNote(String id, String text, String? title) async {
    try {
      await noteRepository.updateNote(id, text, title);
      _allNotes = await noteRepository.getNotes();
      emit(NoteLoaded(_allNotes));
    } catch (e) {
      emit(NoteError("Failed to update note"));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await noteRepository.deleteNote(id);
      _allNotes = await noteRepository.getNotes();
      emit(NoteLoaded(_allNotes));
    } catch (e) {
      emit(NoteError("Failed to delete note"));
    }
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inSeconds < 60) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays == 1) return 'yesterday';
    return DateFormat('MMM d, yyyy').format(timestamp);
  }
}
