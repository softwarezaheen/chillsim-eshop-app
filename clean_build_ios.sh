#!/bin/bash

# Exit on error
set -e

# 1. Clean Flutter build artifacts
echo "Cleaning Flutter build artifacts..."
flutter clean

# 2. Remove Pods and DerivedData
echo "Removing Pods and DerivedData..."
cd ios
rm -rf Pods Podfile.lock ~/Library/Developer/Xcode/DerivedData/*

# 3. Get Flutter packages
echo "Getting Flutter packages..."
cd ..
flutter pub get

# 4. Install CocoaPods dependencies
echo "Installing CocoaPods dependencies..."
cd ios
pod install

# 5. Go back to project root
cd ..

# 6. Build iOS archive for OpenSourceProd flavor (without export - we'll do that manually)
echo "Building iOS release archive (OpenSourceProd)..."
flutter build ios --release --flavor OpenSourceProd --no-codesign

# 7. Create archive using xcodebuild
echo "Creating Xcode archive..."
ARCHIVE_PATH="build/ios/archive/Runner.xcarchive"
rm -rf "$ARCHIVE_PATH"

xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release-OpenSourceProd \
  -sdk iphoneos \
  -archivePath "$ARCHIVE_PATH" \
  archive \
  -allowProvisioningUpdates \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM=5DR38G7748

# 8. Export IPA with proper signing
echo "Exporting IPA..."
EXPORT_DIR="build/ios/ipa"
rm -rf "$EXPORT_DIR"
mkdir -p "$EXPORT_DIR"

xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_DIR" \
  -exportOptionsPlist exportOptions.plist \
  -allowProvisioningUpdates

# 9. Copy archive to Xcode Organizer
echo "Copying archive to Xcode Organizer location..."
ARCHIVE_DATE=$(date +%Y-%m-%d)
XCODE_ARCHIVES_DIR="$HOME/Library/Developer/Xcode/Archives/$ARCHIVE_DATE"
mkdir -p "$XCODE_ARCHIVES_DIR"

if [ -d "$ARCHIVE_PATH" ]; then
    TIMESTAMP=$(date +%H-%M-%S)
    cp -R "$ARCHIVE_PATH" "$XCODE_ARCHIVES_DIR/Runner-$TIMESTAMP.xcarchive"
    echo "✅ Archive copied to Xcode Organizer: $XCODE_ARCHIVES_DIR/Runner-$TIMESTAMP.xcarchive"
else
    echo "⚠️ Archive not found at $ARCHIVE_PATH"
fi

echo ""
echo "✅ Clean release build complete!"
echo "📁 IPA is located in $EXPORT_DIR/"
echo "📱 Archive is available in Xcode Organizer"
ls -la "$EXPORT_DIR"/*.ipa 2>/dev/null || echo "Note: Check $EXPORT_DIR for exported files"