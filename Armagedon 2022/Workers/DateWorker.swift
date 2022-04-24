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
    
    func convertForViewModel(date: String) -> String
}

class DateWorker: DateWorkerProtocol{
    
    let dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.autoupdatingCurrent
        
        return dateFormatter
    }()
    
    var currentDate: String {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: Date())
        return stringDate
    }
    
    func warp(fromDate: String, onDays: Int) -> String {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar(identifier: .gregorian)
        guard let date = dateFormatter.date(from: fromDate) else { return "" }
        guard let newDate = calendar.date(byAdding: .day, value: onDays, to: date) else { return "" }
        return dateFormatter.string(from: newDate)
    }
    
    func convertForViewModel(date: String) -> String {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let newDate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: newDate)
    }
}
