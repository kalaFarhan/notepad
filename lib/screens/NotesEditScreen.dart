import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../blocs/notes_list_bloc/notes_list_bloc.dart';
import '../repositories/notes_repository.dart';
import '../models/note.dart';

class NoteEditScreen extends StatelessWidget {
  const NoteEditScreen({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final noteCubit = context.read<NoteFormCubit>()..setNote(note);
    final notesRepo = context.read<NotesRepository>();

    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
              onChanged: noteCubit.updateTitle,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Isi'),
              onChanged: noteCubit.updateContent,
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final updatedNote = noteCubit.state;
                final result = await notesRepo.updateNote(updatedNote);

                // Refresh list
                context.read<NotesListBloc>().add(LoadNotes());

                // Tampilkan notifikasi
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );

                Navigator.pop(context);
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
