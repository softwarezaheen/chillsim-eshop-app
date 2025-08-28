import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";

import "test_constants.dart";

// Status enum for backwards compatibility with existing tests
enum Status { success, error, loading }

/// Mixin providing common validation patterns for Resource objects.
/// This eliminates duplicate assertion code across repository tests.
mixin ResourceTestMixin {
  // MARK: - Success Resource Validations

  /// Validate that a resource represents a successful operation
  void expectSuccessResource<T>(
    Resource<T> resource, {
    T? expectedData,
    String? expectedMessage,
    int? expectedCode,
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "Resource should be successful";

    expect(
      resource,
      isA<Resource<T>>(),
      reason: "$description - should be Resource<$T>",
    );
    expect(
      resource.resourceType,
      equals(ResourceType.success),
      reason: "$description - should have success status",
    );

    if (expectedData != null) {
      expect(
        resource.data,
        equals(expectedData),
        reason: "$description - should have expected data",
      );
    } else {
      expect(
        resource.data,
        isNotNull,
        reason: "$description - should have non-null data",
      );
    }

    if (expectedMessage != null) {
      expect(
        resource.message,
        equals(expectedMessage),
        reason: "$description - should have expected message",
      );
    }

    if (expectedCode != null) {
      expect(
        resource.error?.errorCode,
        equals(expectedCode),
        reason: "$description - should have expected code",
      );
    }
  }

  /// Validate success resource with custom data validation
  void expectSuccessResourceWithCustomValidation<T>(
    Resource<T> resource,
    void Function(T data) dataValidator, {
    String? expectedMessage,
    int? expectedCode,
    String? testDescription,
  }) {
    expectSuccessResource<T>(
      resource,
      expectedMessage: expectedMessage,
      expectedCode: expectedCode,
      testDescription: testDescription,
    );

    if (resource.data != null) {
      dataValidator(resource.data as T);
    }
  }

  /// Validate success resource with list data
  void expectSuccessResourceWithList<T>(
    Resource<List<T>> resource, {
    int? expectedCount,
    bool allowEmpty = true,
    String? expectedMessage,
    int? expectedCode,
    String? testDescription,
  }) {
    expectSuccessResource<List<T>>(
      resource,
      expectedMessage: expectedMessage,
      expectedCode: expectedCode,
      testDescription: testDescription,
    );

    final List<T> data = resource.data!;

    if (expectedCount != null) {
      expect(
        data.length,
        equals(expectedCount),
        reason: "${testDescription ?? 'Resource'} - should have expected count",
      );
    }

    if (!allowEmpty) {
      expect(
        data.isNotEmpty,
        isTrue,
        reason: "${testDescription ?? 'Resource'} - should not be empty",
      );
    }
  }

  // MARK: - Error Resource Validations

  /// Validate that a resource represents an error operation
  void expectErrorResource<T>(
    Resource<T> resource, {
    String? expectedMessage,
    int? expectedCode,
    T? expectedData,
    String? testDescription,
  }) {
    final String description = testDescription ?? "Resource should be error";

    expect(
      resource,
      isA<Resource<T>>(),
      reason: "$description - should be Resource<$T>",
    );
    expect(
      resource.resourceType,
      equals(ResourceType.error),
      reason: "$description - should have error status",
    );

    if (expectedMessage != null) {
      expect(
        resource.message,
        contains(expectedMessage),
        reason: "$description - should contain expected error message",
      );
    } else {
      expect(
        resource.message,
        isNotNull,
        reason: "$description - should have error message",
      );
      expect(
        resource.message!.isNotEmpty,
        isTrue,
        reason: "$description - error message should not be empty",
      );
    }

    if (expectedCode != null) {
      expect(
        resource.error?.errorCode,
        equals(expectedCode),
        reason: "$description - should have expected error code",
      );
    }

    if (expectedData != null) {
      expect(
        resource.data,
        equals(expectedData),
        reason: "$description - should have expected data",
      );
    }
  }

  /// Validate error resource with specific error codes
  void expectErrorResourceWithCode<T>(
    Resource<T> resource,
    int expectedCode, {
    String? expectedMessage,
    String? testDescription,
  }) {
    expectErrorResource<T>(
      resource,
      expectedCode: expectedCode,
      expectedMessage: expectedMessage,
      testDescription: testDescription,
    );
  }

  /// Validate error resource for common HTTP error codes
  void expectBadRequestError<T>(
    Resource<T> resource, {
    String? expectedMessage,
  }) {
    expectErrorResourceWithCode<T>(
      resource,
      TestConstants.httpBadRequest,
      expectedMessage: expectedMessage,
      testDescription: "Resource should be bad request error",
    );
  }

  void expectUnauthorizedError<T>(
    Resource<T> resource, {
    String? expectedMessage,
  }) {
    expectErrorResourceWithCode<T>(
      resource,
      TestConstants.httpUnauthorized,
      expectedMessage: expectedMessage,
      testDescription: "Resource should be unauthorized error",
    );
  }

  void expectForbiddenError<T>(
    Resource<T> resource, {
    String? expectedMessage,
  }) {
    expectErrorResourceWithCode<T>(
      resource,
      TestConstants.httpForbidden,
      expectedMessage: expectedMessage,
      testDescription: "Resource should be forbidden error",
    );
  }

  void expectNotFoundError<T>(Resource<T> resource, {String? expectedMessage}) {
    expectErrorResourceWithCode<T>(
      resource,
      TestConstants.httpNotFound,
      expectedMessage: expectedMessage,
      testDescription: "Resource should be not found error",
    );
  }

  void expectServerError<T>(Resource<T> resource, {String? expectedMessage}) {
    expectErrorResourceWithCode<T>(
      resource,
      TestConstants.httpInternalServerError,
      expectedMessage: expectedMessage,
      testDescription: "Resource should be server error",
    );
  }

  void expectNetworkError<T>(Resource<T> resource) {
    expectErrorResource<T>(
      resource,
      expectedMessage: TestConstants.testNetworkErrorMessage,
      testDescription: "Resource should be network error",
    );
  }

  // MARK: - Loading Resource Validations

  /// Validate that a resource represents a loading operation
  void expectLoadingResource<T>(
    Resource<T> resource, {
    String? expectedMessage,
    T? expectedData,
    String? testDescription,
  }) {
    final String description = testDescription ?? "Resource should be loading";

    expect(
      resource,
      isA<Resource<T>>(),
      reason: "$description - should be Resource<$T>",
    );
    expect(
      resource.resourceType,
      equals(ResourceType.loading),
      reason: "$description - should have loading status",
    );

    if (expectedMessage != null) {
      expect(
        resource.message,
        equals(expectedMessage),
        reason: "$description - should have expected message",
      );
    }

    if (expectedData != null) {
      expect(
        resource.data,
        equals(expectedData),
        reason: "$description - should have expected data",
      );
    }
  }

  // MARK: - Resource State Validations

  /// Validate that resource is not null and has expected type
  void expectValidResource<T>(Resource<T> resource) {
    expect(resource, isNotNull, reason: "Resource should not be null");
    expect(
      resource,
      isA<Resource<T>>(),
      reason: "Resource should be of correct type",
    );
    expect(
      resource.resourceType,
      isA<ResourceType>(),
      reason: "Resource should have valid resource type",
    );
  }

  /// Validate resource status without checking other properties
  void expectResourceStatus<T>(
    Resource<T> resource,
    ResourceType expectedStatus,
  ) {
    expectValidResource<T>(resource);
    expect(
      resource.resourceType,
      equals(expectedStatus),
      reason: "Resource should have status: $expectedStatus",
    );
  }

  /// Validate that resource has data regardless of status
  void expectResourceWithData<T>(Resource<T> resource) {
    expectValidResource<T>(resource);
    expect(resource.data, isNotNull, reason: "Resource should have data");
  }

  /// Validate that resource has message regardless of status
  void expectResourceWithMessage<T>(Resource<T> resource) {
    expectValidResource<T>(resource);
    expect(resource.message, isNotNull, reason: "Resource should have message");
    expect(
      resource.message!.isNotEmpty,
      isTrue,
      reason: "Resource message should not be empty",
    );
  }

  // MARK: - Composite Resource Validations

  /// Validate resource through its complete lifecycle (loading -> success/error)
  void expectResourceLifecycle<T>(
    List<Resource<T>> resources,
    ResourceType finalStatus, {
    T? expectedFinalData,
    String? expectedFinalMessage,
  }) {
    expect(
      resources.isNotEmpty,
      isTrue,
      reason: "Should have at least one resource state",
    );

    // Validate all resources are valid
    for (final Resource<T> resource in resources) {
      expectValidResource<T>(resource);
    }

    // Validate final state
    final Resource<T> finalResource = resources.last;
    expect(
      finalResource.resourceType,
      equals(finalStatus),
      reason: "Final resource should have expected status",
    );

    if (expectedFinalData != null) {
      expect(
        finalResource.data,
        equals(expectedFinalData),
        reason: "Final resource should have expected data",
      );
    }

    if (expectedFinalMessage != null) {
      expect(
        finalResource.message,
        equals(expectedFinalMessage),
        reason: "Final resource should have expected message",
      );
    }
  }

  // MARK: - Resource Comparison Utilities

  /// Compare two resources for equality
  void expectResourcesEqual<T>(Resource<T> resource1, Resource<T> resource2) {
    expect(
      resource1.resourceType,
      equals(resource2.resourceType),
      reason: "Resources should have same status",
    );
    expect(
      resource1.data,
      equals(resource2.data),
      reason: "Resources should have same data",
    );
    expect(
      resource1.message,
      equals(resource2.message),
      reason: "Resources should have same message",
    );
    expect(
      resource1.error?.errorCode,
      equals(resource2.error?.errorCode),
      reason: "Resources should have same error code",
    );
  }

  /// Validate that resource has changed from previous state
  void expectResourceChanged<T>(
    Resource<T> oldResource,
    Resource<T> newResource,
  ) {
    expectValidResource<T>(oldResource);
    expectValidResource<T>(newResource);

    final bool hasChanged =
        oldResource.resourceType != newResource.resourceType ||
            oldResource.data != newResource.data ||
            oldResource.message != newResource.message ||
            oldResource.error?.errorCode != newResource.error?.errorCode;

    expect(
      hasChanged,
      isTrue,
      reason: "Resource should have changed from previous state",
    );
  }

  // MARK: - Batch Resource Validations

  /// Validate multiple resources have the same status
  void expectAllResourcesHaveStatus<T>(
    List<Resource<T>> resources,
    ResourceType expectedStatus,
  ) {
    expect(
      resources.isNotEmpty,
      isTrue,
      reason: "Should have resources to validate",
    );

    for (int i = 0; i < resources.length; i++) {
      expect(
        resources[i].resourceType,
        equals(expectedStatus),
        reason: "Resource at index $i should have status: $expectedStatus",
      );
    }
  }

  /// Validate that all resources are successful
  void expectAllResourcesSuccessful<T>(List<Resource<T>> resources) {
    expectAllResourcesHaveStatus<T>(resources, ResourceType.success);

    for (int i = 0; i < resources.length; i++) {
      expect(
        resources[i].data,
        isNotNull,
        reason: "Successful resource at index $i should have data",
      );
    }
  }

  /// Validate that all resources have errors
  void expectAllResourcesHaveErrors<T>(List<Resource<T>> resources) {
    expectAllResourcesHaveStatus<T>(resources, ResourceType.error);

    for (int i = 0; i < resources.length; i++) {
      expect(
        resources[i].message,
        isNotNull,
        reason: "Error resource at index $i should have error message",
      );
    }
  }

  // MARK: - Helper Methods for Custom Assertions

  /// Create a custom resource assertion
  void expectResourceCustom<T>(
    Resource<T> resource,
    bool Function(Resource<T>) customValidator,
    String failureMessage,
  ) {
    expectValidResource<T>(resource);
    expect(customValidator(resource), isTrue, reason: failureMessage);
  }

  /// Validate resource data with type-safe casting
  void expectResourceDataType<T, U>(
    Resource<T> resource,
    bool Function(U) dataValidator, {
    String? failureMessage,
  }) {
    expectValidResource<T>(resource);
    expect(
      resource.data,
      isA<U>(),
      reason: failureMessage ?? "Resource data should be of type $U",
    );

    if (resource.data is U) {
      expect(
        dataValidator(resource.data as U),
        isTrue,
        reason: failureMessage ?? "Resource data should pass custom validation",
      );
    }
  }
}
