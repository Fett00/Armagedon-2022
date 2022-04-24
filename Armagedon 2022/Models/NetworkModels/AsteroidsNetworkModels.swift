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
    let selfLink: String
    
    enum CodingKeys: String, CodingKey{
        
        case next = "next"
        case prev = "prev"
        case selfLink = "self"
    }
}

struct NearEarthObjects: Decodable{
    
    let id: String
    let name: String
    let estimatedDiameter: EstimatedDiameter
    let isPotentiallyHazardousAsteroid: Bool
    let approachInfo: [ApproachInfo]
    
    enum CodingKeys: String, CodingKey{
        
        case id = "id"
        case name = "name"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case estimatedDiameter = "estimated_diameter"
        case approachInfo = "close_approach_data"
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

struct ApproachInfo: Decodable{
    
    let orbitingBody: String
    let closeApproachDate: String
    let missDistance: MissDistance
    
    enum CodingKeys: String, CodingKey{
        
        case orbitingBody = "close_approach_date"
        case closeApproachDate = "orbiting_body"
        case missDistance = "miss_distance"
    }
}

struct MissDistance: Decodable{
    
    let lunar: String
    let kilometers: String
}
