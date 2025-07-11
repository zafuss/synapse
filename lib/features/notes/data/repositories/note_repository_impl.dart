import '../../../../core/utils/result.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_datasource.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<Note>>> getAllNotes() async {
    try {
      final notes = await localDataSource.getAllNotes();

      // If no notes exist, create sample notes
      if (notes.isEmpty) {
        final sampleNotes = await _createSampleNotes();
        return Success(sampleNotes);
      }

      return Success(notes);
    } catch (e) {
      return Failure(StorageException('Failed to get notes: $e'));
    }
  }

  /// Create sample notes for first-time users
  Future<List<Note>> _createSampleNotes() async {
    final sampleNotes = [
      Note.create(
        title: 'Welcome to Synapse! 🧠',
        content: '''# Welcome to Synapse!

This is your **intelligent note-taking app** with Markdown support.

## Features you can try:

- **Create new notes** using the + button
- **Switch between Text and Markdown** modes
- **Preview your Markdown** with the eye icon
- **Search through your notes** (coming soon)
- **AI-powered summaries** (coming soon)

## Sample Markdown

You can use:
- **Bold text** and *italic text*
- `Inline code` and code blocks
- [Links](https://example.com)
- Lists like this one

Start creating your notes now!''',
        isMarkdown: true,
        tags: ['welcome', 'guide', 'markdown'],
      ),

      Note.create(
        title: 'Shopping List',
        content: '''# Shopping List

## Groceries
- [ ] Milk
- [ ] Bread
- [ ] Eggs
- [ ] Bananas
- [ ] Coffee

## Electronics
- [ ] Phone charger
- [ ] USB cable
- [ ] Power bank

## Home
- [ ] Light bulbs
- [ ] Batteries
- [ ] Cleaning supplies''',
        isMarkdown: true,
        tags: ['shopping', 'todo', 'personal'],
      ),

      Note.create(
        title: 'Meeting Notes - Project Kickoff',
        content:
            '''# Project Kickoff Meeting

**Date:** ${DateTime.now().subtract(const Duration(days: 2)).toString().split(' ')[0]}
**Time:** 10:00 AM
**Attendees:** John, Sarah, Mike, Lisa

## Agenda
1. Project overview
2. Team introductions
3. Timeline discussion
4. Next steps

## Key Points
- Project deadline: 3 months
- Budget: \$50,000
- Team size: 5 people

## Action Items
- [ ] John: Create project timeline
- [ ] Sarah: Set up development environment
- [ ] Mike: Research competitors
- [ ] Lisa: Prepare presentation

## Notes
The team seems excited about this project. We have a good mix of skills and experience.''',
        isMarkdown: true,
        tags: ['work', 'meeting', 'project'],
      ),

      Note.create(
        title: 'Quick Ideas',
        content: '''Random thoughts and ideas:

1. App for local restaurant recommendations
2. Smart home automation system
3. Language learning app with AI
4. Fitness tracker with social features
5. Recipe sharing platform

Need to research these further and prioritize.''',
        isMarkdown: false,
        tags: ['ideas', 'personal', 'brainstorm'],
      ),

      Note.create(
        title: 'Daily Journal',
        content: '''Today was a productive day!

## What I accomplished:
- Finished the project setup
- Had a great meeting with the team
- Learned some new Flutter concepts
- Went for a 30-minute walk

## What I'm grateful for:
- Good health
- Supportive family
- Interesting work
- Beautiful weather

## Tomorrow's goals:
- Start working on the new feature
- Call mom
- Read for 30 minutes
- Exercise

Feeling motivated and ready for tomorrow!''',
        isMarkdown: false,
        tags: ['journal', 'personal', 'reflection'],
      ),
    ];

    // Save sample notes to local storage
    for (final note in sampleNotes) {
      await localDataSource.createNote(note);
    }

    return sampleNotes;
  }

  @override
  Future<Result<Note?>> getNoteById(String id) async {
    try {
      final notes = await localDataSource.getAllNotes();
      final note = notes.where((note) => note.id == id).firstOrNull;
      return Success(note);
    } catch (e) {
      return Failure(StorageException('Failed to get note: $e'));
    }
  }

  @override
  Future<Result<Note>> createNote(Note note) async {
    try {
      final createdNote = await localDataSource.createNote(note);
      return Success(createdNote);
    } catch (e) {
      return Failure(StorageException('Failed to create note: $e'));
    }
  }

  @override
  Future<Result<Note>> updateNote(Note note) async {
    try {
      final updatedNote = await localDataSource.updateNote(note);
      return Success(updatedNote);
    } catch (e) {
      return Failure(StorageException('Failed to update note: $e'));
    }
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    try {
      await localDataSource.deleteNote(id);
      return const Success(null);
    } catch (e) {
      return Failure(StorageException('Failed to delete note: $e'));
    }
  }

  @override
  Future<Result<List<Note>>> searchNotes(String query) async {
    try {
      final notes = await localDataSource.searchNotes(query);
      return Success(notes);
    } catch (e) {
      return Failure(StorageException('Failed to search notes: $e'));
    }
  }

  @override
  Future<Result<List<Note>>> getNotesByTag(String tag) async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      final filteredNotes = allNotes
          .where((note) => note.tags.contains(tag))
          .toList();
      return Success(filteredNotes);
    } catch (e) {
      return Failure(StorageException('Failed to get notes by tag: $e'));
    }
  }

  @override
  Future<Result<List<Note>>> getPinnedNotes() async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      // TODO: Implement pinned notes logic
      return Success(allNotes);
    } catch (e) {
      return Failure(StorageException('Failed to get pinned notes: $e'));
    }
  }

  @override
  Future<Result<List<Note>>> getArchivedNotes() async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      // TODO: Implement archived notes logic
      return Success(allNotes);
    } catch (e) {
      return Failure(StorageException('Failed to get archived notes: $e'));
    }
  }

  @override
  Future<Result<List<Note>>> getNotesWithSummaries() async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      // TODO: Implement notes with summaries logic
      return Success(allNotes);
    } catch (e) {
      return Failure(
        StorageException('Failed to get notes with summaries: $e'),
      );
    }
  }

  @override
  Future<Result<List<Note>>> getRecentNotes(int days) async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      final recentNotes = allNotes
          .where((note) => note.createdAt.isAfter(cutoffDate))
          .toList();
      return Success(recentNotes);
    } catch (e) {
      return Failure(StorageException('Failed to get recent notes: $e'));
    }
  }

  @override
  Future<Result<List<String>>> getAllTags() async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      final allTags = <String>{};
      for (final note in allNotes) {
        allTags.addAll(note.tags);
      }
      return Success(allTags.toList());
    } catch (e) {
      return Failure(StorageException('Failed to get all tags: $e'));
    }
  }

  @override
  Future<Result<NoteStatistics>> getNoteStatistics() async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      final totalNotes = allNotes.length;
      final textNotes = allNotes.where((note) => !note.isMarkdown).length;
      final markdownNotes = allNotes.where((note) => note.isMarkdown).length;
      final pinnedNotes = 0; // TODO: Implement
      final archivedNotes = 0; // TODO: Implement
      final notesWithSummaries = 0; // TODO: Implement

      int totalWords = 0;
      int totalCharacters = 0;
      final allTags = <String>{};
      final tagUsage = <String, int>{};

      DateTime? oldestNoteDate;
      DateTime? newestNoteDate;

      for (final note in allNotes) {
        totalWords += note.content.split(' ').length;
        totalCharacters += note.content.length;
        allTags.addAll(note.tags);

        for (final tag in note.tags) {
          tagUsage[tag] = (tagUsage[tag] ?? 0) + 1;
        }

        if (oldestNoteDate == null || note.createdAt.isBefore(oldestNoteDate)) {
          oldestNoteDate = note.createdAt;
        }
        if (newestNoteDate == null || note.createdAt.isAfter(newestNoteDate)) {
          newestNoteDate = note.createdAt;
        }
      }

      final statistics = NoteStatistics(
        totalNotes: totalNotes,
        textNotes: textNotes,
        markdownNotes: markdownNotes,
        pinnedNotes: pinnedNotes,
        archivedNotes: archivedNotes,
        notesWithSummaries: notesWithSummaries,
        totalWords: totalWords,
        totalCharacters: totalCharacters,
        oldestNoteDate: oldestNoteDate,
        newestNoteDate: newestNoteDate,
        allTags: allTags.toList(),
        tagUsage: tagUsage,
      );

      return Success(statistics);
    } catch (e) {
      return Failure(StorageException('Failed to get note statistics: $e'));
    }
  }

  @override
  Future<Result<String>> exportNotes(
    List<String> noteIds,
    String format,
  ) async {
    try {
      // TODO: Implement export functionality
      return const Success('');
    } catch (e) {
      return Failure(StorageException('Failed to export notes: $e'));
    }
  }

  @override
  Future<Result<List<Note>>> importNotes(String data, String format) async {
    try {
      // TODO: Implement import functionality
      return const Success([]);
    } catch (e) {
      return Failure(StorageException('Failed to import notes: $e'));
    }
  }

  @override
  Future<Result<String>> backupNotes() async {
    try {
      // TODO: Implement backup functionality
      return const Success('');
    } catch (e) {
      return Failure(StorageException('Failed to backup notes: $e'));
    }
  }

  @override
  Future<Result<List<Note>>> restoreNotes(String backupData) async {
    try {
      // TODO: Implement restore functionality
      return const Success([]);
    } catch (e) {
      return Failure(StorageException('Failed to restore notes: $e'));
    }
  }

  @override
  Future<Result<void>> clearAllNotes() async {
    try {
      // TODO: Implement clear all notes functionality
      return const Success(null);
    } catch (e) {
      return Failure(StorageException('Failed to clear all notes: $e'));
    }
  }

  @override
  Future<Result<int>> getNotesCount() async {
    try {
      final allNotes = await localDataSource.getAllNotes();
      return Success(allNotes.length);
    } catch (e) {
      return Failure(StorageException('Failed to get notes count: $e'));
    }
  }

  @override
  Future<Result<bool>> noteExists(String id) async {
    try {
      final note = await getNoteById(id);
      return Success(note.successValue != null);
    } catch (e) {
      return Failure(StorageException('Failed to check if note exists: $e'));
    }
  }
}
