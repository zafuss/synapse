# 👨‍💻 Synapse Development Guide

## 📋 Table of Contents

1. [Getting Started](#getting-started)
2. [Development Environment](#development-environment)
3. [Project Setup](#project-setup)
4. [Coding Standards](#coding-standards)
5. [BLoC Pattern](#bloc-pattern)
6. [Testing Guidelines](#testing-guidelines)
7. [Debugging](#debugging)
8. [Performance Optimization](#performance-optimization)
9. [Deployment](#deployment)

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.16.0 or higher
- **Dart SDK**: 3.2.0 or higher
- **Android Studio** or **VS Code**
- **Git**: Version control
- **Android SDK**: For Android development
- **Xcode**: For iOS development (macOS only)

### Required Tools

```bash
# Install Flutter
flutter doctor

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 🛠️ Development Environment

### 1. IDE Setup

#### VS Code (Recommended)

```json
// settings.json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

#### Android Studio

- Install Flutter and Dart plugins
- Configure Flutter SDK path
- Enable format on save

### 2. Code Generation Setup

```bash
# Install build_runner globally
dart pub global activate build_runner

# Generate code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### 3. Git Hooks

```bash
# Pre-commit hook
#!/bin/sh
flutter analyze
flutter test
flutter format .
```

---

## 📁 Project Setup

### 1. Project Structure

```
synapse/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── utils/
│   │   ├── network/
│   │   └── di/
│   ├── features/
│   │   ├── notes/
│   │   ├── editor/
│   │   ├── ai_summary/
│   │   └── settings/
│   ├── shared/
│   └── infrastructure/
├── test/
├── docs/
└── pubspec.yaml
```

### 2. Dependencies Management

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # UI Components
  flutter_markdown: ^0.6.18
  google_fonts: ^6.1.0

  # Network
  dio: ^5.3.2

  # Utils
  uuid: ^4.2.1
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
  mockito: ^5.4.2
  bloc_test: ^9.1.4
```

### 3. Environment Configuration

```dart
// lib/core/constants/app_config.dart
class AppConfig {
  static const String appName = 'Synapse';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // App Configuration
  static const int maxNoteLength = 10000;
  static const int maxTitleLength = 100;
  static const Duration autoSaveInterval = Duration(seconds: 30);
}
```

---

## 📝 Coding Standards

### 1. Dart Style Guide

#### Naming Conventions

```dart
// Classes and enums - PascalCase
class NoteRepository {}
enum NoteStatus { draft, published, archived }

// Variables and functions - camelCase
String noteTitle;
void createNote() {}

// Constants - SCREAMING_SNAKE_CASE
const String API_BASE_URL = 'https://api.example.com';

// Private members - underscore prefix
class _PrivateClass {}
String _privateVariable = '';
```

#### Code Organization

```dart
// File structure
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_config.dart';
import '../shared/widgets/custom_widget.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  // Constants
  static const String _boxName = 'notes';

  // Fields
  final NoteRepository _repository;

  // Constructor
  NoteBloc(this._repository) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
  }

  // Methods
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    // Implementation
  }
}
```

### 2. BLoC Pattern Standards

#### Event Definition

```dart
// lib/features/notes/presentation/bloc/note_event.dart
abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NoteEvent {}

class CreateNote extends NoteEvent {
  final String title;
  final String content;
  final bool isMarkdown;

  const CreateNote({
    required this.title,
    required this.content,
    this.isMarkdown = false,
  });

  @override
  List<Object> get props => [title, content, isMarkdown];
}
```

#### State Definition

```dart
// lib/features/notes/presentation/bloc/note_state.dart
abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;

  const NoteLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NoteError extends NoteState {
  final String message;

  const NoteError(this.message);

  @override
  List<Object> get props => [message];
}
```

#### BLoC Implementation

```dart
// lib/features/notes/presentation/bloc/note_bloc.dart
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;

  NoteBloc(this._repository) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNote>(_onCreateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());

    try {
      final notes = await _repository.getNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onCreateNote(CreateNote event, Emitter<NoteState> emit) async {
    final currentState = state;
    if (currentState is NoteLoaded) {
      emit(NoteLoading());

      try {
        final note = Note(
          id: const Uuid().v4(),
          title: event.title,
          content: event.content,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isMarkdown: event.isMarkdown,
        );

        await _repository.saveNote(note);
        final updatedNotes = [note, ...currentState.notes];
        emit(NoteLoaded(updatedNotes));
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    }
  }
}
```

### 3. Widget Standards

#### Stateless Widget

```dart
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          note.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
```

#### Stateful Widget

```dart
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isMarkdown = widget.note?.isMarkdown ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
        ),
        actions: [
          IconButton(
            icon: Icon(_isMarkdown ? Icons.code : Icons.text_fields),
            onPressed: () => setState(() => _isMarkdown = !_isMarkdown),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: _buildEditor(),
    );
  }

  Widget _buildEditor() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _contentController,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: 'Start writing your note...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _saveNote() {
    // Implementation
  }
}
```

---

## 🧪 Testing Guidelines

### 1. Unit Testing

#### BLoC Testing

```dart
// test/features/notes/presentation/bloc/note_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:synapse/features/notes/presentation/bloc/note_bloc.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late NoteBloc noteBloc;
  late MockNoteRepository mockRepository;

  setUp(() {
    mockRepository = MockNoteRepository();
    noteBloc = NoteBloc(mockRepository);
  });

  tearDown(() {
    noteBloc.close();
  });

  test('initial state should be NoteInitial', () {
    expect(noteBloc.state, equals(NoteInitial()));
  });

  blocTest<NoteBloc, NoteState>(
    'emits [NoteLoading, NoteLoaded] when LoadNotes is added',
    build: () {
      when(mockRepository.getNotes()).thenAnswer(
        (_) async => const <Note>[],
      );
      return noteBloc;
    },
    act: (bloc) => bloc.add(LoadNotes()),
    expect: () => [
      NoteLoading(),
      const NoteLoaded(<Note>[]),
    ],
  );

  blocTest<NoteBloc, NoteState>(
    'emits [NoteLoading, NoteError] when repository throws exception',
    build: () {
      when(mockRepository.getNotes()).thenThrow(Exception('Database error'));
      return noteBloc;
    },
    act: (bloc) => bloc.add(LoadNotes()),
    expect: () => [
      NoteLoading(),
      const NoteError('Exception: Database error'),
    ],
  );
}
```

#### Repository Testing

```dart
// test/features/notes/data/repositories/note_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:synapse/features/notes/data/repositories/note_repository_impl.dart';

class MockNoteLocalDataSource extends Mock implements NoteLocalDataSource {}

void main() {
  late NoteRepositoryImpl repository;
  late MockNoteLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockNoteLocalDataSource();
    repository = NoteRepositoryImpl(mockLocalDataSource);
  });

  group('getNotes', () {
    test('should return list of notes from local data source', () async {
      // Arrange
      final notes = [Note(id: '1', title: 'Test', content: 'Content')];
      when(mockLocalDataSource.getNotes()).thenAnswer((_) async => notes);

      // Act
      final result = await repository.getNotes();

      // Assert
      expect(result, equals(notes));
      verify(mockLocalDataSource.getNotes()).called(1);
    });
  });
}
```

### 2. Widget Testing

#### Widget Test

```dart
// test/features/notes/presentation/widgets/note_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:synapse/features/notes/presentation/widgets/note_card.dart';

void main() {
  testWidgets('NoteCard displays note title and content', (WidgetTester tester) async {
    final note = Note(
      id: '1',
      title: 'Test Note',
      content: 'Test content',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteCard(note: note),
        ),
      ),
    );

    expect(find.text('Test Note'), findsOneWidget);
    expect(find.text('Test content'), findsOneWidget);
  });

  testWidgets('NoteCard calls onTap when tapped', (WidgetTester tester) async {
    bool tapped = false;
    final note = Note(
      id: '1',
      title: 'Test Note',
      content: 'Test content',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteCard(
            note: note,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ListTile));
    expect(tapped, isTrue);
  });
}
```

### 3. Integration Testing

#### End-to-End Test

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:synapse/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Test', () {
    testWidgets('Create and save a note', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap the FAB to create a new note
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter note title
      await tester.enterText(
        find.byType(TextField).first,
        'Test Note',
      );

      // Enter note content
      await tester.enterText(
        find.byType(TextField).last,
        'This is a test note content',
      );

      // Save the note
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Verify note is saved
      expect(find.text('Test Note'), findsOneWidget);
      expect(find.text('This is a test note content'), findsOneWidget);
    });
  });
}
```

---

## 🐛 Debugging

### 1. Flutter Inspector

```bash
# Enable Flutter Inspector
flutter run --debug

# Use Flutter Inspector in IDE
# - VS Code: Flutter Inspector extension
# - Android Studio: Built-in Flutter Inspector
```

### 2. Logging

```dart
// lib/core/utils/logger.dart
import 'package:flutter/foundation.dart';

class Logger {
  static void debug(String message) {
    if (kDebugMode) {
      print('🔍 DEBUG: $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      print('ℹ️ INFO: $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ ERROR: $message');
      if (error != null) {
        print('Error: $error');
      }
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }
}
```

### 3. BLoC Debugging

```dart
// Enable BLoC observer for debugging
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    Logger.debug('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    Logger.error('${bloc.runtimeType} $error', error, stackTrace);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const SynapseApp());
}
```

---

## ⚡ Performance Optimization

### 1. Widget Optimization

```dart
// Use const constructors
const Text('Hello World')

// Use RepaintBoundary for expensive widgets
RepaintBoundary(
  child: ExpensiveWidget(),
)

// Use ListView.builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index].title),
  ),
)
```

### 2. Memory Management

```dart
// Dispose controllers
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// Use weak references for callbacks
class MyWidget extends StatefulWidget {
  final VoidCallback? onTap;

  const MyWidget({super.key, this.onTap});
}

// Avoid memory leaks in BLoCs
class MyBloc extends Bloc<MyEvent, MyState> {
  StreamSubscription? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

### 3. Database Optimization

```dart
// Use pagination for large datasets
Future<List<Note>> getNotes({int page = 0, int limit = 20}) async {
  final startIndex = page * limit;
  final endIndex = startIndex + limit;

  return await _box.values
      .skip(startIndex)
      .take(limit)
      .toList();
}

// Use background processing for heavy operations
Future<void> generateSummary(String content) async {
  return await compute(_processContent, content);
}

String _processContent(String content) {
  // Heavy processing
  return processedContent;
}
```

---

## 🚀 Deployment

### 1. Build Configuration

```yaml
# android/app/build.gradle
android {
compileSdkVersion 34

defaultConfig {
applicationId "com.synapse.app"
minSdkVersion 21
targetSdkVersion 34
versionCode 1
versionName "1.0.0"
}

buildTypes {
release {
signingConfig signingConfigs.release
minifyEnabled true
proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
}
}
}
```

### 2. Release Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build for specific platform
flutter build apk --release --target-platform android-arm64
```

### 3. Code Signing

```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configure signing
# android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path to keystore>
```

### 4. Play Store Deployment

```bash
# Bundle app
flutter build appbundle --release

# Upload to Play Console
# 1. Go to Google Play Console
# 2. Create new release
# 3. Upload app bundle
# 4. Fill release notes
# 5. Review and publish
```

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
