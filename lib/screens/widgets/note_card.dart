import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taker/logic/note_cubit.dart';
import 'package:note_taker/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final void Function() onEdit;

  const NoteCard({Key? key, required this.note, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.purple[50],
      child: ListTile(
        title: Text(note.text),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => context.read<NoteCubit>().deleteNote(note.id),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            )
          ],
        ),
      ),
    );
  }
}
