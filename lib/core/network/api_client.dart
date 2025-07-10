import 'package:dio/dio.dart';
import '../constants/app_config.dart';
import '../errors/app_exception.dart';
import '../utils/logger.dart';
import '../utils/result.dart';

/// API client for making HTTP requests
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.geminiApiUrl,
        connectTimeout: AppConfig.apiTimeout,
        receiveTimeout: AppConfig.apiTimeout,
        sendTimeout: AppConfig.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([_LoggingInterceptor(), _ErrorInterceptor()]);
  }

  /// Make a GET request
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return Logger.logAsyncExecutionTime('GET $path', () async {
      try {
        final response = await _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: options,
        );
        return Success(response.data as T);
      } on DioException catch (e) {
        return Failure(_handleDioError(e));
      } catch (e, stackTrace) {
        Logger.error(
          'Unexpected error in GET request',
          e,
          stackTrace,
          'ApiClient',
        );
        return Failure(NetworkException('Unexpected error: $e'));
      }
    });
  }

  /// Make a POST request
  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return Logger.logAsyncExecutionTime('POST $path', () async {
      try {
        final response = await _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        return Success(response.data as T);
      } on DioException catch (e) {
        return Failure(_handleDioError(e));
      } catch (e, stackTrace) {
        Logger.error(
          'Unexpected error in POST request',
          e,
          stackTrace,
          'ApiClient',
        );
        return Failure(NetworkException('Unexpected error: $e'));
      }
    });
  }

  /// Make a PUT request
  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return Logger.logAsyncExecutionTime('PUT $path', () async {
      try {
        final response = await _dio.put<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        return Success(response.data as T);
      } on DioException catch (e) {
        return Failure(_handleDioError(e));
      } catch (e, stackTrace) {
        Logger.error(
          'Unexpected error in PUT request',
          e,
          stackTrace,
          'ApiClient',
        );
        return Failure(NetworkException('Unexpected error: $e'));
      }
    });
  }

  /// Make a DELETE request
  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return Logger.logAsyncExecutionTime('DELETE $path', () async {
      try {
        final response = await _dio.delete<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        return Success(response.data as T);
      } on DioException catch (e) {
        return Failure(_handleDioError(e));
      } catch (e, stackTrace) {
        Logger.error(
          'Unexpected error in DELETE request',
          e,
          stackTrace,
          'ApiClient',
        );
        return Failure(NetworkException('Unexpected error: $e'));
      }
    });
  }

  /// Handle Dio errors and convert them to AppException
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Request timeout',
          code: 'TIMEOUT',
          originalError: error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.statusMessage ?? 'Bad response';
        return ApiException(
          message,
          code: 'HTTP_ERROR',
          statusCode: statusCode,
          originalError: error,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          'Request cancelled',
          code: 'CANCELLED',
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection',
          code: 'NO_CONNECTION',
          originalError: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          'SSL certificate error',
          code: 'SSL_ERROR',
          originalError: error,
        );

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          'Unknown network error',
          code: 'UNKNOWN',
          originalError: error,
        );
    }
  }
}

/// Logging interceptor for Dio
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.api('REQUEST: ${options.method} ${options.uri}', 'DioInterceptor');
    Logger.verbose('Headers: ${options.headers}', 'DioInterceptor');
    if (options.data != null) {
      Logger.verbose('Body: ${options.data}', 'DioInterceptor');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.api(
      'RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      'DioInterceptor',
    );
    Logger.verbose('Headers: ${response.headers}', 'DioInterceptor');
    if (response.data != null) {
      Logger.verbose('Body: ${response.data}', 'DioInterceptor');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.error(
      'ERROR: ${err.type} ${err.requestOptions.uri}',
      err,
      null,
      'DioInterceptor',
    );
    handler.next(err);
  }
}

/// Error handling interceptor for Dio
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Add any global error handling logic here
    // For example, refresh tokens, retry logic, etc.
    handler.next(err);
  }
}
