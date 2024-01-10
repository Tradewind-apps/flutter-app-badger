package co.tradewind.appbadger.app_badger;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;

import java.util.List;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import me.leolin.shortcutbadger.ShortcutBadger;

/** AppBadgerPlugin */
public class AppBadgerPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Context applicationContext;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "app_badger");
    channel.setMethodCallHandler(this);
    applicationContext = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if(!areNotificationsEnabled()) {
      result.success(null);
      return;
    }

    switch (call.method) {
      case "updateCount":
        final int count = Integer.parseInt(Objects.requireNonNull(call.argument("count")).toString());
        updateCount(count);
        result.success(null);
        break;
      case "remove":
        final boolean cancelNotifications =  Boolean.parseBoolean(call.argument("cancelNotifications"));
        removeCount(cancelNotifications);
        result.success(null);
        break;
      case "isSupported":
        result.success(isSupported());
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private boolean isSupported() {
    return ShortcutBadger.isBadgeCounterSupported(applicationContext);
  }

  private void removeCount(boolean cancelNotifications) {
    if(isSupported()) {
      ShortcutBadger.removeCount(applicationContext);
    }
    // If we want to cancel notifications
    if(cancelNotifications) {
      // In case of not supporting current platform, lets disable overall notifications badge via manager.
      NotificationManager notificationManager = (NotificationManager) applicationContext.getSystemService(Context.NOTIFICATION_SERVICE);
      notificationManager.cancelAll();
    }
  }

  private void updateCount(int count) {
    if(isSupported()) {
      ShortcutBadger.applyCount(applicationContext, count);
      return;
    }
    if(count == 0) {
      removeCount(false);
    }
    // We can do nothing about it, we can not update badge since package does not support it
  }

  private boolean areNotificationsEnabled() {
    // Android 13 and above can disable notifications per channel
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationManager manager = (NotificationManager) applicationContext.getSystemService(Context.NOTIFICATION_SERVICE);
      if (!manager.areNotificationsEnabled()) {
        return false;
      }
      List<NotificationChannel> channels = manager.getNotificationChannels();
      for (NotificationChannel channel : channels) {
        if (channel.getImportance() == NotificationManager.IMPORTANCE_NONE) {
          return false;
        }
      }
      return true;
    } else {
      return NotificationManagerCompat.from(applicationContext).areNotificationsEnabled();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
