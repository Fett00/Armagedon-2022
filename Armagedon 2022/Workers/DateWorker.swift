//
//  DateWorker.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import Foundation

protocol DateWorkerProtocol{
    
    var currentDate: String { get }
    
    func warp(fromDate: String, onDays: Int) -> String
}

class DateWorker: DateWorkerProtocol{
    
    var currentDate: String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormater.string(from: Date())
        return stringDate
    }
    
    func warp(fromDate: String, onDays: Int) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar(identifier: .gregorian)
        guard let date = dateFormatter.date(from: fromDate) else { return "" }
        guard let newDate = calendar.date(byAdding: .day, value: onDays, to: date) else { return "" }
        return dateFormatter.string(from: newDate)
    }
}
