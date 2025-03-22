import Flutter
import UIKit
import GoogleMaps // Import the Google Maps SDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Google Maps with your API key
    GMSServices.provideAPIKey("8rE9XCNNU7GoAdJmnZuQ") // Replace with your actual API key
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
