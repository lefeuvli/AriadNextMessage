//
//  AppCoordinator.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    private(set) var currentCoordinator: Coordinator?
    
    private unowned let window: UIWindow
    internal unowned var rootViewController: UIViewController {
        didSet {
            self.window.rootViewController = rootViewController
        }
    }
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        
        let rootViewController = UIViewController()
        self.window.rootViewController = rootViewController
        self.rootViewController = rootViewController
    }
    
    // MARK: - Funcs
    
    func start() {
        window.makeKeyAndVisible()
        
        startHomeCoordinator()
    }
    
    func stop() {
        currentCoordinator?.stop()
        window.rootViewController?.dismiss(animated: false)
    }
    
    private func startHomeCoordinator() {
        window.rootViewController?.dismiss(animated: false)
        
        currentCoordinator?.stop()
        currentCoordinator = HomeCoordinator(parentCoordinator: self)
        currentCoordinator?.start()
    }
}
