import 'dart:async';

import 'package:app_badger/app_badger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSupported = false;
  final _appBadgerPlugin = const AppBadger();
  int count = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      isSupported = await _appBadgerPlugin.isSupported();
    } on PlatformException {
      isSupported = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Is Supported: $isSupported\n'),
            ),
            ElevatedButton(
                onPressed: () {
                  _appBadgerPlugin.updateCount(count++);
                },
                child: const Text('increase badge count by 1')),
            ElevatedButton(
                onPressed: () {
                  _appBadgerPlugin.remove();
                },
                child: const Text('remove badge'))
          ],
        ),
      ),
    );
  }
}
