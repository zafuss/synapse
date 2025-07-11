import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_config.dart';
import '../../features/notes/data/datasources/note_local_datasource.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../../features/notes/domain/usecases/create_note.dart';
import '../../features/notes/domain/usecases/delete_note.dart';
import '../../features/notes/domain/usecases/get_all_notes.dart';
import '../../features/notes/domain/usecases/search_notes.dart';
import '../../features/notes/domain/usecases/update_note.dart';
import '../../features/notes/presentation/bloc/note_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Data sources
  getIt.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(notesBox: Hive.box(AppConfig.notesBoxName)),
  );

  // Repositories
  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(localDataSource: getIt<NoteLocalDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllNotes(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => CreateNote(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => UpdateNote(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => DeleteNote(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => SearchNotes(getIt<NoteRepository>()));

  // BLoCs
  getIt.registerFactory(
    () => NoteBloc(
      getAllNotes: getIt<GetAllNotes>(),
      createNote: getIt<CreateNote>(),
      updateNote: getIt<UpdateNote>(),
      deleteNote: getIt<DeleteNote>(),
      searchNotes: getIt<SearchNotes>(),
    ),
  );
}
