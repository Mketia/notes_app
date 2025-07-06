import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taker/data/note_repository.dart';
import 'package:note_taker/logic/note_cubit.dart';
import 'package:note_taker/screens/login_screen.dart';

import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NoteCubit(NoteRepository()),
        )
      ],
      child: MaterialApp(
        title: 'Notes App',
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}