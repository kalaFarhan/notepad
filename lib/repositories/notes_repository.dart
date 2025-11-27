import 'package:hive/hive.dart';
import '../models/note.dart';

class NotesRepository {
  final Box notesBox;

  NotesRepository(this.notesBox);

  // CREATE
  Future<String> saveNote(Note note) async {
    final id = await notesBox.add(note.toMap());
    note = note.copyWith(id: id);
    await notesBox.put(id, note.toMap());
    return "Note berhasil disimpan!";
  }

  // READ
  List<Note> getAllNotes() {
    return notesBox.values
        .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // UPDATE
  Future<String> updateNote(Note note) async {
    try {
      if (note.id == null) return "Gagal: ID tidak ditemukan";
      await notesBox.put(note.id, note.toMap());
      return "Catatan berhasil diperbarui";
    } catch (e) {
      return "Gagal memperbarui catatan: $e";
    }
  }

  // DELETE
  Future<String> deleteNote(int id) async {
    if (notesBox.containsKey(id)) {
      await notesBox.delete(id);
      return "Note berhasil dihapus!";
    } else {
      return "Note dengan ID $id tidak ditemukan!";
    }
  }
}
