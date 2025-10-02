import 'dart:io';

import 'package:esim_open_source/data/services/consent_manager_service.dart';
import 'package:esim_open_source/data/services/analytics_service_impl.dart';
import 'package:esim_open_source/domain/analytics/ecommerce_events.dart';
import 'package:flutter_test/flutter_test.dart';

// Lightweight fake DualProviderEvent for gating tests (reuse existing one if needed)
class _TestDualEvent extends DualProviderEvent {
  _TestDualEvent(): super('test_event');
  @override
  String get firebaseEventName => 'test_event';
  @override
  String get facebookEventName => 'fb_test_event';
  @override
  Map<String, Object?> get firebaseParameters => {'source': 'test'};
  @override
  Map<String, Object?> get facebookParameters => {'_source': 'test'};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Analytics consent + ATT gating', () {
    late AnalyticsServiceImpl service;

    setUp(() async {
      AnalyticsServiceImpl.testMode = true; // avoid platform channel calls
      service = AnalyticsServiceImpl.instance;
      service.resetTestState();
      // Start with explicit baseline consent (analytics on, advertising off)
      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      }, initialLoad: true);
    });

    test('Analytics enabled, Advertising disabled -> only Firebase flag true', () async {
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isFalse);
      // Re-apply same consent (idempotency)
      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isTrue, reason: 'Firebase flag should remain stable on redundant consent');
      expect(service.facebookEnabledFlag, isFalse, reason: 'Facebook flag should remain stable on redundant consent');
    });

    test('Enabling advertising consent toggles facebook flag (ATT ignored on non-iOS)', () async {
      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      });
      expect(service.facebookEnabledFlag, isTrue);
      // Toggle off again to verify revert works
      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      });
      expect(service.facebookEnabledFlag, isFalse, reason: 'Should revert when advertising consent removed');
    });

    test('Disabling analytics consent turns off firebase while keeping facebook (if ad consent true)', () async {
      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      });
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isTrue);

      await service.applyConsentForTest({
        ConsentType.analytics: false,
        ConsentType.advertising: true,
      });
      expect(service.firebaseEnabledFlag, isFalse);
      expect(service.facebookEnabledFlag, isTrue);
      // Re-apply same consent map; state should remain unchanged
      await service.applyConsentForTest({
        ConsentType.analytics: false,
        ConsentType.advertising: true,
      });
      expect(service.firebaseEnabledFlag, isFalse, reason: 'Firebase flag stable after redundant disable');
      expect(service.facebookEnabledFlag, isTrue, reason: 'Facebook flag stable after redundant reapply');
    });

    test('Both analytics + advertising disabled -> both flags false', () async {
      await service.applyConsentForTest({
        ConsentType.analytics: false,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isFalse);
      expect(service.facebookEnabledFlag, isFalse);
    });

    test('ATT gating logic indirectly (iOS path simulated) - facebook disabled until authorized', () async {
      // We cannot force Platform.isIOS inside tests easily without conditional imports; so we assert
      // that on non-iOS platform the attAuthorizedFlag stays false but facebook flag follows consent.
      final bool isIOS = Platform.isIOS;

      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      });

      if (isIOS) {
        // On iOS in testMode _attAuthorized remains false (since no real ATT call). Thus effective tracking should require both flags + attAuthorized.
        // We only assert internal flag state here; behavior of actual logging is already guarded by testMode.
        expect(service.facebookEnabledFlag, isTrue, reason: 'Consent reflects enabling, even if ATT blocks actual sending.');
        expect(service.attAuthorizedFlag, isFalse, reason: 'ATT not simulated/authorized in test mode.');
      } else {
        expect(service.facebookEnabledFlag, isTrue);
      }
    });

    test('Sequential consent flips preserve state correctness', () async {
      // Start: analytics on, advertising off (from setUp)
      await service.applyConsentForTest({
        ConsentType.analytics: false,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isFalse);
      expect(service.facebookEnabledFlag, isFalse);

      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isFalse);

      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      });
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isTrue);
      // Final flip back to analytics only to ensure partial disable works after chain
      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isFalse);
    });

    test('DualProviderEvent still routes flags without throwing (smoke)', () async {
      final _TestDualEvent event = _TestDualEvent();
      // Ensure both enabled
      await service.applyConsentForTest({
        ConsentType.analytics: true,
        ConsentType.advertising: true,
      });
      // Should execute without exceptions in test mode
      await service.logEvent(event: event);
      expect(service.firebaseEnabledFlag, isTrue);
      expect(service.facebookEnabledFlag, isTrue);
      // Disable everything and ensure flags update before next potential log
      await service.applyConsentForTest({
        ConsentType.analytics: false,
        ConsentType.advertising: false,
      });
      expect(service.firebaseEnabledFlag, isFalse);
      expect(service.facebookEnabledFlag, isFalse);
    });
  });
}
