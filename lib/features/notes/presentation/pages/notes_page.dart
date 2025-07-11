import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import '../../domain/entities/note.dart';
import 'package:synapse/shared/widgets/app_bar_widget.dart';
import 'package:synapse/shared/widgets/note_card_widget.dart';
import 'package:synapse/shared/widgets/empty_state_widget.dart';
import 'package:synapse/shared/widgets/loading_widget.dart';
import 'package:synapse/shared/widgets/custom_fab_widget.dart';
import 'editor_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(const LoadNotes());
  }

  void _openEditor({Note? note}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => EditorPage(note: note)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: 'Synapse Notes',
        actions: [
          // TODO: Add search/filter actions if needed
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading || state is NoteInitial) {
            return const LoadingWidget(
              message: 'Loading your notes...',
              size: 60,
            );
          }

          if (state is NoteError) {
            return EmptyStateWidget(
              message: 'Something went wrong',
              subtitle: state.message,
              icon: Icons.error_outline,
              actionLabel: 'Try Again',
              onAction: () {
                context.read<NoteBloc>().add(const LoadNotes());
              },
            );
          }

          if (state is NotesLoaded) {
            if (!state.hasNotes) {
              return EmptyStateWidget(
                message: 'No notes yet',
                subtitle: 'Tap + to create your first note!',
                icon: Icons.note_add_outlined,
                actionLabel: 'Create Note',
                onAction: () => _openEditor(),
              );
            }

            return Container(
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
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.sortedNotes.length,
                itemBuilder: (context, index) {
                  final note = state.sortedNotes[index];
                  return NoteCardWidget(
                    note: note,
                    onTap: () => _openEditor(note: note),
                    onDelete: () {
                      context.read<NoteBloc>().add(DeleteNoteEvent(note.id));
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: CustomFABWidget(
        onPressed: () => _openEditor(),
        icon: Icons.add,
        tooltip: 'Create new note',
      ),
    );
  }
}
