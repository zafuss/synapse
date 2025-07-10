import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

/// Base class for all note events
abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all notes
class LoadNotes extends NoteEvent {
  const LoadNotes();
}

/// Event to create a new note
class CreateNoteEvent extends NoteEvent {
  final String title;
  final String content;
  final bool isMarkdown;
  final List<String> tags;

  const CreateNoteEvent({
    required this.title,
    required this.content,
    this.isMarkdown = false,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [title, content, isMarkdown, tags];
}

/// Event to update an existing note
class UpdateNoteEvent extends NoteEvent {
  final String id;
  final String? title;
  final String? content;
  final bool? isMarkdown;
  final List<String>? tags;

  const UpdateNoteEvent({
    required this.id,
    this.title,
    this.content,
    this.isMarkdown,
    this.tags,
  });

  @override
  List<Object?> get props => [id, title, content, isMarkdown, tags];
}

/// Event to delete a note
class DeleteNoteEvent extends NoteEvent {
  final String id;

  const DeleteNoteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to search notes
class SearchNotesEvent extends NoteEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search
class ClearSearchEvent extends NoteEvent {
  const ClearSearchEvent();
}

/// Event to toggle note pinned status
class ToggleNotePinnedEvent extends NoteEvent {
  final String id;

  const ToggleNotePinnedEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to toggle note archived status
class ToggleNoteArchivedEvent extends NoteEvent {
  final String id;

  const ToggleNoteArchivedEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to add tag to note
class AddTagToNoteEvent extends NoteEvent {
  final String noteId;
  final String tag;

  const AddTagToNoteEvent({required this.noteId, required this.tag});

  @override
  List<Object?> get props => [noteId, tag];
}

/// Event to remove tag from note
class RemoveTagFromNoteEvent extends NoteEvent {
  final String noteId;
  final String tag;

  const RemoveTagFromNoteEvent({required this.noteId, required this.tag});

  @override
  List<Object?> get props => [noteId, tag];
}

/// Event to filter notes by tag
class FilterNotesByTagEvent extends NoteEvent {
  final String tag;

  const FilterNotesByTagEvent(this.tag);

  @override
  List<Object?> get props => [tag];
}

/// Event to clear tag filter
class ClearTagFilterEvent extends NoteEvent {
  const ClearTagFilterEvent();
}

/// Event to get pinned notes
class LoadPinnedNotesEvent extends NoteEvent {
  const LoadPinnedNotesEvent();
}

/// Event to get archived notes
class LoadArchivedNotesEvent extends NoteEvent {
  const LoadArchivedNotesEvent();
}

/// Event to get notes with summaries
class LoadNotesWithSummariesEvent extends NoteEvent {
  const LoadNotesWithSummariesEvent();
}

/// Event to get recent notes
class LoadRecentNotesEvent extends NoteEvent {
  final int days;

  const LoadRecentNotesEvent(this.days);

  @override
  List<Object?> get props => [days];
}

/// Event to refresh notes
class RefreshNotesEvent extends NoteEvent {
  const RefreshNotesEvent();
}

/// Event to sort notes
class SortNotesEvent extends NoteEvent {
  final NoteSortOption sortOption;

  const SortNotesEvent(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

/// Note sort options
enum NoteSortOption { dateCreated, dateUpdated, title, wordCount, readingTime }

/// Event to export notes
class ExportNotesEvent extends NoteEvent {
  final List<String> noteIds;
  final String format;

  const ExportNotesEvent({required this.noteIds, required this.format});

  @override
  List<Object?> get props => [noteIds, format];
}

/// Event to import notes
class ImportNotesEvent extends NoteEvent {
  final String data;
  final String format;

  const ImportNotesEvent({required this.data, required this.format});

  @override
  List<Object?> get props => [data, format];
}

/// Event to backup notes
class BackupNotesEvent extends NoteEvent {
  const BackupNotesEvent();
}

/// Event to restore notes from backup
class RestoreNotesEvent extends NoteEvent {
  final String backupData;

  const RestoreNotesEvent(this.backupData);

  @override
  List<Object?> get props => [backupData];
}

/// Event to clear all notes
class ClearAllNotesEvent extends NoteEvent {
  const ClearAllNotesEvent();
}

/// Event to get note statistics
class LoadNoteStatisticsEvent extends NoteEvent {
  const LoadNoteStatisticsEvent();
}
