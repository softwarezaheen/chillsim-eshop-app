import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/domain/util/error_codes.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:http/http.dart" show ClientException;

class Resource<T> {
  Resource({required this.resourceType, this.data, this.message, this.error});

  factory Resource.success(T data, {required String? message}) => Resource<T>(
        data: data,
        resourceType: ResourceType.success,
        message: message,
      );

  factory Resource.error(String message, {T? data, GeneralError? error}) =>
      Resource<T>(
        data: data,
        message: message,
        error: error,
        resourceType: ResourceType.error,
      );

  factory Resource.loading({T? data}) =>
      Resource<T>(data: data, resourceType: ResourceType.loading);
  final ResourceType resourceType;
  final T? data;
  final String? message;
  final GeneralError? error;
}

class GeneralError {
  GeneralError({
    required this.message,
    this.errorCode,
    this.exception,
  });
  final int? errorCode;
  final String message;
  final Exception? exception;
}

enum ResourceType { success, error, loading }

FutureOr<Resource<T>> responseToResource<T>(FutureOr<dynamic> request) async {
  try {
    ResponseMain<T> response = await request;
    if (response.statusCode == 200) {
      return Resource<T>.success(
        response.dataOfType,
        message: response.message,
      );
    }
    return Resource<T>.error(
      response.developerMessage ?? "",
      data: response.data,
      error: GeneralError(
        message: response.title ?? "",
        errorCode: response.responseCode,
      ),
    );
  } on SocketException catch (e) {
    // Network connectivity issues (connection lost, reset, etc.)
    final String message = LocaleKeys.error_network_connection_lost.tr();
    return Resource<T>.error(
      message,
      error: GeneralError(
        message: message,
        errorCode: ErrorCodes.networkConnectionLost,
        exception: e,
      ),
    );
  } on TimeoutException catch (e) {
    // Request timeout
    final String message = LocaleKeys.error_network_timeout.tr();
    return Resource<T>.error(
      message,
      error: GeneralError(
        message: message,
        errorCode: ErrorCodes.networkTimeout,
        exception: e,
      ),
    );
  } on ClientException catch (e) {
    // HTTP client issues (connection reset, refused, etc.)
    final String message = LocaleKeys.error_network_connection_lost.tr();
    return Resource<T>.error(
      message,
      error: GeneralError(
        message: message,
        errorCode: ErrorCodes.networkConnectionLost,
        exception: e,
      ),
    );
  } on ResponseMainException catch (ex) {
    return Resource<T>.error(
      ex.message ?? "",
      error: GeneralError(
        message: ex.message ?? "",
        errorCode: ex.errorCode,
        exception: ex,
      ),
    );
  } on Exception catch (e) {
    // Fallback for unknown exceptions - use user-friendly message
    final String message = LocaleKeys.error_unknown.tr();
    return Resource<T>.error(
      message,
      error: GeneralError(
        message: message,
        errorCode: ErrorCodes.unknown,
        exception: e,
      ),
    );
  } on Object catch (e) {
    // Fallback for non-exception errors
    final String message = LocaleKeys.error_unknown.tr();
    return Resource<T>.error(
      message,
      error: GeneralError(
        message: message,
        errorCode: ErrorCodes.unknown,
        exception: Exception(e),
      ),
    );
  }
}
