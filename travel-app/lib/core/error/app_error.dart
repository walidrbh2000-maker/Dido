import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
sealed class AppError with _$AppError {
  const factory AppError.network(String message) = NetworkError;
  const factory AppError.unauthorized() = UnauthorizedError;
  const factory AppError.notFound(String resource) = NotFoundError;
  const factory AppError.serverError(String message) = ServerError;
  const factory AppError.validation(Map<String, List<String>> errors) = ValidationError;
  const factory AppError.unknown(Object error) = UnknownError;
}
