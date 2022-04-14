//
//  HomeCoordinator.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 11/04/2022.
//

import Foundation
import UIKit

public class HomeCoordinator: Coordinator {
    
    // MARK: - Properties
    
    private weak var appCoordinator: AppCoordinator?
    private let navigationController = UINavigationController()
    private var homeViewModel: HomeViewModel?
    private var messageServer = MessageServer()
    
    // MARK: - Init
    
    init(parentCoordinator: AppCoordinator) {
        self.appCoordinator = parentCoordinator
        self.homeViewModel = HomeViewModel(coordinator: self)
    }
    
    // MARK: - Funcs
    
    public func start() {
        messageServer.start()
        
        guard let homeViewModel = homeViewModel else {
            return
        }
        
        homeViewModel.configureFirstMessage(with: generateWelcomeMessage())
        
        let homeViewController = HomeViewController.create(viewModel: homeViewModel)
        navigationController.pushViewController(homeViewController, animated: false)
        appCoordinator?.rootViewController = homeViewController
    }
    
    public func stop() {
        messageServer.stop()
    }
    
    private func generateWelcomeMessage() -> Message {
        Message(contentText: "Welcome to our support platform ! \nHow can we help you ?",
                contentDate: Date(),
                acknowledgeState: .received,
                isFromServer: true)
    }
}
