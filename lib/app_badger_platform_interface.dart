import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_badger_method_channel.dart';

abstract class AppBadgerPlatform extends PlatformInterface {
  /// Constructs a AppBadgerPlatform.
  AppBadgerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppBadgerPlatform _instance = MethodChannelAppBadger();

  /// The default instance of [AppBadgerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppBadger].
  static AppBadgerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppBadgerPlatform] when
  /// they register themselves.
  static set instance(AppBadgerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> updateCount(int count) {
    throw UnimplementedError('updateCount() has not been implemented.');
  }

  /// [cancelNotifications] works only for Android - Will remove notifications from notification center
  Future<void> remove({
    bool cancelNotifications = false,
  }) {
    throw UnimplementedError('removeBadge() has not been implemented.');
  }

  Future<bool> isSupported() {
    throw UnimplementedError('isSupported() has not been implemented.');
  }
}
