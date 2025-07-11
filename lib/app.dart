import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_config.dart';
import 'core/di/dependency_injection.dart';
import 'features/notes/presentation/pages/notes_page.dart';
import 'features/notes/presentation/pages/editor_page.dart';
import 'features/notes/presentation/bloc/note_bloc.dart';
import 'shared/themes/app_theme.dart';

class SynapseApp extends StatelessWidget {
  const SynapseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteBloc>(create: (context) => getIt<NoteBloc>()),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'notes',
      builder: (context, state) => const NotesPage(),
    ),
    GoRoute(
      path: '/editor',
      name: 'editor',
      builder: (context, state) {
        final note = state.extra as Map<String, dynamic>?;
        return EditorPage(note: note?['note']);
      },
    ),
  ],
);

Future<void> initializeApp() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Initialize dependency injection
  await initializeDependencies();

  // Initialize Hive boxes
  await Hive.openBox(AppConfig.notesBoxName);
  await Hive.openBox(AppConfig.settingsBoxName);
  await Hive.openBox(AppConfig.summariesBoxName);
}
