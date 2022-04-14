//
//  AppDelegate.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
        
        return true
    }
}

