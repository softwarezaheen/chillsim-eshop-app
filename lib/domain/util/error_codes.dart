/// Error codes for categorizing different types of failures
class ErrorCodes {
  /// Network connection was lost or interrupted
  static const int networkConnectionLost = -1001;
  
  /// Request timed out
  static const int networkTimeout = -1002;
  
  /// No internet connection available
  static const int networkUnavailable = -1003;
  
  /// Server is temporarily unavailable
  static const int serverUnavailable = -1004;
  
  /// Unknown error occurred
  static const int unknown = -1999;
  
  /// Check if an error code represents a retryable network error
  static bool isRetryable(int? errorCode) {
    return errorCode == networkConnectionLost ||
        errorCode == networkTimeout ||
        errorCode == networkUnavailable;
  }
}
