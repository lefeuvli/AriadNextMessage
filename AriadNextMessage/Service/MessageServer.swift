//
//  MessageServer.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 13/04/2022.
//

import FlyingFox
import Foundation

public class MessageServer {
    
    // MARK: - Properties
    
    var server: HTTPServer?
    var task: Task<(), Error>?
    
    static let baseURL = "http://localhost:\(port)"
    static let messagesEndpoints = "/messages"
    static let port: UInt16 = 8080
    
    // MARK: - Funcs
    
    public func start() {
        if task == nil {
            // Create server on specific port
            server = HTTPServer(port: Self.port)
            
            task = Task {
                // Create route for POST
                let messagesRoute = HTTPRoute(method: .POST,
                                              path: Self.messagesEndpoints,
                                              headers: [.contentType: "application/json"])

                // Add handler on specific route
                await server?.appendRoute(messagesRoute) { request in
                    // Wait random time before next step
                    let randomTime = Int.random(in: 1...6)
                    try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * randomTime))

                    // Decode body of client message and set state to received
                    var messages = [Message]()
                    let newMessage = try JSONDecoder().decode(Message.self, from: request.body)
                    newMessage.acknowledgeState = .received
                    
                    // Create fake server message
                    let serveurMessage = self.getRandomMessageResponse(number: randomTime, request: newMessage.contentText)

                    messages.append(newMessage)
                    messages.append(serveurMessage)

                    let json = try JSONEncoder().encode(messages)

                    // Add both messages on result of this request
                    return HTTPResponse(statusCode: .ok,
                                        body: json)
                }
                
                print("START SERVER ...")
                try await server?.start()
            }
        }
    }
    
    public func stop() {
        print("STOP SERVER")
        task?.cancel()
    }
    
    /**
     Function to generate server response
     - parameters:
        - number: random number
        - request: client message
     - returns:
     Server message generated, based on client request and random number
     */
    func getRandomMessageResponse(number: Int, request: String) -> Message {
        let messageContent: String
        switch number {
        case 0:
            messageContent = "We have received your request :\n \"\(request)\"\nCan you tell us more ?"
        case 1:
            messageContent = "Request supported by our services :\n \"\(request)\""
        case 2:
            messageContent = "Following your request below, we will contact you as soon as possible\n \"\(request)\""
        case 3:
            let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
            let components = request.components(separatedBy: chararacterSet)
            let words = components.filter { !$0.isEmpty }
            messageContent = "Can we have a few more details ? \(words.count) words is not enough.."
        case 4:
            messageContent = "We cannot do anything about this request : \n \"\(request)\""
        case 5:
            messageContent = "Received 5/5 ! \nWe are working hard to answer your question."
        default:
            messageContent = "We have received your request :\n \"\(request)\"\nCan you tell us more ?"
        }
        
        return Message(contentText: messageContent,
                       contentDate: Date(),
                       acknowledgeState: .received,
                       isFromServer: true)
    }
}
