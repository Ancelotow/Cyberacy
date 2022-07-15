//
//  AppDelegate.swift
//  CStats
//
//  Created by Gabriel on 11/05/2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: ConnexionViewController())
        window.makeKeyAndVisible()
        FirebaseApp.configure()
        self.window = window
        
        
        return true
    }
    
}

