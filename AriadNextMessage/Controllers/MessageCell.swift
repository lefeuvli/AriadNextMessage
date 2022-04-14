//
//  MessageCell.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private(set) var messageStackView: UIStackView!
    @IBOutlet private(set) var messageLabel: UILabel!
    @IBOutlet private(set) var dateLabel: UILabel!
    @IBOutlet private(set) var aknowledgeImageView: UIImageView!
    
    public static var name = "MessageCell"
    
    private let serverColor = UIColor(red: 60 / 255, green: 99 / 255, blue: 130 / 255, alpha: 1)
    private let clientColor = UIColor(red: 7 / 255, green: 153 / 255, blue: 146 / 255, alpha: 1)
    
    // MARK: - Funcs
    
    func configure(with message: Message) {
        messageStackView.layer.cornerRadius = 6
        let currentColor = message.isFromServer ? serverColor : clientColor
        
        messageLabel.text = message.contentText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd - HH:mm:ss"
        dateLabel.text = dateFormatter.string(for: message.contentDate)
        
        var imageAknowledge = UIImage(named: Images.more.rawValue)
        if message.acknowledgeState == .received {
            imageAknowledge = UIImage(named: Images.check.rawValue)
            aknowledgeImageView.image = imageAknowledge?.with(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            aknowledgeImageView.layer.cornerRadius = aknowledgeImageView.bounds.width / 2
            aknowledgeImageView.layer.borderWidth = 1
            aknowledgeImageView.layer.borderColor = currentColor.cgColor
        } else {
            aknowledgeImageView.image = imageAknowledge
        }
        
        aknowledgeImageView.tintColor = currentColor
        if message.acknowledgeState == .notSend {
            aknowledgeImageView.tintColor = .red
        }
        
        messageStackView.backgroundColor = currentColor
        messageLabel.textAlignment = message.isFromServer ? .left : .right
        dateLabel.textAlignment = message.isFromServer ? .left : .right
        aknowledgeImageView.isHidden = message.isFromServer
    }
    
    override func prepareForReuse() {
        aknowledgeImageView.image = UIImage(named: Images.more.rawValue)
        aknowledgeImageView.layer.borderWidth = 0
        aknowledgeImageView.layer.cornerRadius = 0
    }
}
