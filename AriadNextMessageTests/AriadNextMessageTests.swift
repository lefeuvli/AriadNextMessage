//
//  AriadNextMessageTests.swift
//  AriadNextMessageTests
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import XCTest
@testable import AriadNextMessage

class AriadNextMessageTests: XCTestCase {
    
    var messageServer = MessageServer()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        messageServer.stop()
    }

    func testRandomResponse() throws {
        let requestText = "ariadNext"
        let response = messageServer.getRandomMessageResponse(number: 2, request: requestText)
        
        XCTAssertEqual(response.acknowledgeState, .received)
        XCTAssertTrue(response.contentText.contains(requestText), "Message must contain : \(requestText)")
    }

    func testSendMessage() throws {
        messageServer.start()
        let messageText = "Hello ariadNext"
        let sendMessage = Message(contentText: messageText,
                                  contentDate: Date(),
                                  acknowledgeState: .send)
        _ = MessageService.send(message: sendMessage).subscribe { messages in
            XCTAssertEqual(messages.count, 2)
            XCTAssertEqual(messages[0].acknowledgeState, .received)
            XCTAssertTrue(messages[1].contentText.contains(messageText))
        } onFailure: { error in
            XCTFail("Error during send message : \(error)")
        } onDisposed: {
            
        }

    }

}
