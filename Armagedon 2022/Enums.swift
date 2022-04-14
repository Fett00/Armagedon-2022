//
//  Enums.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 06.12.2021.
//

import UIKit

enum Images{
    
    static let planet = UIImage(systemName: "globe")!
    static let trashCan = UIImage(systemName: "trash")!
    static let filter = UIImage(systemName: "line.3.horizontal.decrease")!
}

enum URLs{
    
    //URL для получения списка астероидов
    static let nasaURLForNearestObjects = "https://api.nasa.gov/neo/rest/v1/feed?start_date=&end_date=&api_key="
}

enum APIKeys{
    
    //АПИ ключ для получения списка астероидов
    static let nasaAPIKey = "7Go5kfLhZmUsgh3U85HWEhJPuIwq1s8f8fGWHUmd"
}

enum Colors{
    
    static let buttonColor = UIColor(named: "ButtonColor")!
}
