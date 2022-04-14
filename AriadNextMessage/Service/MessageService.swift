//
//  MessageService.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 11/04/2022.
//

import Foundation
import RxSwift
import FlyingFox


public class MessageService {
    /**
     Function to send message on server
     - parameters:
        - message: message client want to send
     - returns:
     Single of message table that contains client message and server response
     */
    public static func send(message: Message) -> Single<[Message]> {
       return Single<[Message]>.create { emitter in
           // Create url
           let url = URL(string: MessageServer.baseURL + MessageServer.messagesEndpoints)!
           
           // Get the current session
           let session = URLSession.shared
           
           // Create the request object using the url and set http method
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           
           // Add JSON body to the request
           do {
               request.httpBody = try JSONEncoder().encode(message)
           } catch let error {
               emitter(.failure(error))
           }
           
           // Set HTTP Headers to use JSON
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           
           // Create task using the session object to send data to the server
           let task = session.dataTask(with: request, completionHandler: { data, response, error in
               
               guard error == nil else {
                   emitter(.failure(error!))
                   return
               }
               
               guard let data = data else {
                   emitter(.failure(NSError(domain: "nilDataError", code: -1)))
                   return
               }
               
               do {
                   // Create [Message] object from data and complete
                   let messages = try JSONDecoder().decode([Message].self, from: data)
                   emitter(.success(messages))
               } catch let error {
                   emitter(.failure(error))
               }
           })
           
           task.resume()
           return Disposables.create()
       }
    }
}
