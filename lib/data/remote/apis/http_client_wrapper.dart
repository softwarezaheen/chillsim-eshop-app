import "dart:async";
import "dart:io";

import "package:chucker_flutter/chucker_flutter.dart";
import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:http/http.dart" as http;
import "package:http/io_client.dart";

typedef RequestInterceptor = FutureOr<http.BaseRequest> Function(
  http.BaseRequest request,
  APIEndPoint endPoint,
);
typedef ResponseInterceptor = FutureOr<http.BaseResponse> Function(
  http.BaseResponse response,
  APIEndPoint endPoint,
);
typedef TokenRefresher = FutureOr<void> Function();

class HttpClientWrapper extends http.BaseClient {
  HttpClientWrapper({
    required SecurityContext? securityContext,
    required TokenRefresher tokenRefresher,
    List<RequestInterceptor>? requestInterceptors,
    List<ResponseInterceptor>? responseInterceptors,
  })  : _client = ChuckerHttpClient(
          IOClient(
            HttpClient(context: securityContext)
              ..badCertificateCallback =
                  (X509Certificate cert, String host, int port) => false,
          ),
        ),
        _requestInterceptors = requestInterceptors ?? <RequestInterceptor>[],
        _responseInterceptors = responseInterceptors ?? <ResponseInterceptor>[],
        _tokenRefresher = tokenRefresher;
  final ChuckerHttpClient _client;
  final List<RequestInterceptor> _requestInterceptors;
  final List<ResponseInterceptor> _responseInterceptors;
  final TokenRefresher _tokenRefresher;

  Future<http.StreamedResponse> mySend(
    http.BaseRequest request,
    APIEndPoint endPoint,
  ) async {
    http.BaseRequest refRequest = request;

    // Apply request interceptors
    for (RequestInterceptor interceptor in _requestInterceptors) {
      final FutureOr<http.BaseRequest> result =
          interceptor(refRequest, endPoint);
      if (result is Future<http.BaseRequest>) {
        refRequest = await result;
      } else {
        refRequest = result;
      }
    }

    // Send the request
    http.StreamedResponse response = await _client.send(refRequest);

    // Apply response interceptors
    http.BaseResponse interceptedResponse = response;
    for (ResponseInterceptor interceptor in _responseInterceptors) {
      final FutureOr<http.BaseResponse> result =
          interceptor(interceptedResponse, endPoint);
      if (result is Future<http.BaseResponse>) {
        interceptedResponse = await result;
      } else {
        interceptedResponse = result;
      }
    }

    // Check for token expiration and refresh token if needed
    if (_isTokenExpired(interceptedResponse) && !endPoint.isRefreshToken) {
      await _tokenRefresher();
      final http.StreamedResponse retryResponse =
          await _retryRequest(refRequest, endPoint);
      return retryResponse;
    }

    return interceptedResponse as http.StreamedResponse;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    throw Exception("Calling Default Send");
    // // Send the request
    // var response = await _client.send(request);
    //
    // return response as http.StreamedResponse;
  }

  bool _isTokenExpired(http.BaseResponse response) {
    // Implement your logic to check if the token has expired
    return response.statusCode == 401; // Example: 401 Unauthorized
  }

  Future<http.StreamedResponse> _retryRequest(
    http.BaseRequest request,
    APIEndPoint endPoint,
  ) async {
    // Clone the original request and resend it with the refreshed token
    // final clonedRequest = http.Request(request.method, request.url)
    //   ..headers.addAll(request.headers)
    //   ..body = (request as dynamic).body;

    http.BaseRequest refRequest = request;

    // Apply request interceptors
    for (RequestInterceptor interceptor in _requestInterceptors) {
      final FutureOr<http.BaseRequest> result =
          interceptor(refRequest, endPoint);
      if (result is Future<http.BaseRequest>) {
        refRequest = await result;
      } else {
        refRequest = result;
      }
    }

    // Send the request
    http.StreamedResponse response =
        await _client.send(_cloneBaseRequest(refRequest));

    // Apply response interceptors
    http.BaseResponse interceptedResponse = response;
    for (ResponseInterceptor interceptor in _responseInterceptors) {
      final FutureOr<http.BaseResponse> result =
          interceptor(interceptedResponse, endPoint);
      if (result is Future<http.BaseResponse>) {
        interceptedResponse = await result;
      } else {
        interceptedResponse = result;
      }
    }

    return interceptedResponse as http.StreamedResponse;
  }

  http.BaseRequest _cloneBaseRequest(http.BaseRequest original) {
    final http.Request cloned = http.Request(original.method, original.url)
      ..headers.addAll(original.headers)
      ..persistentConnection = original.persistentConnection
      ..followRedirects = original.followRedirects
      ..maxRedirects = original.maxRedirects;

    // Clone body
    if (original is http.Request) {
      final http.Request request = original;
      if (request.body.isNotEmpty) {
        cloned.body = request.body;
      }
      if (request.bodyBytes.isNotEmpty) {
        cloned.bodyBytes = request.bodyBytes;
      }
    }

    // Clone multipart request
    if (original is http.MultipartRequest) {
      final http.MultipartRequest multipart = original;
      final http.MultipartRequest clonedMultipart =
          cloned as http.MultipartRequest;

      clonedMultipart.fields.addAll(multipart.fields);
      clonedMultipart.files.addAll(multipart.files);
    }

    return cloned;
  }

  @override
  void close() {
    _client.close();
  }
}
