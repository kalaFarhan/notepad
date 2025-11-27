
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/note.dart';
import '../../repositories/notes_repository.dart';
/*
part 'notes_list_event.dart';
part 'notes_list_state.dart';
// State
part of 'notes_list_bloc.dart';*/
abstract class NotesListState extends Equatable {
  const NotesListState();
  @override
  List<Object> get props => [];
}
class NotesListLoading extends NotesListState {}
class NotesListLoaded extends NotesListState {
  final List<Note> notes;
  const NotesListLoaded(this.notes);
  @override
  List<Object> get props => [notes];
}

// Event
abstract class NotesListEvent extends Equatable {
  const NotesListEvent();
  @override
  List<Object> get props => [];
}
class LoadNotes extends NotesListEvent {}


class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  final NotesRepository notesRepository;

  NotesListBloc(this.notesRepository) : super(NotesListLoading()) {
    on<LoadNotes>((event, emit) {
      final notes = notesRepository.getAllNotes();
      emit(NotesListLoaded(notes));
    });
  }
}