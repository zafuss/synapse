class AppConfig {
  // App Information
  static const String appName = 'Synapse';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'AI-powered note-taking app with Markdown support';

  // API Configuration
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // App Configuration
  static const int maxNoteLength = 10000;
  static const int maxTitleLength = 100;
  static const Duration autoSaveInterval = Duration(seconds: 30);
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Configuration
  static const String notesBoxName = 'notes';
  static const String settingsBoxName = 'settings';
  static const String summariesBoxName = 'summaries';

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultIconSize = 24.0;

  // Search Configuration
  static const int maxSearchResults = 50;
  static const Duration searchDebounceTime = Duration(milliseconds: 300);

  // AI Configuration
  static const int maxSummaryLength = 500;
  static const int maxContentForSummary = 5000;
  static const Duration summaryCacheExpiry = Duration(hours: 24);

  // Export Configuration
  static const List<String> supportedExportFormats = ['txt', 'md', 'json'];
  static const String defaultExportFormat = 'md';

  // Theme Configuration
  static const String defaultTheme = 'system';
  static const String defaultFontSize = 'medium';
  static const String defaultNoteType = 'text';

  // Performance Configuration
  static const int maxNotesInMemory = 100;
  static const Duration cacheExpiryTime = Duration(hours: 1);
  static const int maxUndoSteps = 10;

  // Security Configuration
  static const bool enableEncryption = true;
  static const String encryptionAlgorithm = 'AES-256';
  static const Duration sessionTimeout = Duration(hours: 24);

  // Analytics Configuration
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
  static const bool enablePerformanceMonitoring = false;

  // Development Configuration
  static const bool enableDebugMode = bool.fromEnvironment(
    'DEBUG',
    defaultValue: false,
  );
  static const bool enableVerboseLogging = bool.fromEnvironment(
    'VERBOSE_LOGGING',
    defaultValue: false,
  );
  static const String logLevel = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: 'info',
  );
}
