import "dart:async";

import "package:esim_open_source/data/remote/responses/base_response_model.dart";

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
    return Resource<T>.error(
      e.toString(),
      error: GeneralError(
        message: e.toString(),
        errorCode: -1,
        exception: e as Exception?,
      ),
    );
  } on Object catch (e) {
    return Resource<T>.error(
      e.toString(),
      error: GeneralError(
        message: e.toString(),
        errorCode: -1,
        exception: Exception(e),
      ),
    );
  }
}
