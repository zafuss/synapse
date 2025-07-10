# 🧠 Synapse - Intelligent Note-Taking App

[![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.2.0-blue.svg)](https://dart.dev/)
[![BLoC](https://img.shields.io/badge/BLoC-8.1.3-purple.svg)](https://bloclibrary.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Your second brain** - Transform thoughts into organized knowledge with AI-powered note-taking.

## 🌟 Features

### 📝 Smart Note Creation

- **Simple Interface**: Clean, distraction-free writing experience
- **Dual Mode**: Switch between plain text and Markdown formatting
- **Auto-save**: Your work is saved automatically
- **Quick Actions**: Easy access to common functions

### 🧠 AI-Powered Summarization

- **Instant Summaries**: Get key points from long content with one tap
- **Smart Analysis**: AI understands context and meaning
- **Multiple Languages**: Works with various languages
- **Privacy-First**: Processing happens securely

### 📋 Markdown Support

- **Live Preview**: See formatting as you type
- **Full Syntax**: Complete Markdown support including:
  - Headings (# ## ###)
  - Bold and italic text (**bold** _italic_)
  - Lists (- item, 1. item)
  - Links ([text](url))
  - Code blocks (`code`)
  - Inline code (`code`)
- **Professional Output**: Clean, readable formatting
- **Export Options**: Share formatted content

### 💾 Local Storage

- **Device Storage**: All data stays on your device
- **No Internet Required**: Work offline anytime
- **Fast Access**: Instant note retrieval
- **Secure**: Your data never leaves your device

### 🔍 Search & Organization

- **Full-Text Search**: Find notes quickly
- **Smart Filtering**: Filter by date, content, or tags
- **Quick Access**: Recent notes at your fingertips

### 🎨 Customization

- **Dark/Light Mode**: Choose your preferred theme
- **Font Options**: Adjust text size and style
- **Layout Preferences**: Customize your workspace

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.16.0 or higher
- Dart SDK 3.2.0 or higher
- Android Studio or VS Code
- Android SDK (for Android development)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/synapse.git
   cd synapse
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure API keys**

   ```bash
   # Create a .env file or set environment variables
   export GEMINI_API_KEY="your-gemini-api-key"
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Install development dependencies**

   ```bash
   flutter pub get
   dart pub global activate build_runner
   ```

2. **Generate code**

   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

## 🏗️ Architecture

Synapse follows **Clean Architecture** principles with **Domain-Driven Design** and **BLoC pattern** for state management.

### Project Structure

```
synapse/
├── 📱 lib/
│   ├── main.dart                    # Application entry point
│   ├── app.dart                     # App configuration
│   ├── core/                        # Shared core functionality
│   │   ├── constants/               # App constants
│   │   ├── errors/                  # Error handling
│   │   ├── utils/                   # Utility functions
│   │   ├── network/                 # Network utilities
│   │   └── di/                      # Dependency injection
│   ├── features/                    # Feature modules
│   │   ├── notes/                   # Notes feature
│   │   │   ├── domain/              # Business logic
│   │   │   ├── data/                # Data layer
│   │   │   └── presentation/        # UI layer
│   │   ├── editor/                  # Editor feature
│   │   ├── ai_summary/              # AI summary feature
│   │   └── settings/                # Settings feature
│   ├── shared/                      # Shared components
│   │   ├── widgets/                 # Reusable widgets
│   │   ├── themes/                  # App themes
│   │   └── utils/                   # Shared utilities
│   └── infrastructure/              # Infrastructure layer
│       ├── services/                # External services
│       └── repositories/            # Repository implementations
├── 📦 pubspec.yaml                  # Dependencies
├── 🧪 test/                         # Test files
└── 📋 docs/                         # Documentation
```

### Technology Stack

- **Framework**: Flutter 3.16.0+
- **Language**: Dart 3.2.0+
- **State Management**: BLoC (flutter_bloc 8.1.3)
- **Local Storage**: Hive 2.2.3
- **Markdown**: markdown_widget 2.3.2
- **AI Integration**: Google Gemini API
- **HTTP Client**: Dio 5.3.2

## 📱 Screenshots

### Notes List

![Notes List](docs/assets/screenshots/notes-list.png)

### Editor

![Editor](docs/assets/screenshots/editor.png)

### Markdown Preview

![Markdown Preview](docs/assets/screenshots/markdown-preview.png)

### Settings

![Settings](docs/assets/screenshots/settings.png)

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/notes/presentation/bloc/notes_bloc_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Coverage

- **Unit Tests**: > 80% coverage
- **Widget Tests**: > 70% coverage
- **Integration Tests**: > 60% coverage

## 📚 Documentation

### User Documentation

- [User Guide](docs/user/README.md) - Complete user manual
- [Feature Guide](docs/user/features.md) - Detailed feature explanations
- [FAQ](docs/user/faq.md) - Frequently asked questions

### Developer Documentation

- [Technical Architecture](docs/developer/architecture.md) - System architecture
- [Development Guide](docs/developer/development.md) - Development setup and guidelines
- [API Documentation](docs/developer/api.md) - API specifications
- [Testing Guide](docs/developer/testing.md) - Testing strategies and procedures

### Project Documentation

- [Project Plan](docs/project/plan.md) - Development roadmap and milestones
- [Requirements](docs/project/requirements.md) - Functional and non-functional requirements
- [Release Notes](docs/project/releases.md) - Version history and changelog

## 🔧 Configuration

### Environment Variables

```bash
# Required
GEMINI_API_KEY=your-gemini-api-key

# Optional
GEMINI_API_URL=https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent
```

### App Configuration

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

## 🚀 Deployment

### Building for Production

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build for specific platform
flutter build apk --release --target-platform android-arm64
```

### App Store Deployment

1. Create production build
2. Test on multiple devices
3. Prepare app store assets
4. Submit to Google Play Console
5. Monitor for approval

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - The amazing framework
- [BLoC](https://bloclibrary.dev/) - State management solution
- [Hive](https://pub.dev/packages/hive) - Local database
- [Google Gemini AI](https://ai.google.dev/) - AI capabilities
- [Material Design](https://material.io/) - Design system

## 📞 Support

- **Email**: support@synapse.app
- **Documentation**: [docs.synapse.app](https://docs.synapse.app)
- **Issues**: [GitHub Issues](https://github.com/your-username/synapse/issues)
- **Community**: [Discord](https://discord.gg/synapse)

## 📊 Project Status

- **Version**: 1.0.0
- **Status**: In Development
- **Target Platform**: Android (Google Play Store)
- **Future Platforms**: iOS, Web, Desktop

---

**Made with ❤️ by the Synapse Team**
