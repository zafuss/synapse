import '../../../../core/utils/result.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

/// Use case for getting all notes
class GetAllNotes {
  final NoteRepository repository;

  const GetAllNotes(this.repository);

  /// Execute the use case
  Future<Result<List<Note>>> call() async {
    return repository.getAllNotes();
  }
}
