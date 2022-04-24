//
//  AsteroidDataModel.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 15.04.2022.
//

import UIKit

struct AsteroidViewModel: Equatable{
    
    let asteroidImage: UIView
    let diameter: String
    let destinationTime: String
    let distance: String
    let isDangerous: String
    let orbitingBody: String
    let asteroidName: String
    let asteroidDangerousColor: (startColor: CGColor, endColor: CGColor)
    let asteroidSize: CGSize
    
    static func == (lhs: AsteroidViewModel, rhs: AsteroidViewModel) -> Bool {
        
        lhs.asteroidName == rhs.asteroidName && lhs.asteroidSize == rhs.asteroidSize && lhs.distance == rhs.distance
    }
}
