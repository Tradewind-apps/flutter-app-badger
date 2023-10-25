import Flutter
import UIKit

public class AppBadgerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_badger", binaryMessenger: registrar.messenger())
    let instance = AppBadgerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func areNotificationsEnabled() -> Bool {
    var result = false;
     UNUserNotificationCenter.current().getNotificationSettings { (settings) in 
         if settings.authorizationStatus == .authorized {
            result = true;
         }
         if #available(iOS 12.0, *) {
            if settings.authorizationStatus == .provisional {
                 result = true;
            }
         }
         if #available(iOS 14.0, *) {
             if settings.authorizationStatus == .ephemeral {
                 result = true;
             }
         }
     }
    return result;
  }
    
    private func updateBadgeCount(count: Int) {
    if #available(iOS 16.0, *) {
        UNUserNotificationCenter.current().setBadgeCount(count);
    } else {
        UIApplication.shared.applicationIconBadgeNumber = count;
    }
}

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(areNotificationsEnabled()) {
      // Dont proceed further is notifications are disabled
      result(nil);
    }

    switch call.method {
    case "updateCount":
        let arguments = call.arguments as! Dictionary<String,Int>;
        let count = arguments["count"]!;
        updateBadgeCount(count: count);
        result(nil);
    case "remove": 
        updateBadgeCount(count: 0);
        result(nil);
    case "isSupported": 
        result(true); // iOS Always supports updating badge
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
