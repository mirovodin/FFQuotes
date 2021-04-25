//
//  AppDelegate.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder {

    var window: UIWindow?

    private lazy var socketManager = ServiceLocator.shared.getSocketManager()
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let config = ServiceLocator.shared.getNetworkConfig().makeSocketConfig() {
            socketManager.start(config: config)
        }

        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        window = mainWindow

        let module = ModuleLocator.shared.getQuotesModule()
        window?.rootViewController = module.toPresent()

        if !mainWindow.isKeyWindow {
            mainWindow.makeKeyAndVisible()
        }
        return true
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        socketManager.stop()
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        socketManager.pause()
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        socketManager.restore()
    }
}
