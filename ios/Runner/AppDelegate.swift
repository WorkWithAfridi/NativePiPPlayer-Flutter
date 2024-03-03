import UIKit
import SwiftUI
import Flutter
import AVKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let audioSession = AVAudioSession.sharedInstance()
           do {
               try audioSession.setCategory(.playback)
               try audioSession.setActive(true, options: [])
           } catch {
               print("Setting category to AVAudioSessionCategoryPlayback failed.")
           }
        
        weak var registrar = self.registrar(forPlugin: "plugin-name")
        
        let factory = FLNativeViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<plugin-name>")!.register(
            factory,
            withId: "swiftui_integration")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

// MARK: - FLNativeView

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }
    
    func view() -> UIView {
        return _view
    }
    
    func createNativeView(view _view: UIView){
        // FOR UIKIT
        //        _view.backgroundColor = UIColor.blue
        //        let nativeLabel = UILabel()
        //        nativeLabel.text = "Native text from iOS"
        //        nativeLabel.textColor = UIColor.white
        //        nativeLabel.textAlignment = .center
        //        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        //        _view.addSubview(nativeLabel)
        
        // FOR SWIFTUI
        let keyWindows = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) ?? UIApplication.shared.windows.first
        let topController = keyWindows?.rootViewController
        
        let vc = UIHostingController(rootView: SwiftUIView())
        let swiftUiView = vc.view!
        swiftUiView.translatesAutoresizingMaskIntoConstraints = false
        
        topController?.addChild(vc)
        _view.addSubview(swiftUiView)
        
        NSLayoutConstraint.activate(
            [
                swiftUiView.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
                swiftUiView.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
                swiftUiView.topAnchor.constraint(equalTo: _view.topAnchor),
                swiftUiView.bottomAnchor.constraint(equalTo:  _view.bottomAnchor)
            ])
        
        vc.didMove(toParent: topController)
    }
}

class FLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "<platform-view-type>")
    }
}
