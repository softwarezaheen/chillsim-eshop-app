# Google Consent Mode v2 Implementation

## Overview
This document outlines the complete implementation of Google Consent Mode v2 for privacy compliance in the ChillSim eSim mobile app.

## Implementation Components

### 1. Core Service Layer
**File**: `lib/data/services/consent_manager_service.dart`
- Manages user consent preferences using SharedPreferences
- Integrates with Firebase Analytics consent settings
- Handles consent storage, retrieval, and Firebase consent mode configuration
- Supports four consent types: Analytics, Advertising, Personalization, and Functional

### 2. User Interface
**File**: `lib/presentation/views/shared/consent_dialog.dart`
- Modern dialog interface for consent management
- Toggle switches for each consent category
- Clear descriptions of what each consent type enables
- Quick action buttons: "Accept All", "Essential Only", "Accept Selected"
- Privacy tip icon and professional styling

### 3. Initialization System
**File**: `lib/data/services/consent_initializer.dart`
- Handles app startup consent initialization
- Manages first-time user consent dialog display
- Provides helper methods for showing consent settings

### 4. Profile Integration
**File**: `lib/presentation/views/home_flow_views/profile_view/profile_view_sections.dart`
- Added "Privacy Settings" section to user profile
- Direct access to consent management from profile menu
- Integrated with existing profile navigation system

### 5. App Initialization
**File**: `lib/main.dart`
- Added consent initialization to app startup sequence
- Ensures consent system is ready before analytics configuration

## Native Platform Configuration

### Android Configuration
**File**: `android/app/src/main/AndroidManifest.xml`
```xml
<!-- Google Consent Mode v2 Configuration -->
<meta-data android:name="google_analytics_default_allow_analytics_storage" android:value="true" />
<meta-data android:name="google_analytics_default_allow_ad_storage" android:value="false" />
<meta-data android:name="google_analytics_default_allow_ad_user_data" android:value="false" />
<meta-data android:name="google_analytics_default_allow_ad_personalization_signals" android:value="false" />
```

### iOS Configuration
**File**: `ios/Runner/Info.plist`
```xml
<!-- Google Consent Mode v2 Configuration -->
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_ANALYTICS_STORAGE</key>
<true/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_STORAGE</key>
<false/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_USER_DATA</key>
<false/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_PERSONALIZATION_SIGNALS</key>
<false/>
```

## Consent Categories

### 1. Essential & Functional (Required)
- Always enabled for core app functionality
- Includes authentication, security, and basic features
- Cannot be disabled by users

### 2. Analytics & Performance (Optional)
- App usage analytics and performance monitoring
- Helps improve user experience
- No personal data sharing

### 3. Advertising & Marketing (Optional)
- Relevant ads and marketing effectiveness measurement
- Supports ad personalization when enabled

### 4. Personalization (Optional)
- Personalized content and recommendations
- Based on usage patterns and preferences

## User Experience Flow

### First-Time Users
1. App launches and initializes consent system
2. Default "denied" state set for advertising consent types
3. User can access Privacy Settings from Profile menu
4. Consent dialog presented with clear options
5. User selections saved and applied to Firebase Analytics

### Returning Users
1. Previous consent preferences loaded on app startup
2. Settings applied to Firebase Analytics automatically
3. Users can modify preferences anytime via Profile → Privacy Settings

### Consent Management
- **Accept All**: Enables all consent categories
- **Essential Only**: Only functional consent (required)
- **Accept Selected**: Saves individual toggle selections
- **Profile Access**: Modify settings anytime from user profile

## Privacy Compliance Features

### Transparency
- Clear descriptions for each consent category
- Visual indicators for required vs optional permissions
- Easy access to modify settings

### User Control
- Granular consent management
- Ability to change preferences anytime
- No forced acceptance of optional categories

### Technical Implementation
- Consent Mode v2 compliant with Google requirements
- Proper Firebase Analytics integration
- Persistent storage of user preferences
- Native platform configuration for compliance

## Testing Recommendations

### Functional Testing
1. Verify consent dialog appears and functions correctly
2. Test toggle switches and button actions
3. Confirm preferences persistence across app restarts
4. Validate Firebase Analytics consent state changes

### Compliance Testing
1. Verify default "denied" state for optional consent types
2. Confirm consent preferences are properly applied
3. Test profile navigation to Privacy Settings
4. Validate consent changes reflect in Firebase console

### User Experience Testing
1. Test consent dialog on various screen sizes
2. Verify accessibility features work properly
3. Confirm smooth navigation and interactions
4. Test different consent combination scenarios

## Next Steps

1. **Localization**: Add multi-language support for consent dialog text
2. **Analytics**: Monitor consent rates and user preferences
3. **Updates**: Handle consent version updates when regulations change
4. **Documentation**: Update privacy policy to reflect consent management features

## Compliance Notes

This implementation follows Google Consent Mode v2 requirements:
- ✅ Granular consent management
- ✅ Firebase Analytics integration
- ✅ Native platform configuration
- ✅ User-friendly consent interface
- ✅ Persistent preference storage
- ✅ Easy preference modification access

The implementation ensures GDPR and other privacy regulation compliance while maintaining a smooth user experience.