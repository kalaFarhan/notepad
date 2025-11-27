import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../blocs/notes_list_bloc/notes_list_bloc.dart';
import 'NotesEditScreen.dart';
import 'NotesFormScreen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesRepository = context.read<NotesListBloc>().notesRepository;

    return Scaffold(
      appBar: AppBar(title: const Text('Fanta Notepad')),
      body: BlocBuilder<NotesListBloc, NotesListState>(
        builder: (context, state) {
          if (state is NotesListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesListLoaded) {
            final notes = state.notes;

            if (notes.isEmpty) {
              return const Center(child: Text('Belum ada catatan.'));
            }

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(
                      note.title.isEmpty ? '(Tanpa Judul)' : note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.content.isEmpty ? '(Tidak ada isi)' : note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(create: (_) => NoteFormCubit()..setNote(note)),
                              BlocProvider.value(value: context.read<NotesListBloc>()),
                            ],
                            child: NoteEditScreen(note: note),
                          ),
                        ),
                      );

                      context.read<NotesListBloc>().add(LoadNotes());
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        // Konfirmasi hapus
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Catatan'),
                            content: const Text('Yakin ingin menghapus catatan ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final result =
                          await notesRepository.deleteNote(note.id ?? -1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result)),
                          );
                          // Refresh list
                          context.read<NotesListBloc>().add(LoadNotes());
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Terjadi kesalahan.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke halaman buat catatan baru
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => NoteFormCubit(),
                child: const NoteFormScreen(),
              ),
            ),
          );

          // Refresh list setelah kembali
          context.read<NotesListBloc>().add(LoadNotes());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
