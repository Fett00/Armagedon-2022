//
//  DateWorker.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import Foundation

protocol DateWorkerProtocol{
    
    var currentDate: String { get }
    
    func warp(fromDate: String, onDays: Int)
}

class DateWorker: DateWorkerProtocol{
    
    var currentDate: String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-mm-dd"
        let stringDate = dateFormater.string(from: Date())
        print(stringDate)
        return stringDate
    }
    
    func warp(fromDate: String, onDays: Int) {
        
    }
}
