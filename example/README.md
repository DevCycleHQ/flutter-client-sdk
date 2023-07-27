# devcycle_flutter_client_sdk_example

Demonstrates how to use the devcycle_flutter_client_sdk plugin.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Run iOS Example App

To run the iOS Example App:
- Get your Development Mobile SDK Key from the [DevCycle dashboard](app.devcycle.com). Replace `<DEVCYCLE_MOBILE_SDK_KEY>` in `example/main.dart` with the key.
- navigate to the `cd example/ios` directory
- Start an iOS Simulator: `flutter emulators --launch ios`
- Then run `flutter run` to run the app on the simulator (you may need to run `pod update` first).

## Run Android Example App

To run the Android Example App:
- Get your Development Mobile SDK Key from the [DevCycle dashboard](app.devcycle.com). Replace `<DEVCYCLE_MOBILE_SDK_KEY>` in `example/main.dart` with the key.
- navigate to the `cd example/android` directory
- List your Android emulators using: `flutter emulators`, launch an Android emulator: `flutter emulators --launch Pixel_5_API_31`
- Then run `flutter run` to run the app on the emulator.