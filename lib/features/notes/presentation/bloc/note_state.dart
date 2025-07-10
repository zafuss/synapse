import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import 'note_event.dart';

/// Base class for all note states
abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NoteInitial extends NoteState {
  const NoteInitial();
}

/// Loading state
class NoteLoading extends NoteState {
  const NoteLoading();
}

/// Loaded state with notes
class NotesLoaded extends NoteState {
  final List<Note> notes;
  final String? searchQuery;
  final String? activeTagFilter;
  final NoteSortOption sortOption;
  final bool isRefreshing;

  const NotesLoaded({
    required this.notes,
    this.searchQuery,
    this.activeTagFilter,
    this.sortOption = NoteSortOption.dateUpdated,
    this.isRefreshing = false,
  });

  /// Get sorted notes based on current sort option
  List<Note> get sortedNotes {
    switch (sortOption) {
      case NoteSortOption.dateCreated:
        return List.from(notes)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case NoteSortOption.dateUpdated:
        return List.from(notes)
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case NoteSortOption.title:
        return List.from(notes)..sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case NoteSortOption.wordCount:
        return List.from(notes)
          ..sort((a, b) => b.wordCount.compareTo(a.wordCount));
      case NoteSortOption.readingTime:
        return List.from(
          notes,
        )..sort((a, b) => b.readingTimeMinutes.compareTo(a.readingTimeMinutes));
    }
  }

  /// Get pinned notes
  List<Note> get pinnedNotes {
    return sortedNotes.where((note) => note.isPinned).toList();
  }

  /// Get archived notes
  List<Note> get archivedNotes {
    return sortedNotes.where((note) => note.isArchived).toList();
  }

  /// Get notes with summaries
  List<Note> get notesWithSummaries {
    return sortedNotes.where((note) => note.hasSummary).toList();
  }

  /// Get all tags from notes
  List<String> get allTags {
    final tags = <String>{};
    for (final note in notes) {
      tags.addAll(note.tags);
    }
    return tags.toList()..sort();
  }

  /// Get notes count by type
  int get textNotesCount => notes.where((note) => !note.isMarkdown).length;
  int get markdownNotesCount => notes.where((note) => note.isMarkdown).length;
  int get pinnedNotesCount => notes.where((note) => note.isPinned).length;
  int get archivedNotesCount => notes.where((note) => note.isArchived).length;
  int get notesWithSummariesCount =>
      notes.where((note) => note.hasSummary).length;

  /// Get total statistics
  int get totalWords => notes.fold(0, (sum, note) => sum + note.wordCount);
  int get totalCharacters =>
      notes.fold(0, (sum, note) => sum + note.characterCount);
  int get totalReadingTimeMinutes =>
      notes.fold(0, (sum, note) => sum + note.readingTimeMinutes);

  /// Check if there are any notes
  bool get hasNotes => notes.isNotEmpty;

  /// Check if there are any pinned notes
  bool get hasPinnedNotes => pinnedNotes.isNotEmpty;

  /// Check if there are any archived notes
  bool get hasArchivedNotes => archivedNotes.isNotEmpty;

  /// Check if there are any notes with summaries
  bool get hasNotesWithSummaries => notesWithSummaries.isNotEmpty;

  /// Check if there is an active search
  bool get hasActiveSearch => searchQuery != null && searchQuery!.isNotEmpty;

  /// Check if there is an active tag filter
  bool get hasActiveTagFilter =>
      activeTagFilter != null && activeTagFilter!.isNotEmpty;

  /// Create a copy with updated values
  NotesLoaded copyWith({
    List<Note>? notes,
    String? searchQuery,
    String? activeTagFilter,
    NoteSortOption? sortOption,
    bool? isRefreshing,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTagFilter: activeTagFilter ?? this.activeTagFilter,
      sortOption: sortOption ?? this.sortOption,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    notes,
    searchQuery,
    activeTagFilter,
    sortOption,
    isRefreshing,
  ];
}

/// Error state
class NoteError extends NoteState {
  final String message;
  final String? code;

  const NoteError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// State for specific note operations
class NoteOperationLoading extends NoteState {
  final String operation;
  final String? noteId;

  const NoteOperationLoading(this.operation, {this.noteId});

  @override
  List<Object?> get props => [operation, noteId];
}

/// State for note creation
class NoteCreated extends NoteState {
  final Note note;

  const NoteCreated(this.note);

  @override
  List<Object?> get props => [note];
}

/// State for note update
class NoteUpdated extends NoteState {
  final Note note;

  const NoteUpdated(this.note);

  @override
  List<Object?> get props => [note];
}

/// State for note deletion
class NoteDeleted extends NoteState {
  final String noteId;

  const NoteDeleted(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

/// State for note search
class NotesSearched extends NoteState {
  final List<Note> searchResults;
  final String query;

  const NotesSearched({required this.searchResults, required this.query});

  @override
  List<Object?> get props => [searchResults, query];
}

/// State for note statistics
class NoteStatisticsLoaded extends NoteState {
  final NoteStatistics statistics;

  const NoteStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

/// State for note export
class NotesExported extends NoteState {
  final String exportData;
  final String format;

  const NotesExported({required this.exportData, required this.format});

  @override
  List<Object?> get props => [exportData, format];
}

/// State for note import
class NotesImported extends NoteState {
  final List<Note> importedNotes;
  final int importedCount;

  const NotesImported({
    required this.importedNotes,
    required this.importedCount,
  });

  @override
  List<Object?> get props => [importedNotes, importedCount];
}

/// State for note backup
class NotesBackedUp extends NoteState {
  final String backupData;

  const NotesBackedUp(this.backupData);

  @override
  List<Object?> get props => [backupData];
}

/// State for note restore
class NotesRestored extends NoteState {
  final List<Note> restoredNotes;
  final int restoredCount;

  const NotesRestored({
    required this.restoredNotes,
    required this.restoredCount,
  });

  @override
  List<Object?> get props => [restoredNotes, restoredCount];
}

/// State for all notes cleared
class AllNotesCleared extends NoteState {
  const AllNotesCleared();
}
