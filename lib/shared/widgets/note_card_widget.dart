import 'package:flutter/material.dart';
import '../../features/notes/domain/entities/note.dart';

class NoteCardWidget extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NoteCardWidget({
    super.key,
    required this.note,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icons and title
                Row(
                  children: [
                    // Status icons
                    if (note.isPinned)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.push_pin,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    if (note.isArchived)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.archive,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    if (note.isMarkdown)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.code,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Text(
                        note.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Delete button
                    if (onDelete != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: onDelete,
                          tooltip: 'Delete',
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Preview text
                Text(
                  note.preview,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Footer with date and tags
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        note.formattedUpdatedAt,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (note.tags.isNotEmpty)
                      Row(
                        children: note.tags
                            .take(2)
                            .map((tag) => _TagChip(tag: tag))
                            .toList(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
