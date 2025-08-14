//
//  AppDelegate.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 26/02/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialVC = storyboard.instantiateInitialViewController() {
            // Directly set the initial view controller without wrapping it
            window?.rootViewController = initialVC
        } else {
            // Fallback in case the storyboard doesn't have an initial view controller
            let fallbackVC = UIViewController()
            fallbackVC.view.backgroundColor = .white
            window?.rootViewController = fallbackVC
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}

