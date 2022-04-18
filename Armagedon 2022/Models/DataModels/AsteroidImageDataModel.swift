//
//  AsteroidImageDataWorker.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 15.04.2022.
//

import UIKit

struct AsteroidImageDataModel{
    
    enum AsteroidSize{
        
        case small
        case medium
        case big
    }
    
    let asteroidName: String
    let asteroidSize: AsteroidSize
    let isDangerous: Bool
    let imageSize: CGSize
}
