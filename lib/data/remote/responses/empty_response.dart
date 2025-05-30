import "dart:developer";

class EmptyResponse {
  EmptyResponse();
  EmptyResponse.fromJson({dynamic json}) {
    log(json);
  }
}
