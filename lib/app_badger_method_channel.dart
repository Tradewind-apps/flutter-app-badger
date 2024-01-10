import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_badger_platform_interface.dart';

/// An implementation of [AppBadgerPlatform] that uses method channels.
class MethodChannelAppBadger extends AppBadgerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_badger');

  @override
  Future<void> updateCount(int count) async {
    return methodChannel.invokeMethod('updateCount', {"count": count});
  }

  @override
  Future<void> remove({
    bool cancelNotifications = false,
  }) async {
    return methodChannel.invokeMethod(
      'remove',
      {
        'cancelNotifications': cancelNotifications,
      },
    );
  }

  @override
  Future<bool> isSupported() async {
    final bool? isSupported = await methodChannel.invokeMethod('isSupported');
    return isSupported ?? false;
  }
}
