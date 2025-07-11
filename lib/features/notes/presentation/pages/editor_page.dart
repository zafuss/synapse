import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import 'package:synapse/shared/widgets/app_bar_widget.dart';
import 'package:synapse/shared/widgets/markdown_preview_widget.dart';
import 'package:markdown_widget/markdown_widget.dart';

// Helper for dropdown menu
class _ToolbarDropdown extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final List<_DropdownMenuItem> items;
  const _ToolbarDropdown({
    required this.icon,
    required this.tooltip,
    required this.items,
  });
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_DropdownMenuItem>(
      tooltip: tooltip,
      icon: Icon(icon, color: Colors.black),
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (item) => item.onTap(),
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem<_DropdownMenuItem>(
              value: item,
              child: Row(
                children: [
                  if (item.icon != null)
                    Icon(item.icon, color: Colors.black, size: 18),
                  if (item.icon != null) const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DropdownMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  _DropdownMenuItem({required this.label, this.icon, required this.onTap});
}

class EditorPage extends StatefulWidget {
  final Note? note;
  const EditorPage({super.key, this.note});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;
  bool _isMarkdown = false;
  bool _showPreview = false;
  List<String> _tags = [];
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _tagController = TextEditingController();
    _isMarkdown = widget.note?.isMarkdown ?? false;
    _tags = List<String>.from(widget.note?.tags ?? []);
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _contentController.removeListener(_onContentChanged);
    super.dispose();
  }

  void _onContentChanged() {
    if (_undoStack.isEmpty || _undoStack.last != _contentController.text) {
      _undoStack.add(_contentController.text);
      if (_undoStack.length > 100) _undoStack.removeAt(0);
    }
  }

  void _undo() {
    if (_undoStack.length > 1) {
      _redoStack.add(_undoStack.removeLast());
      _contentController.text = _undoStack.last;
      _contentController.selection = TextSelection.collapsed(
        offset: _contentController.text.length,
      );
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      final redo = _redoStack.removeLast();
      _undoStack.add(redo);
      _contentController.text = redo;
      _contentController.selection = TextSelection.collapsed(
        offset: _contentController.text.length,
      );
    }
  }

  void _insertAtSelection(String before, [String after = '']) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$before${text.substring(selection.start, selection.end)}$after',
    );
    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset:
          selection.start +
          before.length +
          (selection.end - selection.start) +
          after.length,
    );
  }

  void _insertLinePrefix(String prefix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final lines = text.split('\n');
    int charCount = 0;
    for (int i = 0; i < lines.length; i++) {
      final lineStart = charCount;
      final lineEnd = charCount + lines[i].length;
      if (selection.start >= lineStart && selection.start <= lineEnd) {
        lines[i] = '$prefix${lines[i].replaceFirst(RegExp('^$prefix*'), '')}';
        break;
      }
      charCount += lines[i].length + 1;
    }
    _contentController.text = lines.join('\n');
    _contentController.selection = TextSelection.collapsed(
      offset: selection.start + prefix.length,
    );
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text;
    if (widget.note == null) {
      context.read<NoteBloc>().add(
        CreateNoteEvent(
          title: title,
          content: content,
          isMarkdown: _isMarkdown,
          tags: _tags,
        ),
      );
    } else {
      context.read<NoteBloc>().add(
        UpdateNoteEvent(
          id: widget.note!.id,
          title: title,
          content: content,
          isMarkdown: _isMarkdown,
          tags: _tags,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Edit Note',
        showBackButton: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                _isMarkdown ? Icons.code : Icons.text_fields,
                color: Colors.black,
                size: 20,
              ),
              tooltip: _isMarkdown ? 'Markdown mode' : 'Text mode',
              onPressed: () => setState(() => _isMarkdown = !_isMarkdown),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                _showPreview ? Icons.edit : Icons.remove_red_eye,
                color: Colors.black,
                size: 20,
              ),
              tooltip: _showPreview ? 'Edit' : 'Preview',
              onPressed: () => setState(() => _showPreview = !_showPreview),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.save, color: Colors.black, size: 20),
              tooltip: 'Save',
              onPressed: _saveNote,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formatting Toolbar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Undo/Redo
                      IconButton(
                        icon: const Icon(Icons.undo, color: Colors.black),
                        tooltip: 'Undo',
                        onPressed: _undoStack.length > 1 ? _undo : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.redo, color: Colors.black),
                        tooltip: 'Redo',
                        onPressed: _redoStack.isNotEmpty ? _redo : null,
                      ),
                      const SizedBox(width: 8),
                      // Heading group
                      _ToolbarDropdown(
                        icon: Icons.text_fields,
                        tooltip: 'Paragraph Style',
                        items: [
                          _DropdownMenuItem(
                            label: 'Title',
                            onTap: () => _insertLinePrefix('# '),
                          ),
                          _DropdownMenuItem(
                            label: 'Heading',
                            onTap: () => _insertLinePrefix('## '),
                          ),
                          _DropdownMenuItem(
                            label: 'Subheading',
                            onTap: () => _insertLinePrefix('### '),
                          ),
                          _DropdownMenuItem(
                            label: 'Body',
                            onTap: () => _insertLinePrefix(''),
                          ),
                          _DropdownMenuItem(
                            label: 'Monostyled',
                            onTap: () => _insertLinePrefix('```\n'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Text style group
                      _ToolbarDropdown(
                        icon: Icons.format_bold,
                        tooltip: 'Text Style',
                        items: [
                          _DropdownMenuItem(
                            label: 'Bold',
                            icon: Icons.format_bold,
                            onTap: () => _insertAtSelection('**', '**'),
                          ),
                          _DropdownMenuItem(
                            label: 'Italic',
                            icon: Icons.format_italic,
                            onTap: () => _insertAtSelection('*', '*'),
                          ),
                          _DropdownMenuItem(
                            label: 'Underline',
                            icon: Icons.format_underline,
                            onTap: () => _insertAtSelection('<u>', '</u>'),
                          ),
                          _DropdownMenuItem(
                            label: 'Strikethrough',
                            icon: Icons.format_strikethrough,
                            onTap: () => _insertAtSelection('~~', '~~'),
                          ),
                          _DropdownMenuItem(
                            label: 'Highlight',
                            icon: Icons.highlight,
                            onTap: () => _insertAtSelection('==', '=='),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // List group
                      _ToolbarDropdown(
                        icon: Icons.format_list_bulleted,
                        tooltip: 'List',
                        items: [
                          _DropdownMenuItem(
                            label: 'Bulleted List',
                            onTap: () => _insertLinePrefix('- '),
                          ),
                          _DropdownMenuItem(
                            label: 'Dashed List',
                            onTap: () => _insertLinePrefix('* '),
                          ),
                          _DropdownMenuItem(
                            label: 'Numbered List',
                            onTap: () => _insertLinePrefix('1. '),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Block Quote
                      _FormatButton(
                        icon: Icons.format_quote,
                        tooltip: 'Block Quote',
                        onTap: () => _insertLinePrefix('> '),
                      ),
                      const SizedBox(width: 8),
                      // Preview toggle
                      IconButton(
                        icon: Icon(
                          _showPreview ? Icons.edit : Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        tooltip: _showPreview ? 'Edit' : 'Preview',
                        onPressed: () =>
                            setState(() => _showPreview = !_showPreview),
                      ),
                    ],
                  ),
                ),
              ),
              // Title field
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Note title...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              // Tag input and chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._tags.map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _removeTag(tag),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Add tag',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                      ),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  GestureDetector(
                    onTap: _addTag,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Content field or preview
              Expanded(
                child: _showPreview && _isMarkdown
                    ? MarkdownPreviewWidget(
                        text: _contentController.text,
                        isMarkdown: true,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _contentController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: 'Start writing your note...',
                            hintStyle: TextStyle(
                              color: Theme.of(
                                context,
                              ).hintColor.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.6),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? tooltip;
  final VoidCallback onTap;
  const _FormatButton({
    this.label,
    this.icon,
    this.tooltip,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: icon != null
                ? Icon(icon, size: 18, color: Colors.black)
                : Text(
                    label ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
