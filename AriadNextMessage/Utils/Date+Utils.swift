//
//  Date+Utils.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 11/04/2022.
//

import Foundation

extension Date {
    /**
     Function to create date from string in specific format
     - parameters:
        - dateString: date in string
        - format: Date format
     - returns:
     Return Date in specific format
     */
    static func getDateFrom(dateString: String, format: String) -> Date {
        var dateDefault = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        if let currentDate = formatter.date(from: dateString) {
            dateDefault = currentDate
        }
        
        return dateDefault
    }
}
