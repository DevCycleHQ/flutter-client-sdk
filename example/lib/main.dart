import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:devcycle_flutter_client_sdk/devcycle_flutter_client_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _displayValue = '';
  String _variableValue = '';
  final _dvcClient = DVCClientBuilder()
      .environmentKey('dvc_mobile_test_key')
      .user(DVCUserBuilder().userId('123').build())
      .options(DVCOptionsBuilder().logLevel(LogLevel.debug).build())
      .build();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initVariable();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _dvcClient.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initVariable() async {
    final variable = await _dvcClient.variable('my-variable', 'Default Value');
    setState(() {
      _variableValue = variable?.value;
    });
    variable?.onUpdate((updatedValue) {
      setState(() {
        _variableValue = updatedValue;
      });
    });
  }

  void resetUser() {
    _dvcClient.resetUser();
  }

  void identifyUser() {
    _dvcClient.identifyUser(
        DVCUserBuilder().userId('test_user_123').build(),
        ((err, variables) => {
              print(variables.values
                  .map((variable) => "${variable.key}: ${variable.value}")
                  .toString())
            }));
  }

  void trackEvent() {
    DVCEvent event = DVCEventBuilder()
        .target('target-str')
        .type('flutter-test')
        .value(10.0)
        .metaData({'custom_key': 'value'}).build();
    _dvcClient.track(event);
  }

  void showAllFeatures() async {
    Map<String, DVCFeature> features = await _dvcClient.allFeatures();
    setState(() {
      _displayValue = features.keys.toString();
    });
  }

  void flushEvents() {
    _dvcClient.flushEvents(([error]) => print(error));
  }

  void showAllVariables() async {
    Map<String, DVCVariable> variables = await _dvcClient.allVariables();
    setState(() {
      _displayValue = variables.values
          .map((variable) => "${variable.key}: ${variable.value}")
          .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Value: $_variableValue"),
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
                onPressed: showAllFeatures, child: const Text('All Features')),
            ElevatedButton(
                onPressed: showAllVariables,
                child: const Text('All Variables')),
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: identifyUser,
                child: const Text('Identify User')),
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: resetUser,
                child: const Text('Reset User')),
            ElevatedButton(onPressed: trackEvent, child: const Text('Track')),
            ElevatedButton(
                onPressed: flushEvents, child: const Text('FlushEvents')),
            Text(_displayValue)
          ],
        )),
      ),
    );
  }
}
