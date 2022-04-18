//
//  FilterDataModel.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 18.04.2022.
//

import Foundation

struct FilterDataModel{
    
    enum DestinationType{
        
        case lunar
        case km
    }
    
    var destinationType: DestinationType = .km
    var showDangerousOnly: Bool = false
}
