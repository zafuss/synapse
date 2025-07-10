import '../../../../core/utils/result.dart';
import '../../../../core/errors/app_exception.dart';
import '../repositories/note_repository.dart';

/// Use case for deleting a note
class DeleteNote {
  final NoteRepository repository;

  const DeleteNote(this.repository);

  /// Execute the use case
  Future<Result<void>> call(String id) async {
    // Check if note exists
    final existsResult = await repository.noteExists(id);

    return existsResult.when(
      success: (exists) async {
        if (!exists) {
          return const Failure(ValidationException('Note not found'));
        }

        // Delete the note
        return repository.deleteNote(id);
      },
      failure: (exception) => Failure(exception),
    );
  }
}
