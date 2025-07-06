import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taker/logic/note_cubit.dart';
import 'package:note_taker/models/note_model.dart';
class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isEditing = false;

  final Color themeColor = Color(0xFF6A1B9A);
  final Color backgroundColor = Color(0xFFF3E5F5);

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note?.title ?? '';
    _bodyController.text = widget.note?.text ?? '';
    _isEditing = widget.note == null;
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final text = _bodyController.text.trim();
    if (text.isEmpty) return;

    if (widget.note == null) {
      await context.read<NoteCubit>().addNote(text, title);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note added!")),
      );
    } else {
      await context.read<NoteCubit>().updateNote(widget.note!.id, text, title);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note updated!")),
      );
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          widget.note == null ? 'Add Note' : (_isEditing ? 'Edit Note' : 'View Note'),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (!_isEditing && widget.note != null)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _saveNote,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                readOnly: !_isEditing,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Start typing your note...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 