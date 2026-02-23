import "package:esim_open_source/domain/util/error_codes.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/views/base/mixins/dialog_utilities_mixin.dart";
import "package:esim_open_source/presentation/views/base/mixins/view_state_manager_mixin.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";

mixin ResponseHandlerMixin on BaseViewModel {
  Future<void> handleResponse<T>(
    Resource<T> response, {
    required Future<void> Function(Resource<T>) onSuccess,
    Future<void> Function(Resource<T>)? onFailure,
  }) async {
    switch (response.resourceType) {
      case ResourceType.success:
        playHapticFeedback(HapticFeedbackType.apiSuccess);
        await onSuccess(response);
      case ResourceType.error:
        playHapticFeedback(HapticFeedbackType.apiError);
        if (onFailure == null) {
          await handleError(response);
          return;
        }
        await onFailure(response);
      case ResourceType.loading:
        handleLoading();
    }
  }

  Future<void> handleError(
    Resource<dynamic> response, {
    VoidCallback? onRetry,
  }) async {
    if (this is DialogUtilitiesMixin) {
      final mixin = this as DialogUtilitiesMixin;
      
      // Check if this is a retryable network error
      final bool isRetryable = ErrorCodes.isRetryable(response.error?.errorCode);
      
      if (isRetryable && onRetry != null) {
        // Show dialog with Retry button
        await mixin.showErrorDialogWithRetry(
          title: response.error?.message,
          message: response.message,
          onRetry: onRetry,
        );
      } else {
        // Show standard error (dismiss only)
        await mixin.showNativeErrorMessage(
          response.error?.message,
          response.message,
        );
      }
    }
    if (this is ViewStateManagerMixin) {
      (this as ViewStateManagerMixin).setIdleState();
    }
  }

  void handleLoading() {
    if (this is ViewStateManagerMixin) {
      (this as ViewStateManagerMixin).handleLoading();
    }
  }
}
