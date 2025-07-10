import '../../../../core/utils/result.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

/// Use case for searching notes
class SearchNotes {
  final NoteRepository repository;

  const SearchNotes(this.repository);

  /// Execute the use case
  Future<Result<List<Note>>> call(String query) async {
    // Validate input
    if (query.trim().isEmpty) {
      return const Success([]);
    }

    if (query.length < 2) {
      return const Success([]);
    }

    // Search notes
    return repository.searchNotes(query.trim());
  }
}
