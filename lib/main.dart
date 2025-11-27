import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trego_notepad/repositories/notes_repository.dart';
import 'package:trego_notepad/screens/NotesListScreen.dart';
import 'blocs/notes_list_bloc/notes_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // ✅ Buka box terlebih dahulu sebelum digunakan
  await Hive.openBox('notesbox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NotesRepository(Hive.box('notesbox')),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            NotesListBloc(context.read<NotesRepository>())..add(LoadNotes()),
          ),
        ],
        child: MaterialApp(
          title: 'Notes App',
          home: const NotesListScreen(),
        ),
      ),
    );
  }
}
