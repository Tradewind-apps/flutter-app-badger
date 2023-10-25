import 'app_badger_platform_interface.dart';

class AppBadger {
  Future<void> updateCount(int count) {
    return AppBadgerPlatform.instance.updateCount(count);
  }

  Future<void> remove() {
    return AppBadgerPlatform.instance.remove();
  }

  Future<bool> isSupported() {
    return AppBadgerPlatform.instance.isSupported();
  }
}
