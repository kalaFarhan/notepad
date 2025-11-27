import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../blocs/notes_list_bloc/notes_list_bloc.dart';
import '../repositories/notes_repository.dart';

class NoteFormScreen extends StatelessWidget {
  const NoteFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteCubit = context.read<NoteFormCubit>();
    final notesRepo = context.read<NotesRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Judul'),
              onChanged: noteCubit.updateTitle,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Isi'),
              onChanged: noteCubit.updateContent,
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final note = noteCubit.state;
                await notesRepo.saveNote(note);

                // setelah menyimpan, reload daftar catatan
                context.read<NotesListBloc>().add(LoadNotes());

                Navigator.pop(context); // kembali ke list
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
