#!/bin/bash

# Exit on error
set -e

echo "🧹 Starting clean iOS Simulator build..."

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

# 6. Build iOS for Simulator (OpenSourceDev flavor for development)
echo "Building iOS for Simulator (OpenSourceDev)..."
flutter build ios --debug --flavor OpenSourceDev --simulator

echo "✅ Clean iOS Simulator build complete!"
echo "📱 App built for iOS Simulator with OpenSourceDev flavor"
echo "🚀 You can now run: flutter run --flavor OpenSourceDev"
echo "💡 Or open the workspace in Xcode and run on simulator"

# Optionally open the Xcode workspace
read -p "Open Xcode workspace? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open ios/Runner.xcworkspace
fi