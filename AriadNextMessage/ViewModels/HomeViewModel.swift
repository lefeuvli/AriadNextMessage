//
//  HomeViewModel.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    // MARK: - Properties
    
    var behaviourMessage: BehaviorSubject<Message>?
    
    private weak var homeCoordinator: HomeCoordinator?
    
    // MARK: - init
    
    init(coordinator: HomeCoordinator) {
        self.homeCoordinator = coordinator
    }
    
    // MARK: - Funcs
    
    func configureFirstMessage(with message: Message) {
        behaviourMessage?.dispose()
        behaviourMessage = BehaviorSubject(value: message)
    }
    
    func didTapOnSendMessage(text: String) {
        // Create message with text content
        var message = Message(contentText: text,
                              contentDate: Date(),
                              acknowledgeState: .send)
        
        // Add message in view behaviour stack
        behaviourMessage?.onNext(message)
        
        if homeCoordinator?.isMessageServerStarted() ?? false {
            // Send message on server
            sendMessage(message)
        } else {
            homeCoordinator?.showServerOffAlert(
                startCompletion: {
                    self.sendMessage(message)
                },
                stopCompletion: {
                    message.acknowledgeState = .notSend
                    self.behaviourMessage?.onNext(message)
                })
        }
    }
    
    private func sendMessage(_ message: Message) {
        _ = MessageService.send(message: message)
            .subscribe { newMessages in
                DispatchQueue.main.async {
                    newMessages.forEach { newMessage in
                        self.behaviourMessage?.onNext(newMessage)
                    }
                }
            } onFailure: { error in
                print("ERROR : \(error)")
            } onDisposed: {
            }
    }
    
    func didTapOnSettings() {
        homeCoordinator?.handleTapOnSettings()
    }
}
