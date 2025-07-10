import '../../../../core/utils/result.dart';
import '../../../../core/errors/app_exception.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

/// Use case for updating an existing note
class UpdateNote {
  final NoteRepository repository;

  const UpdateNote(this.repository);

  /// Execute the use case
  Future<Result<Note>> call({
    required String id,
    String? title,
    String? content,
    bool? isMarkdown,
    List<String>? tags,
  }) async {
    // Get the existing note
    final existingNoteResult = await repository.getNoteById(id);

    return existingNoteResult.when(
      success: (existingNote) async {
        if (existingNote == null) {
          return const Failure(ValidationException('Note not found'));
        }

        // Validate input
        if (title != null && title.trim().isEmpty) {
          return const Failure(ValidationException('Title cannot be empty'));
        }

        if (title != null && title.length > 100) {
          return const Failure(
            ValidationException('Title cannot exceed 100 characters'),
          );
        }

        if (content != null && content.length > 10000) {
          return const Failure(
            ValidationException('Content cannot exceed 10,000 characters'),
          );
        }

        // Update the note
        final updatedNote = existingNote.updateContent(
          title: title,
          content: content,
          isMarkdown: isMarkdown,
          tags: tags,
        );

        // Save to repository
        return repository.updateNote(updatedNote);
      },
      failure: (exception) => Failure(exception),
    );
  }
}
