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
  final _dvcClient = DVCClientBuilder()
    .environmentKey('SDK_KEY')
    .user(DVCUserBuilder().userId('123').build())
    .build();

  @override
  void initState() {
    super.initState();
    initPlatformState();
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

  void resetUser() {
    _dvcClient.resetUser();
  }

  void identifyUser() {
    _dvcClient.identifyUser(DVCUserBuilder().userId('test_user').build());
  }

  void allFeatures() async {
    Map<String, DVCFeature> features = await _dvcClient.allFeatures();
     setState(() {
      _displayValue = features.keys.toString();
    });
  }

  void allVariables() async {
    Map<String, DVCVariable> variables = await _dvcClient.allVariables();
     setState(() {
      _displayValue = variables.values.map((variable) => "${variable.key}: ${variable.value}").toString();
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
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: allFeatures,
                child: const Text('All Features')
              ),
              ElevatedButton(
                onPressed: allVariables,
                child: const Text('All Variables')
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: identifyUser,
                child: const Text('Identify User')
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: resetUser,
                child: const Text('Reset User')
              ),
              Text(_displayValue)
            ],
          )
        ),
      ),
    );
  }
}
