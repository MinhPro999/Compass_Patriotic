import Flutter
import UIKit
import GoogleMobileAds
import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Google Mobile Ads SDK
    GADMobileAds.sharedInstance().start(completionHandler: nil)

    // Initialize Facebook SDK
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Handle Facebook URL schemes
    if ApplicationDelegate.shared.application(app, open: url, options: options) {
      return true
    }

    return super.application(app, open: url, options: options)
  }
}
