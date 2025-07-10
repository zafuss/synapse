import '../../../../core/utils/result.dart';
import '../entities/note.dart';

/// Repository interface for Note operations
abstract class NoteRepository {
  /// Get all notes
  Future<Result<List<Note>>> getAllNotes();

  /// Get a note by ID
  Future<Result<Note?>> getNoteById(String id);

  /// Create a new note
  Future<Result<Note>> createNote(Note note);

  /// Update an existing note
  Future<Result<Note>> updateNote(Note note);

  /// Delete a note by ID
  Future<Result<void>> deleteNote(String id);

  /// Search notes by query
  Future<Result<List<Note>>> searchNotes(String query);

  /// Get notes by tag
  Future<Result<List<Note>>> getNotesByTag(String tag);

  /// Get pinned notes
  Future<Result<List<Note>>> getPinnedNotes();

  /// Get archived notes
  Future<Result<List<Note>>> getArchivedNotes();

  /// Get notes with summaries
  Future<Result<List<Note>>> getNotesWithSummaries();

  /// Get notes created in the last N days
  Future<Result<List<Note>>> getRecentNotes(int days);

  /// Get all tags
  Future<Result<List<String>>> getAllTags();

  /// Get note statistics
  Future<Result<NoteStatistics>> getNoteStatistics();

  /// Export notes to a specific format
  Future<Result<String>> exportNotes(List<String> noteIds, String format);

  /// Import notes from a string
  Future<Result<List<Note>>> importNotes(String data, String format);

  /// Backup all notes
  Future<Result<String>> backupNotes();

  /// Restore notes from backup
  Future<Result<List<Note>>> restoreNotes(String backupData);

  /// Clear all notes
  Future<Result<void>> clearAllNotes();

  /// Get notes count
  Future<Result<int>> getNotesCount();

  /// Check if a note exists
  Future<Result<bool>> noteExists(String id);
}

/// Statistics about notes
class NoteStatistics {
  final int totalNotes;
  final int textNotes;
  final int markdownNotes;
  final int pinnedNotes;
  final int archivedNotes;
  final int notesWithSummaries;
  final int totalWords;
  final int totalCharacters;
  final DateTime? oldestNoteDate;
  final DateTime? newestNoteDate;
  final List<String> allTags;
  final Map<String, int> tagUsage;

  const NoteStatistics({
    required this.totalNotes,
    required this.textNotes,
    required this.markdownNotes,
    required this.pinnedNotes,
    required this.archivedNotes,
    required this.notesWithSummaries,
    required this.totalWords,
    required this.totalCharacters,
    this.oldestNoteDate,
    this.newestNoteDate,
    required this.allTags,
    required this.tagUsage,
  });

  /// Get the average words per note
  double get averageWordsPerNote {
    if (totalNotes == 0) return 0;
    return totalWords / totalNotes;
  }

  /// Get the average characters per note
  double get averageCharactersPerNote {
    if (totalNotes == 0) return 0;
    return totalCharacters / totalNotes;
  }

  /// Get the percentage of text notes
  double get textNotesPercentage {
    if (totalNotes == 0) return 0;
    return (textNotes / totalNotes) * 100;
  }

  /// Get the percentage of markdown notes
  double get markdownNotesPercentage {
    if (totalNotes == 0) return 0;
    return (markdownNotes / totalNotes) * 100;
  }

  /// Get the percentage of pinned notes
  double get pinnedNotesPercentage {
    if (totalNotes == 0) return 0;
    return (pinnedNotes / totalNotes) * 100;
  }

  /// Get the percentage of notes with summaries
  double get notesWithSummariesPercentage {
    if (totalNotes == 0) return 0;
    return (notesWithSummaries / totalNotes) * 100;
  }

  /// Get the most used tags (top 5)
  List<MapEntry<String, int>> get topTags {
    final sortedTags = tagUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedTags.take(5).toList();
  }

  /// Get the total reading time in minutes
  int get totalReadingTimeMinutes {
    return (totalWords / 200).ceil(); // Average 200 words per minute
  }

  /// Get the formatted total reading time
  String get formattedTotalReadingTime {
    final hours = totalReadingTimeMinutes ~/ 60;
    final minutes = totalReadingTimeMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get the age of the oldest note in days
  int? get oldestNoteAgeDays {
    if (oldestNoteDate == null) return null;
    return DateTime.now().difference(oldestNoteDate!).inDays;
  }

  /// Get the age of the newest note in days
  int? get newestNoteAgeDays {
    if (newestNoteDate == null) return null;
    return DateTime.now().difference(newestNoteDate!).inDays;
  }

  @override
  String toString() {
    return 'NoteStatistics(totalNotes: $totalNotes, textNotes: $textNotes, markdownNotes: $markdownNotes, totalWords: $totalWords)';
  }
}
