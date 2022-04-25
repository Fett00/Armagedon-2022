//
//  AsteroidDataModel.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 15.04.2022.
//

import Foundation

struct AsteroidDataModel{
    
    let name: String
    let diameter: Int
    let destinationTime: String
    let distanceKm: Int
    let distanceLunar: Int
    let isDangerous: Bool
    let orbitingBody: String
    let detailApproachDataModel: [DetailApproachDataModel]
}

struct DetailApproachDataModel{
    
    let distanceKm: Int
    let distanceLunar: Int
    let orbitingBody: String
    let velocity: Int
    let destinationTime: String
}
