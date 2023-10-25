import Flutter
import UIKit

public class AppBadgerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "app_badger", binaryMessenger: registrar.messenger())
        let instance = AppBadgerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func updateBadgeCount(count: Int) {
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(count);
        } else {
            UIApplication.shared.applicationIconBadgeNumber = count;
        }
    }
    
    private func proceedWithBadge(call: FlutterMethodCall, result: @escaping FlutterResult) {
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
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied {
                result(nil);
                return;
            }
            if settings.authorizationStatus == .notDetermined {
                result(nil);
                return;
            }
            if settings.authorizationStatus == .authorized {
                self.proceedWithBadge(call: call, result: result);
                return;
            }
            if #available(iOS 12.0, *) {
                if settings.authorizationStatus == .provisional {
                    self.proceedWithBadge(call: call, result: result);
                    return;
                }
            }
            if #available(iOS 14.0, *) {
                if settings.authorizationStatus == .ephemeral {
                    self.proceedWithBadge(call: call, result: result);
                    return;
                }
            }
        }
    }
}
