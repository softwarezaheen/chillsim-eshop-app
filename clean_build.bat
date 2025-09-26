@echo off
echo Starting clean Flutter build process...

echo.
echo Step 1: Flutter clean
call flutter clean

echo.
echo Step 2: Delete build folders
if exist "build" rmdir /s /q "build"
if exist "android\build" rmdir /s /q "android\build"
if exist "android\app\build" rmdir /s /q "android\app\build"
if exist ".dart_tool" rmdir /s /q ".dart_tool"

echo.
echo Step 3: Get dependencies
call flutter pub get

echo.
echo Step 4: Generate ObjectBox files
call flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo Step 5: Build signed APK with verbose output
call flutter build apk --release --verbose

echo.
echo Build process completed!
echo.
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo Note: This APK is signed using the keystore configured in android/local.properties
echo Check for any errors above.
pause