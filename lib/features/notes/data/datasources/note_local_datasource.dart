import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/note.dart';
import '../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<Note>> getAllNotes();
  Future<Note> createNote(Note note);
  Future<Note> updateNote(Note note);
  Future<void> deleteNote(String id);
  Future<List<Note>> searchNotes(String query);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Box<dynamic> notesBox;

  NoteLocalDataSourceImpl({required this.notesBox});

  @override
  Future<List<Note>> getAllNotes() async {
    try {
      final notes = notesBox.values.toList();
      return notes
          .map(
            (note) => NoteModel.fromJson(
              Map<String, dynamic>.from(note as Map),
            ).toEntity(),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }

  @override
  Future<Note> createNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await notesBox.put(note.id, noteModel.toJson());
      return note;
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  @override
  Future<Note> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await notesBox.put(note.id, noteModel.toJson());
      return note;
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await notesBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    try {
      final allNotes = await getAllNotes();
      return allNotes.where((note) {
        final searchText = query.toLowerCase();
        return note.title.toLowerCase().contains(searchText) ||
            note.content.toLowerCase().contains(searchText) ||
            note.tags.any((tag) => tag.toLowerCase().contains(searchText));
      }).toList();
    } catch (e) {
      throw Exception('Failed to search notes: $e');
    }
  }
}
