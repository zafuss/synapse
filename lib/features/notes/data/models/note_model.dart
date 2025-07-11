import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

class NoteModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isMarkdown;
  final List<String> tags;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isMarkdown,
    required this.tags,
  });

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isMarkdown: note.isMarkdown,
      tags: note.tags,
    );
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isMarkdown: json['isMarkdown'] as bool? ?? false,
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isMarkdown': isMarkdown,
      'tags': tags,
    };
  }

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isMarkdown: isMarkdown,
      tags: tags,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    createdAt,
    updatedAt,
    isMarkdown,
    tags,
  ];
}
