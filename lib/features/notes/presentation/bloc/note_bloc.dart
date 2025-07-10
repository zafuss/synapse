import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_notes.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/update_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/search_notes.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetAllNotes getAllNotes;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final SearchNotes searchNotes;

  NoteBloc({
    required this.getAllNotes,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
    required this.searchNotes,
  }) : super(const NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SearchNotesEvent>(_onSearchNotes);
    on<ClearSearchEvent>(_onClearSearch);
    // Các event khác có thể bổ sung sau
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(const NoteLoading());
    final result = await getAllNotes();
    result.when(
      success: (notes) => emit(NotesLoaded(notes: notes)),
      failure: (error) => emit(NoteError(error.message)),
    );
  }

  Future<void> _onCreateNote(
    CreateNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteLoading());
    final result = await createNote(
      title: event.title,
      content: event.content,
      isMarkdown: event.isMarkdown,
      tags: event.tags,
    );
    result.when(
      success: (note) async {
        add(const LoadNotes());
        emit(NoteCreated(note));
      },
      failure: (error) => emit(NoteError(error.message)),
    );
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteLoading());
    final result = await updateNote(
      id: event.id,
      title: event.title,
      content: event.content,
      isMarkdown: event.isMarkdown,
      tags: event.tags,
    );
    result.when(
      success: (note) async {
        add(const LoadNotes());
        emit(NoteUpdated(note));
      },
      failure: (error) => emit(NoteError(error.message)),
    );
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteLoading());
    final result = await deleteNote(event.id);
    result.when(
      success: (_) async {
        add(const LoadNotes());
        emit(NoteDeleted(event.id));
      },
      failure: (error) => emit(NoteError(error.message)),
    );
  }

  Future<void> _onSearchNotes(
    SearchNotesEvent event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteLoading());
    final result = await searchNotes(event.query);
    result.when(
      success: (notes) =>
          emit(NotesLoaded(notes: notes, searchQuery: event.query)),
      failure: (error) => emit(NoteError(error.message)),
    );
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<NoteState> emit) {
    add(const LoadNotes());
  }
}
