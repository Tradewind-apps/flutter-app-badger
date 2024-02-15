import 'package:app_badger/app_badger.dart';
import 'package:app_badger/app_badger_method_channel.dart';
import 'package:app_badger/app_badger_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppBadgerPlatform
    with MockPlatformInterfaceMixin
    implements AppBadgerPlatform {
  @override
  Future<bool> isSupported() => Future.value(true);

  @override
  Future<void> remove({
    bool cancelNotifications = false,
  }) async {}
  @override
  Future<void> updateCount(int count) async {}
}

void main() {
  final AppBadgerPlatform initialPlatform = AppBadgerPlatform.instance;

  test('$MethodChannelAppBadger is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppBadger>());
  });

  test('isSupported', () async {
    AppBadger appBadgerPlugin = const AppBadger();
    MockAppBadgerPlatform fakePlatform = MockAppBadgerPlatform();
    AppBadgerPlatform.instance = fakePlatform;

    expect(await appBadgerPlugin.isSupported(), true);
  });
}
