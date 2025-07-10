import 'package:equatable/equatable.dart';

/// Note entity representing a note in the application
class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final bool isMarkdown;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? summary;
  final DateTime? summaryGeneratedAt;
  final List<String> tags;
  final bool isPinned;
  final bool isArchived;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.isMarkdown = false,
    required this.createdAt,
    required this.updatedAt,
    this.summary,
    this.summaryGeneratedAt,
    this.tags = const [],
    this.isPinned = false,
    this.isArchived = false,
  });

  /// Create a new Note with default values
  factory Note.create({
    required String title,
    required String content,
    bool isMarkdown = false,
    List<String> tags = const [],
  }) {
    final now = DateTime.now();
    return Note(
      id: _generateId(),
      title: title,
      content: content,
      isMarkdown: isMarkdown,
      createdAt: now,
      updatedAt: now,
      tags: tags,
    );
  }

  /// Create a copy of this Note with updated values
  Note copyWith({
    String? id,
    String? title,
    String? content,
    bool? isMarkdown,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? summary,
    DateTime? summaryGeneratedAt,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isMarkdown: isMarkdown ?? this.isMarkdown,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      summary: summary ?? this.summary,
      summaryGeneratedAt: summaryGeneratedAt ?? this.summaryGeneratedAt,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  /// Update the note with new content and mark as updated
  Note updateContent({
    String? title,
    String? content,
    bool? isMarkdown,
    List<String>? tags,
  }) {
    return copyWith(
      title: title,
      content: content,
      isMarkdown: isMarkdown,
      tags: tags,
      updatedAt: DateTime.now(),
    );
  }

  /// Add a summary to the note
  Note addSummary(String summary) {
    return copyWith(
      summary: summary,
      summaryGeneratedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Toggle the pinned status
  Note togglePinned() {
    return copyWith(isPinned: !isPinned, updatedAt: DateTime.now());
  }

  /// Toggle the archived status
  Note toggleArchived() {
    return copyWith(isArchived: !isArchived, updatedAt: DateTime.now());
  }

  /// Add a tag to the note
  Note addTag(String tag) {
    if (tags.contains(tag)) return this;
    return copyWith(tags: [...tags, tag], updatedAt: DateTime.now());
  }

  /// Remove a tag from the note
  Note removeTag(String tag) {
    if (!tags.contains(tag)) return this;
    return copyWith(
      tags: tags.where((t) => t != tag).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get the word count of the content
  int get wordCount {
    return content
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  /// Get the character count of the content
  int get characterCount {
    return content.length;
  }

  /// Get the reading time estimate (average 200 words per minute)
  int get readingTimeMinutes {
    return (wordCount / 200).ceil();
  }

  /// Check if the note has a summary
  bool get hasSummary => summary != null && summary!.isNotEmpty;

  /// Check if the note is empty
  bool get isEmpty => content.trim().isEmpty;

  /// Get the preview text (first 100 characters)
  String get preview {
    final cleanContent = content.trim();
    if (cleanContent.isEmpty) return 'Empty note';
    if (cleanContent.length <= 100) return cleanContent;
    return '${cleanContent.substring(0, 100)}...';
  }

  /// Check if the note matches a search query
  bool matchesSearch(String query) {
    final lowercaseQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowercaseQuery) ||
        content.toLowerCase().contains(lowercaseQuery) ||
        tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
  }

  /// Get the note type for display
  String get type {
    if (isMarkdown) return 'Markdown';
    return 'Text';
  }

  /// Get the formatted creation date
  String get formattedCreatedAt {
    return _formatDate(createdAt);
  }

  /// Get the formatted updated date
  String get formattedUpdatedAt {
    return _formatDate(updatedAt);
  }

  /// Get the formatted summary generation date
  String? get formattedSummaryGeneratedAt {
    if (summaryGeneratedAt == null) return null;
    return _formatDate(summaryGeneratedAt!);
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Generate a unique ID for the note
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    isMarkdown,
    createdAt,
    updatedAt,
    summary,
    summaryGeneratedAt,
    tags,
    isPinned,
    isArchived,
  ];

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: ${content.length} chars, isMarkdown: $isMarkdown, createdAt: $createdAt)';
  }
}
