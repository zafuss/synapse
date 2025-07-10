import '../../../../core/utils/result.dart';
import '../../../../core/errors/app_exception.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

/// Use case for creating a new note
class CreateNote {
  final NoteRepository repository;

  const CreateNote(this.repository);

  /// Execute the use case
  Future<Result<Note>> call({
    required String title,
    required String content,
    bool isMarkdown = false,
    List<String> tags = const [],
  }) async {
    // Validate input
    if (title.trim().isEmpty) {
      return const Failure(ValidationException('Title cannot be empty'));
    }

    if (title.length > 100) {
      return const Failure(
        ValidationException('Title cannot exceed 100 characters'),
      );
    }

    if (content.length > 10000) {
      return const Failure(
        ValidationException('Content cannot exceed 10,000 characters'),
      );
    }

    // Create the note
    final note = Note.create(
      title: title.trim(),
      content: content,
      isMarkdown: isMarkdown,
      tags: tags,
    );

    // Save to repository
    return repository.createNote(note);
  }
}
