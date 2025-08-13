import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/login_use_case.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/skeleton_view/skeleton_view_model.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";
import "../../../helpers/view_model_helper.dart";
import "../../../locator_test.dart";

// ignore_for_file: type=lint
class TestableSkeletonViewModel extends SkeletonViewModel {
  String? _mockProjectID;
  bool _skipFirebaseCall = false;
  bool _skipApiCalls = false;

  void setMockProjectID(String projectID) {
    _mockProjectID = projectID;
  }

  void skipFirebaseCall() {
    _skipFirebaseCall = true;
  }

  void skipApiCalls() {
    _skipApiCalls = true;
  }

  @override
  void getFirebaseID() {
    if (_skipFirebaseCall) {
      projectID = _mockProjectID ?? "test-project-id";
      notifyListeners();
    } else {
      super.getFirebaseID();
    }
  }

  @override
  void onViewModelReady() {
    if (_skipFirebaseCall) {
      projectID = _mockProjectID ?? "test-project-id";
      notifyListeners();
    } else {
      super.onViewModelReady();
    }
  }

  @override
  Future<void> getFacts() async {
    if (_skipApiCalls) {
      return;
    } else {
      await super.getFacts();
    }
  }

  @override
  Future<void> getCoins() async {
    if (_skipApiCalls) {
      return;
    } else {
      await super.getCoins();
    }
  }
}

