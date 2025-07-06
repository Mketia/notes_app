import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taker/logic/note_cubit.dart';
import 'note_editor_screen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().fetchNotes();
    _searchController.addListener(() {
      context.read<NoteCubit>().filterNotes(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF00695C); // Deep teal
    final backgroundColor = Color(0xFFE0F2F1); // Soft mint green
    final tileColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text('Your Notes', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title...',
                filled: true,
                fillColor: tileColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: themeColor),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return Center(child: CircularProgressIndicator(color: themeColor));
          } else if (state is NoteLoaded) {
            if (state.notes.isEmpty) {
              return Center(child: Text('Nothing here yet—tap ➕ to add a note.'));
            }
            final cubit = context.read<NoteCubit>();
            return ListView.separated(
              itemCount: state.notes.length,
              separatorBuilder: (context, index) =>
                  Divider(thickness: 1, height: 1, color: Colors.grey[300]),
              itemBuilder: (ctx, index) {
                final note = state.notes[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(
                      note.title ?? 'Untitled',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(note.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 6),
                        Text(
                          cubit.formatTimestamp(note.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<NoteCubit>().deleteNote(note.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Note deleted!")),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteEditorScreen(note: note),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return Center(child: Text('Unexpected state: ${state.runtimeType}'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoteEditorScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
