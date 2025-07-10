import 'package:flutter/foundation.dart';
import '../constants/app_config.dart';

/// Logger utility for the application
class Logger {
  static const String _tag = 'Synapse';

  /// Log a debug message
  static void debug(String message, [String? tag]) {
    if (AppConfig.enableDebugMode || AppConfig.enableVerboseLogging) {
      _log('🔍 DEBUG', message, tag);
    }
  }

  /// Log an info message
  static void info(String message, [String? tag]) {
    if (AppConfig.enableDebugMode) {
      _log('ℹ️ INFO', message, tag);
    }
  }

  /// Log a warning message
  static void warning(String message, [String? tag]) {
    if (AppConfig.enableDebugMode) {
      _log('⚠️ WARNING', message, tag);
    }
  }

  /// Log an error message
  static void error(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  ]) {
    if (AppConfig.enableDebugMode) {
      _log('❌ ERROR', message, tag);
      if (error != null) {
        print('Error: $error');
      }
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }

  /// Log a verbose message
  static void verbose(String message, [String? tag]) {
    if (AppConfig.enableVerboseLogging) {
      _log('🔍 VERBOSE', message, tag);
    }
  }

  /// Log performance metrics
  static void performance(String message, [String? tag]) {
    if (AppConfig.enablePerformanceMonitoring) {
      _log('⚡ PERFORMANCE', message, tag);
    }
  }

  /// Log API calls
  static void api(String message, [String? tag]) {
    if (AppConfig.enableDebugMode) {
      _log('🌐 API', message, tag);
    }
  }

  /// Log database operations
  static void database(String message, [String? tag]) {
    if (AppConfig.enableDebugMode) {
      _log('💾 DATABASE', message, tag);
    }
  }

  /// Log UI interactions
  static void ui(String message, [String? tag]) {
    if (AppConfig.enableDebugMode) {
      _log('🎨 UI', message, tag);
    }
  }

  /// Log AI service calls
  static void ai(String message, [String? tag]) {
    if (AppConfig.enableDebugMode) {
      _log('🤖 AI', message, tag);
    }
  }

  /// Internal logging method
  static void _log(String level, String message, String? tag) {
    final timestamp = DateTime.now().toIso8601String();
    final logTag = tag ?? _tag;
    print('[$timestamp] $level [$logTag]: $message');
  }

  /// Log method execution time
  static T logExecutionTime<T>(String methodName, T Function() method) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = method();
      stopwatch.stop();
      performance('$methodName executed in ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      error(
        '$methodName failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Log async method execution time
  static Future<T> logAsyncExecutionTime<T>(
    String methodName,
    Future<T> Function() method,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await method();
      stopwatch.stop();
      performance('$methodName executed in ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      error(
        '$methodName failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
