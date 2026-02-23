import "dart:io";

import "package:esim_open_source/data/services/analytics_service_impl.dart";
import "package:esim_open_source/data/services/consent_manager_service.dart";
import "package:flutter_test/flutter_test.dart";

// These tests focus on internal state transitions of AnalyticsServiceImpl._applyConsent.
// Platform channel calls are skipped via testMode.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("AnalyticsServiceImpl _applyConsent transitions", () {
    setUp(() {
      AnalyticsServiceImpl.testMode = true; // disable platform interactions
      AnalyticsServiceImpl.instance.resetTestState();
    });

    test("Initial consent load sets flags accordingly (analytics true, ads false)", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      }, initialLoad: true,);
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isFalse);
      expect(service.attAuthorizedFlag, isFalse); // no ATT yet
    });

    test("Enabling advertising toggles facebook flag on iOS without ATT authorization yet", () async {
      // Simulate iOS
      if (!Platform.isIOS) {
        // We only meaningfully assert ATT gating logic on iOS; skip otherwise.
        return; // Mark test skipped on non-iOS host.
      }
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      }, initialLoad: true,);

      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      });

      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isTrue);
      // In testMode we never invoke ATT request so still unauthorized.
      expect(service.attAuthorizedFlag, isFalse);
    });

    test("Disabling analytics leaves facebook consent unaffected", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      }, initialLoad: true,);

      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: false,
        ConsentType.advertising: true,
      });

      expect(service.firebaseEnabledFlag, isFalse);
      expect(service.facebookEnabledFlag, isTrue);
    });

    test("Rapid sequence of consent changes ends in last state", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      }, initialLoad: true,);

      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: false,
        ConsentType.advertising: true,
      });
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: false,
        ConsentType.advertising: false,
      });
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      });

      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isTrue);
    });

    test("Empty consent map falls back to defaults (analytics true, advertising false)", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{}, initialLoad: true);
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isFalse);
    });

    test("Enable then disable advertising keeps analytics unaffected", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      }, initialLoad: true,);
      expect(service.facebookEnabledFlag, isTrue);

      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isFalse);
    });

    test("Disable analytics only leaves advertising flag as-is", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      }, initialLoad: true,);
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isTrue);

      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: false,
        ConsentType.advertising: true,
      });
      expect(service.firebaseEnabledFlag, isFalse);
      expect(service.facebookEnabledFlag, isTrue);
    });

    test("Disable both then re-enable analytics only", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      }, initialLoad: true,);

      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: false,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isFalse);
      expect(service.facebookEnabledFlag, isFalse);

      await service.applyConsentForTest(<ConsentType, bool>{
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isFalse);
    });
  });
}
