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
        appCoordinator?.rootViewController = navigationController
    }
    
    public func stop() {
        messageServer.stop()
    }
    
    public func isMessageServerStarted() -> Bool {
        self.messageServer.server != nil
    }
    
    public func handleTapOnSettings() {
        showSettingsAlert()
    }
    
    public func showServerOffAlert(startCompletion: @escaping (() -> Void), stopCompletion: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "Message server",
                                      message: "The server message seems to be OFF, do you want to turn it ON and send your message ?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No",
                                      style: .default,
                                      handler: { _ in
            stopCompletion()
        }))
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: { _ in
            self.messageServer.start()
            startCompletion()
        }))
        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
    private func generateWelcomeMessage() -> Message {
        Message(contentText: "Welcome to our support platform ! \nHow can we help you ?",
                contentDate: Date(),
                acknowledgeState: .received,
                isFromServer: true)
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Settings",
                                      message: "Version : 1.0",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close",
                                      style: .default,
                                      handler: { _ in }))
        
        alert.addAction(UIAlertAction(title: isMessageServerStarted() ? "Stop server" : "Start server",
                                      style: .default,
                                      handler: {(_: UIAlertAction!) in
            if self.isMessageServerStarted() {
                self.messageServer.stop()
            } else {
                self.messageServer.start()
            }
        }))
        self.navigationController.present(alert, animated: true, completion: nil)
    }
}
