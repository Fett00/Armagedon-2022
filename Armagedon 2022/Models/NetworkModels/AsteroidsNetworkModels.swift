//
//  AsteroidModels.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import Foundation


struct NearObjectsModel: Decodable{
    
    let links: Links

    let elementCount: Int
    
    let nearEarthObjects: [String : [NearEarthObjects]]
    
    enum CodingKeys: String, CodingKey{
        
        case links = "links"
        case elementCount = "element_count"
        case nearEarthObjects = "near_earth_objects"
    }
}

struct Links: Decodable{
    
    let next: String
    let prev: String
    let `self`: String
}

struct NearEarthObjects: Decodable{
    
    let id: String
    let name: String
    let estimatedDiameter: EstimatedDiameter
    let isPotentiallyHazardousAsteroid: Bool
    
    enum CodingKeys: String, CodingKey{
        
        case id = "id"
        case name = "name"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case estimatedDiameter = "estimated_diameter"
    }
}

struct EstimatedDiameter: Decodable{
    
    let meters: Meters
}

struct Meters: Decodable{
    
    let estimatedDiameterMin: Float
    let estimatedDiameterMax: Float
    var diameter: Int {

        Int((estimatedDiameterMax + estimatedDiameterMin)/2)
    }
    
    enum CodingKeys: String, CodingKey{
        
        case estimatedDiameterMax = "estimated_diameter_min"
        case estimatedDiameterMin = "estimated_diameter_max"
    }
}
