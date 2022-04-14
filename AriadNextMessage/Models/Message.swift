//
//  Message.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import Foundation

public class Message: Equatable, Codable {
     
    // MARK: - Properties
    
    var contentText: String
    var contentDate: Date
    var acknowledgeState: AcknowledgeState
    var isFromServer: Bool
    
    // MARK: - Init
    
    init(contentText: String,
         contentDate: Date,
         acknowledgeState: AcknowledgeState,
         isFromServer: Bool = false) {
        self.contentText = contentText
        self.contentDate = contentDate
        self.acknowledgeState = acknowledgeState
        self.isFromServer = isFromServer
    }
    
    // MARK: - Funcs
    
    enum CodingKeys : String, CodingKey {
        case contentText
        case contentDate
        case acknowledgeState
        case isFromServer
    }
    
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.contentDate.timeIntervalSince1970 == rhs.contentDate.timeIntervalSince1970 && lhs.contentText == rhs.contentText
    }
    
    public func clone() -> Message {
        Message(contentText: self.contentText,
                contentDate: self.contentDate,
                acknowledgeState: self.acknowledgeState,
                isFromServer: self.isFromServer)
    }
}
