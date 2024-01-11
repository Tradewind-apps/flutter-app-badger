import 'app_badger_platform_interface.dart';

class AppBadger {
  const AppBadger();

  Future<void> updateCount(int count) {
    return AppBadgerPlatform.instance.updateCount(count);
  }

  /// [cancelNotifications] works only for Android - Will remove notifications from notification center
  Future<void> remove({
    bool cancelNotifications = false,
  }) {
    return AppBadgerPlatform.instance.remove(
      cancelNotifications: cancelNotifications,
    );
  }

  Future<bool> isSupported() {
    return AppBadgerPlatform.instance.isSupported();
  }
}
