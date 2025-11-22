import UIKit
import Flutter
import flutter_local_notifications
import BranchSDK
import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // ✅ Enables advertiser tracking
        Settings.shared.isAdvertiserTrackingEnabled = true
        
        // ✅ Optional: Enable debug logging
        Settings.shared.enableLoggingBehavior(.appEvents)
        
        configureBranchTestMode()
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let simProfilesChannel = FlutterMethodChannel(
            name: "zaheen.esim.chillsim/flutter_to_native",
            binaryMessenger: controller.binaryMessenger
        )
        simProfilesChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            if call.method == "openSimProfilesSettings" {
                self.openSimProfilesSettings(result: result)
            } else if call.method == "openEsimSetup" {
                guard let args = call.arguments as? [String: String],
                      let cardData = args["cardData"] else {
                    result(FlutterError(code: "INVALID_ARGUMENT",
                                        message: "Card data is required",
                                        details: nil))
                    return
                }
                
                AppDelegate.openURL(withCardData: cardData)
                result(true)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // CRITICAL: Forward to Flutter plugins first (handles app_links plugin)
        let handledByFlutter = super.application(application, continue: userActivity, restorationHandler: restorationHandler)
        
        if handledByFlutter {
            print("✅ Universal Link handled by Flutter plugins")
            return true
        }
        
        // Fallback: Manual handling for Universal Links and custom schemes
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            print("✅ Received Universal Link: \(url)")
            return true
        }
        
        print("❌ Universal Link not handled")
        return false
    }
    
    
    private func openSimProfilesSettings(result: FlutterResult) {
        if let url = URL(string: "App-prefs:MOBILE_DATA_SETTINGS_ID") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                result(true)
            } else {
                // Fallback to general Settings app
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                    result(true)
                } else {
                    result(FlutterError(code: "UNAVAILABLE",
                                        message: "Could not open settings",
                                        details: nil))
                }
            }
        } else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Could not open eSim settings",
                                details: nil))
        }
    }
    
    
    static func openURL(withCardData cardData: String) {
        let baseURL = "https://esimsetup.apple.com/esim_qrcode_provisioning"
        let queryItem = URLQueryItem(name: "carddata", value: cardData)
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [queryItem]
        
        guard let url = components?.url else {
            print("Invalid URL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func configureBranchTestMode() {
            // First, try to read from Info.plist (set by build script)
            if let useTestModeFromPlist = Bundle.main.object(forInfoDictionaryKey: "branch_use_test_instance") as? Bool {
                if useTestModeFromPlist {
                    print("🧪 Info.plist: branch_use_test_instance = true - Using TEST key")
                    Branch.setUseTestBranchKey(true)
                } else {
                    print("🚀 Info.plist: branch_use_test_instance = false - Using LIVE key")
                    Branch.setUseTestBranchKey(false)
                }
                return
            }
            
                print("🚀 Fallback: RELEASE build detected - Using LIVE key")
                Branch.setUseTestBranchKey(false)
        }
    
}
