import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
  final _logger = Logger();
  String _platformVersion = 'Unknown';
  String _displayValue = '';
  String _variableValue = '';
  bool _booleanValue = false;
  final _dvcClient = DVCClientBuilder()
      .sdkKey('YOUR_DVC_MOBILE_SDK_KEY')
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

    final booleanVariable =
        await _dvcClient.variable('boolean-variable', false);
    setState(() {
      _booleanValue = booleanVariable?.value;
    });
    booleanVariable?.onUpdate((updatedValue) {
      setState(() {
        _booleanValue = updatedValue;
      });
    });
  }

  void resetUser() {
    _dvcClient.resetUser();
    setState(() {
      _displayValue = 'User reset!';
    });
  }

  void identifyUser() {
    DVCUser testUser = DVCUserBuilder().userId('test_user_123').build();
    _dvcClient.identifyUser(
        testUser,
        ((err, variables) => {
              _logger.d(variables.values
                  .map((variable) => "${variable.key}: ${variable.value}")
                  .toString())
            }));
    setState(() {
      _displayValue = 'Identified user: \n${testUser.toString()}';
    });
  }

  void identifyAnonUser() {
    DVCUser anonUser = DVCUserBuilder().isAnonymous(true).build();
    _dvcClient.identifyUser(anonUser);
    setState(() {
      _displayValue = 'Identified user: \n${anonUser.toString()}';
    });
  }

  void trackEvent() {
    DVCEvent event = DVCEventBuilder()
        .target('target-str')
        .type('flutter-test')
        .value(10.0)
        .metaData({'custom_key': 'value'}).build();
    _dvcClient.track(event);
    setState(() {
      _displayValue = 'Tracked event: \n${event.toString()}';
    });
  }

  void showAllFeatures() async {
    Map<String, DVCFeature> features = await _dvcClient.allFeatures();
    setState(() {
      _displayValue = 'All features: \n${features.keys.toString()}';
    });
  }

  void flushEvents() {
    _dvcClient.flushEvents(([error]) => _logger.e(error));
    setState(() {
      _displayValue = 'Flushed events';
    });
  }

  void showAllVariables() async {
    Map<String, DVCVariable> variables = await _dvcClient.allVariables();
    setState(() {
      _displayValue =
          'All variables: \n${variables.values.map((variable) => "${variable.key}: ${variable.value}").toString()}';
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
            Icon(
              Icons.star,
              color: _booleanValue ? Colors.blue[500] : Colors.red[500],
            ),
            _booleanValue
                ? const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.grey,
                  ),
            ElevatedButton(
                onPressed: showAllFeatures, child: const Text('All Features')),
            ElevatedButton(
                onPressed: showAllVariables,
                child: const Text('All Variables')),
            ElevatedButton(
                onPressed: identifyUser, child: const Text('Identify User')),
            ElevatedButton(
                onPressed: identifyAnonUser,
                child: const Text('Identify Anonymous User')),
            ElevatedButton(
                onPressed: resetUser, child: const Text('Reset User')),
            ElevatedButton(
                onPressed: trackEvent, child: const Text('Track Event')),
            ElevatedButton(
                onPressed: flushEvents, child: const Text('FlushEvents')),
            Text(_displayValue)
          ],
        )),
      ),
    );
  }
}
