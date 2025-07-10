import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import 'package:markdown_widget/markdown_widget.dart';

class EditorPage extends StatefulWidget {
  final Note? note;
  const EditorPage({super.key, this.note});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isMarkdown = false;
  bool _showPreview = false;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _isMarkdown = widget.note?.isMarkdown ?? false;
    _tags = List<String>.from(widget.note?.tags ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Note title...',
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(_isMarkdown ? Icons.code : Icons.text_fields),
            tooltip: _isMarkdown ? 'Markdown mode' : 'Text mode',
            onPressed: () => setState(() => _isMarkdown = !_isMarkdown),
          ),
          IconButton(
            icon: Icon(_showPreview ? Icons.edit : Icons.remove_red_eye),
            tooltip: _showPreview ? 'Edit' : 'Preview',
            onPressed: () => setState(() => _showPreview = !_showPreview),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _showPreview && _isMarkdown
            ? MarkdownWidget(data: _contentController.text)
            : TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Start writing your note...',
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
      ),
    );
  }
}