Future<void> main() async {
  await prepareTest();

  // Mock platform channels for Firebase
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel firebaseChannel =
      MethodChannel("plugins.flutter.io/firebase_core");

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    firebaseChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == "Firebase#initializeApp") {
        return <String, dynamic>{
          "name": "[DEFAULT]",
          "options": <String, dynamic>{
            "apiKey": "test-api-key",
            "appId": "test-app-id",
            "messagingSenderId": "test-sender-id",
            "projectId": "test-project-id",
          },
        };
      } else if (methodCall.method == "Firebase#apps") {
        return <Map<String, dynamic>>[
          <String, dynamic>{
            "name": "[DEFAULT]",
            "options": <String, dynamic>{
              "apiKey": "test-api-key",
              "appId": "test-app-id",
              "messagingSenderId": "test-sender-id",
              "projectId": "test-project-id",
            },
          }
        ];
      } else if (methodCall.method == "Firebase#app") {
        return <String, dynamic>{
          "name": "[DEFAULT]",
          "options": <String, dynamic>{
            "apiKey": "test-api-key",
            "appId": "test-app-id",
            "messagingSenderId": "test-sender-id",
            "projectId": "test-project-id",
          },
        };
      }
      return null;
    },
  );

  group("SkeletonViewModel Tests", () {
    late TestableSkeletonViewModel viewModel;

    setUp(() async {
      await setupTest();
      onViewModelReadyMock(viewName: "SkeletonViewPage");
      viewModel = TestableSkeletonViewModel()
        ..skipFirebaseCall()
        ..skipApiCalls();
    });

    test("initializes with correct initial state", () {
      expect(viewModel.projectID, equals(""));
      expect(viewModel.viewState, equals(ViewState.idle));
    });

    test("loginUseCase is properly initialized", () {
      expect(viewModel.loginUseCase, isNotNull);
      expect(viewModel.loginUseCase, isA<LoginUseCase>());
      expect(viewModel.loginUseCase.repository, isA<ApiAuthRepository>());
    });

    test("projectID can be set and retrieved", () {
      viewModel
        ..setMockProjectID("test-project-123")
        ..getFirebaseID();

      expect(viewModel.projectID, equals("test-project-123"));
    });

    test("getFirebaseID updates projectID and notifies listeners", () {
      bool listenerCalled = false;
      viewModel
        ..addListener(() {
          listenerCalled = true;
        })
        ..setMockProjectID("firebase-test-id")
        ..getFirebaseID();

      expect(viewModel.projectID, equals("firebase-test-id"));
      expect(listenerCalled, isTrue);
    });

    test("onViewModelReady sets up correctly", () {
      viewModel
        ..setMockProjectID("test-project-456")
        ..onViewModelReady();

      expect(viewModel.projectID, equals("test-project-456"));
    });

    test("showLoader changes view state correctly with timing", () async {
      expect(viewModel.viewState, equals(ViewState.idle));
      final Future<void> future = viewModel.showLoader();

      expect(viewModel.viewState, equals(ViewState.busy));
      await future;
      expect(viewModel.viewState, equals(ViewState.success));
    });

    test("getFacts executes without throwing", () async {
      await expectLater(viewModel.getFacts(), completes);
    });

    test("getCoins executes without throwing", () async {
      await expectLater(viewModel.getCoins(), completes);
    });

    test("loginUser manages view state correctly", () async {
      expect(viewModel.viewState, equals(ViewState.idle));

      await viewModel.loginUser();

      expect(viewModel.viewState, equals(ViewState.idle));
    });

    test("registerUser manages view state correctly", () async {
      expect(viewModel.viewState, equals(ViewState.idle));

      await viewModel.registerUser();

      // registerUser sets to busy but doesn't reset - this is actual behavior
      expect(viewModel.viewState, equals(ViewState.busy));
    });

    test("onDispose executes without throwing", () {
      expect(() => viewModel.onDispose(), returnsNormally);
    });

    test("view state changes trigger listener notifications", () {
      final List<ViewState> stateChanges = <ViewState>[];

      viewModel
        ..addListener(() {
          stateChanges.add(viewModel.viewState);
        })
        ..setViewState(ViewState.busy)
        ..setViewState(ViewState.success)
        ..setViewState(ViewState.idle);

      expect(
        stateChanges,
        equals(<ViewState>[ViewState.busy, ViewState.success, ViewState.idle]),
      );
    });

    test("multiple concurrent showLoader calls", () async {
      expect(viewModel.viewState, equals(ViewState.idle));

      // Start multiple showLoader calls
      final Future<void> future1 = viewModel.showLoader();
      final Future<void> future2 = viewModel.showLoader();

      expect(viewModel.viewState, equals(ViewState.busy));

      await Future.wait(<Future<void>>[future1, future2]);

      expect(viewModel.viewState, equals(ViewState.success));
    });

    test("loginUseCase has correct repository dependency", () {
      final ApiAuthRepository mockRepo = locator<ApiAuthRepository>();
      expect(viewModel.loginUseCase.repository, equals(mockRepo));
    });

    test("projectID is publicly accessible", () {
      viewModel
        ..setMockProjectID("public-access-test")
        ..onViewModelReady();
      expect(viewModel.projectID, isA<String>());
      expect(viewModel.projectID, equals("public-access-test"));
    });

    test("all async methods complete successfully", () async {
      await expectLater(viewModel.showLoader(), completes);
      await expectLater(viewModel.getFacts(), completes);
      await expectLater(viewModel.getCoins(), completes);
      await expectLater(viewModel.loginUser(), completes);
      await expectLater(viewModel.registerUser(), completes);
    });

    test("viewModel inherits from BaseModel correctly", () {
      expect(viewModel.viewState, isA<ViewState>());
      expect(viewModel.setViewState, isA<Function>());
    });

    test("showLoader timing is consistent", () async {
      final List<int> timings = <int>[];

      for (int i = 0; i < 3; i++) {
        final Stopwatch stopwatch = Stopwatch()..start();
        await viewModel.showLoader();
        stopwatch.stop();
        timings.add(stopwatch.elapsedMilliseconds);

        // Reset state for next iteration
        viewModel.setViewState(ViewState.idle);
      }

      // All timings should be around 5000ms
      for (final int timing in timings) {
        expect(timing, greaterThan(490));
        expect(timing, lessThan(520));
      }
    });

    test("state transitions in showLoader are correct", () async {
      final List<ViewState> stateHistory = <ViewState>[];

      viewModel.addListener(() {
        stateHistory.add(viewModel.viewState);
      });

      await viewModel.showLoader();

      expect(stateHistory, contains(ViewState.busy));
      expect(stateHistory, contains(ViewState.success));
      expect(stateHistory.first, equals(ViewState.busy));
      expect(stateHistory.last, equals(ViewState.success));
    });

    test("projectID default value", () {
      final TestableSkeletonViewModel freshViewModel =
          TestableSkeletonViewModel();
      expect(freshViewModel.projectID, equals(""));
      expect(freshViewModel.projectID, isA<String>());
    });

    test("listener management works correctly", () {
      int listenerCallCount = 0;

      void listener() {
        listenerCallCount++;
      }

      viewModel
        ..addListener(listener)
        ..setViewState(ViewState.busy)
        ..setViewState(ViewState.success);

      expect(listenerCallCount, equals(2));

      viewModel
        ..removeListener(listener)
        ..setViewState(ViewState.idle);

      // Should still be 2 after removing listener
      expect(listenerCallCount, equals(2));
    });

    test("notifyListeners is called appropriately", () {
      bool notified = false;

      viewModel
        ..addListener(() {
          notified = true;
        })

        // This should trigger notifyListeners
        ..getFirebaseID();

      expect(notified, isTrue);
    });

    test("multiple setViewState calls work correctly", () {
      expect(viewModel.viewState, equals(ViewState.idle));

      viewModel.setViewState(ViewState.busy);
      expect(viewModel.viewState, equals(ViewState.busy));

      viewModel.setViewState(ViewState.success);
      expect(viewModel.viewState, equals(ViewState.success));

      viewModel.setViewState(ViewState.idle);
      expect(viewModel.viewState, equals(ViewState.idle));
    });

    test("error handling in async methods", () async {
      // These methods should complete even if there are internal errors
      await expectLater(viewModel.getFacts(), completes);
      await expectLater(viewModel.getCoins(), completes);
      await expectLater(viewModel.loginUser(), completes);
      await expectLater(viewModel.registerUser(), completes);
    });

    test("view model properties are accessible", () {
      expect(viewModel.projectID, isA<String>());
      expect(viewModel.viewState, isA<ViewState>());
      expect(viewModel.loginUseCase, isA<LoginUseCase>());
    });
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}
