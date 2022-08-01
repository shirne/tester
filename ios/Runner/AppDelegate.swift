import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FlutterPluginOtherPlugin.register(with:self.registrar(forPlugin: "flutter_plugin_other")!)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
