# 🤝 Contributing to Synapse

Thank you for your interest in contributing to Synapse! This document provides guidelines and information for contributors.

## 📋 Table of Contents

1. [Getting Started](#getting-started)
2. [Development Setup](#development-setup)
3. [Code Style](#code-style)
4. [Testing](#testing)
5. [Pull Request Process](#pull-request-process)
6. [Issue Reporting](#issue-reporting)
7. [Feature Requests](#feature-requests)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.16.0 or higher
- Dart SDK 3.2.0 or higher
- Git
- Android Studio or VS Code
- Basic knowledge of Flutter and Dart

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/synapse.git
   cd synapse
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/original-owner/synapse.git
   ```

---

## 🛠️ Development Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Set Up Environment Variables

Create a `.env` file in the root directory:

```bash
GEMINI_API_KEY=your-gemini-api-key
```

### 3. Generate Code

```bash
flutter packages pub run build_runner build
```

### 4. Run the App

```bash
flutter run
```

### 5. Run Tests

```bash
flutter test
```

---

## 📝 Code Style

### Dart Style Guide

We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

### Key Guidelines

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

#### File Organization

```dart
// Import order
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_config.dart';
import '../shared/widgets/custom_widget.dart';

part 'note_event.dart';
part 'note_state.dart';
```

#### BLoC Pattern

```dart
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;

  NoteBloc(this._repository) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNote>(_onCreateNote);
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
}
```

#### Widget Structure

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
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
```

### Code Comments

- Add comments for complex logic
- Use documentation comments for public APIs
- Keep comments up-to-date with code changes

```dart
/// Generates an AI summary for the given content.
///
/// [content] The text content to summarize
/// Returns a [Future<String>] containing the summary
Future<String> generateSummary(String content) async {
  // Implementation
}
```

---

## 🧪 Testing

### Writing Tests

#### Unit Tests

```dart
// test/features/notes/presentation/bloc/notes_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:synapse/features/notes/presentation/bloc/notes_bloc.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late NotesBloc notesBloc;
  late MockNoteRepository mockRepository;

  setUp(() {
    mockRepository = MockNoteRepository();
    notesBloc = NotesBloc(mockRepository);
  });

  tearDown(() {
    notesBloc.close();
  });

  test('initial state should be NotesInitial', () {
    expect(notesBloc.state, equals(NotesInitial()));
  });

  blocTest<NotesBloc, NotesState>(
    'emits [NotesLoading, NotesLoaded] when LoadNotes is added',
    build: () {
      when(mockRepository.getNotes()).thenAnswer(
        (_) async => const <Note>[],
      );
      return notesBloc;
    },
    act: (bloc) => bloc.add(LoadNotes()),
    expect: () => [
      NotesLoading(),
      const NotesLoaded(<Note>[]),
    ],
  );
}
```

#### Widget Tests

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
}
```

#### Integration Tests

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

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'Test Note',
      );

      await tester.enterText(
        find.byType(TextField).last,
        'This is a test note content',
      );

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(find.text('Test Note'), findsOneWidget);
    });
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/notes/presentation/bloc/notes_bloc_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Test Coverage Requirements

- **Unit Tests**: > 80% coverage
- **Widget Tests**: > 70% coverage
- **Integration Tests**: > 60% coverage

---

## 🔄 Pull Request Process

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

- Follow the code style guidelines
- Write tests for new functionality
- Update documentation if needed

### 3. Commit Your Changes

```bash
git add .
git commit -m "feat: add new feature description

- Detailed description of changes
- Any breaking changes
- Related issue number"
```

### 4. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 5. Create a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your feature branch
4. Fill out the PR template
5. Submit the PR

### Pull Request Template

```markdown
## Description

Brief description of the changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] No breaking changes

## Related Issues

Closes #123
```

---

## 🐛 Issue Reporting

### Before Reporting

1. Check existing issues
2. Search the documentation
3. Try to reproduce the issue

### Issue Template

```markdown
## Bug Description

Clear description of the bug

## Steps to Reproduce

1. Step 1
2. Step 2
3. Step 3

## Expected Behavior

What should happen

## Actual Behavior

What actually happens

## Environment

- OS: Android/iOS
- Version: 1.0.0
- Device: Samsung Galaxy S21

## Additional Information

Screenshots, logs, etc.
```

### Issue Labels

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention needed

---

## 💡 Feature Requests

### Before Requesting

1. Check if the feature already exists
2. Search existing issues
3. Consider the impact on the app

### Feature Request Template

```markdown
## Feature Description

Clear description of the feature

## Use Case

Why this feature is needed

## Proposed Solution

How you think it should work

## Alternatives Considered

Other approaches you've thought about

## Additional Information

Mockups, examples, etc.
```

---

## 📚 Documentation

### Updating Documentation

- Keep documentation up-to-date with code changes
- Add documentation for new features
- Update user guides when UI changes

### Documentation Guidelines

- Use clear, concise language
- Include code examples
- Add screenshots for UI changes
- Keep documentation organized

---

## 🏷️ Version Control

### Commit Message Format

```
type(scope): description

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test changes
- `chore`: Build/tool changes

### Examples

```
feat(notes): add AI summary generation

- Integrate Gemini AI API
- Add summary display in editor
- Include retry mechanism for failed requests

Closes #123
```

---

## 🤝 Code Review

### Review Process

1. All PRs require review
2. Address review comments
3. Request re-review if needed
4. Merge only after approval

### Review Guidelines

- Check code style and formatting
- Verify tests are included
- Ensure documentation is updated
- Look for potential issues
- Provide constructive feedback

---

## 📞 Getting Help

### Communication Channels

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and discussions
- **Email**: support@synapse.app
- **Discord**: Community server

### Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Project Documentation](docs/)

---

## 🙏 Recognition

### Contributors

- Your name will be added to the contributors list
- Significant contributions will be highlighted
- You'll be mentioned in release notes

### Contribution Levels

- **Bronze**: 1-5 contributions
- **Silver**: 6-15 contributions
- **Gold**: 16+ contributions
- **Platinum**: Major feature contributions

---

## 📄 License

By contributing to Synapse, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Synapse! 🎉**
