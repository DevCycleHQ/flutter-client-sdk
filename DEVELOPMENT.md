## Development

Build instructions
------------------

## Prerequisites

See the [Flutter install](https://flutter.dev/docs/get-started/install) page for setting up Flutter for building Android and iOS plugins.

### Android

Open `example/android` in Android Studio. From there you can run the example app or develop the Android host by modifying `devcycle_flutter_client_sdk > java > com.devcycle.devcycle_flutter_client_sdk > DevCycleFlutterClientSdkPlugin.kt`

### iOS

To run the example app, open `example/ios/Runner.xcworkspace` in xCode or use the `flutter` command line tool and run `flutter run` in the `/example` directory. Develop the iOS host by modifying `ios > Classes > SwiftDevCycleFlutterClientSdkPlugin.swift`.

## Testing

To run the unit tests for the SDK, run `flutter test` in the SDK repo.
