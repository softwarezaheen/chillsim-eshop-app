import "dart:convert";

import "package:esim_open_source/data/remote/base_api_services.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

abstract interface class URlRequestBuilder {
  String get baseURL;

  String get path;

  HttpMethod get method;

  bool get hasAuthorization;

  bool get isRefreshToken;

  Map<String, String> get headers;
}

class APIEndPoint implements URlRequestBuilder {
  APIEndPoint({
    required this.path,
    required this.method,
    this.enumBaseURL = "",
    this.hasAuthorization = false,
    this.headers = const <String, String>{},
    this.isRefreshToken = false,
    this.parameters = const <String, dynamic>{},
  });
  final String enumBaseURL;

  @override
  final String path;

  @override
  final HttpMethod method;

  @override
  final bool hasAuthorization;

  @override
  final bool isRefreshToken;

  @override
  final Map<String, String> headers;

  final Map<String, dynamic> parameters;

  @override
  String get baseURL {
    if (enumBaseURL.isEmpty) {
      return BaseApiService.baseURL;
    }
    return enumBaseURL;
  }

  String get fullURL {
    return baseURL + path;
  }

  String toCurlCommand() {
    final StringBuffer buffer = StringBuffer()
      ..writeln("curl -X ${method.name} ${baseURL + path}");

    headers.forEach((String key, String value) {
      buffer.writeln('-H "$key: $value"');
    });

    if (parameters.isNotEmpty) {
      final String jsonBody = jsonEncode(parameters);

      buffer.writeln("-d '$jsonBody'");
    }

    return buffer.toString();
  }
}
