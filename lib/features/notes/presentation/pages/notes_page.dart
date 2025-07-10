import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import '../widgets/note_card.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synapse Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading || state is NoteInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NoteError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is NotesLoaded) {
            if (!state.hasNotes) {
              return const Center(
                child: Text('No notes yet. Tap + to create your first note!'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.sortedNotes.length,
              itemBuilder: (context, index) {
                final note = state.sortedNotes[index];
                return NoteCard(
                  note: note,
                  onTap: () {
                    // TODO: Navigate to editor page for editing
                  },
                  onDelete: () {
                    context.read<NoteBloc>().add(DeleteNoteEvent(note.id));
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to editor page for creating new note
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
