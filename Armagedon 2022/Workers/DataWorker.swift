////
////  DataWorker.swift
////
////  Created by Садык Мусаев on 12.12.2021.
////

import Foundation
import UIKit

protocol DataWorkerForAsteroidListProtocol{
    
    func requestAsteroidList(handler: @escaping () -> ())
    
    func requestNextAsteroidList(handler: @escaping () -> ())
    
    func addToDestroyingList(index: Int, handler: @escaping () -> ())
    
    func addToDestroyingList(asteroidForDestroy: AsteroidViewModel, handler: @escaping () -> ())
}

protocol DataWorkerCollectedDataForAsteroidList{
    
    var asteroidsViewModel: [AsteroidViewModel] { get }
}

protocol DataWorkerCollectedDataForDestroyList{
    
    var asteroidsForDestroyViewModel: [AsteroidViewModel] { get }
}

protocol DataWorkerForDestroyListProtocol{
    
    func requestDestroingList(handler: @escaping () -> ())
    
    func clearDestroyingList(handler: @escaping () -> ())
}

protocol DataWorkerForFiltersProtocol{
    
    func updateFilters(newFilter: FilterDataModel)
    
    func getFilters() -> FilterDataModel
    
    var filter: FilterDataModel { get set }
    
    var filtersViewModel: [FiltersViewModel] { get }
}

protocol DataWorkerForDetailListProtocol{
    
    func addToDestroyingList(asteroidForDestroy: AsteroidViewModel, handler: @escaping () -> ())
}

final class DataWorker: DataWorkerForAsteroidListProtocol, DataWorkerForDestroyListProtocol, DataWorkerForFiltersProtocol, DataWorkerCollectedDataForAsteroidList, DataWorkerCollectedDataForDestroyList, DataWorkerForDetailListProtocol{
    
    var coreDataWorker: CoreDataWorkerProtocol!
    var jsonDecoderWorker: JSONDecoderWorkerProtocol!
    var jsonEncoderWorker: JSONEncoderWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!
    var dateWorker: DateWorkerProtocol!
    var imageWorker: ImageWorkerProtocol!
    
    var asteroidsDataModel = [AsteroidDataModel]()
    var asteroidsViewModel = [AsteroidViewModel]()
    var asteroidsForDestroyDataModel = [AsteroidDataModel]()
    var asteroidsForDestroyViewModel = [AsteroidViewModel]()
    var filter = FilterDataModel()
    let filtersViewModel: [FiltersViewModel] = [
        
        .init(title: "Ед. изм. расстояний", secondaryView: .segmenter("км", "л. орб.")),
        .init(title: "Показывать только опасные", secondaryView: .switcher)
    ]
    
    private var currentURL: String = ""
    private var nextURL: String = ""
    
    func requestAsteroidList(handler: @escaping () -> ()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let group = DispatchGroup() //Контроль потока
            
            let currentDate = self.dateWorker.currentDate //Текущая дата
            let nextDate = self.dateWorker.warp(fromDate: currentDate, onDays: 1) //Текущая дата + max(7) дней (ограничение api)
            
            //Подготовка url
            var rawUrl = URLs.nasaURLForNearestObjects
            rawUrl = rawUrl.replacingOccurrences(of: "start_date=", with: "start_date=\(currentDate)")
            rawUrl = rawUrl.replacingOccurrences(of: "end_date=", with: "end_date=\(nextDate)")
            let url = rawUrl.replacingOccurrences(of: "api_key=", with: "api_key=\(APIKeys.nasaAPIKey)")
            //
            if self.currentURL != url{
                
                print("FROM NETWORK")
                
                var model: NearObjectsModel?
                
                group.enter()
                //Запрос в сеть
                self.networkWorker.getData(from: url) { result in
                    
                    
                    switch result{
                        
                    case .failure(let error):
                        
                        print("Network Error: \(error.localizedDescription)")
                        
                        
                    case .success(let data):
                        
                        //Декодирование данных из сети в модель
                        model = self.jsonDecoderWorker.decode(type: NearObjectsModel.self, data: data)
                    }
                    
                    group.leave()
                }
                
                group.wait()//Ожидание завершения обработки нетворка
                
                guard let strongModel = model else { return }
                
                self.currentURL = strongModel.links.selfLink
                self.nextURL = strongModel.links.next
                
                //Создание Data Model
                let _ = strongModel.nearEarthObjects.map {
                    
                    $1.map { object in
                        
                        let detailApproachDataModel = object.approachInfo.map{
                            
                            DetailApproachDataModel(distanceKm: Int(Float($0.missDistance.kilometers) ?? 0), distanceLunar: Int(Float($0.missDistance.lunar) ?? 0), orbitingBody: $0.closeApproachDate , velocity: Int(Float($0.velocity.kmps) ?? 0), destinationTime: $0.orbitingBody)
                        }
                        
                        self.asteroidsDataModel.append(AsteroidDataModel(
                            name: object.name,
                            diameter: object.estimatedDiameter.meters.diameter,
                            destinationTime: object.approachInfo[0].orbitingBody,
                            distanceKm: Int(Float(object.approachInfo[0].missDistance.kilometers) ?? 0),
                            distanceLunar: Int(Float(object.approachInfo[0].missDistance.lunar) ?? 0),
                            isDangerous: object.isPotentiallyHazardousAsteroid,
                            orbitingBody: object.approachInfo[0].closeApproachDate, detailApproachDataModel: detailApproachDataModel))
                    }
                }
                
                self.createViewModel()
                
                DispatchQueue.main.async {
                    handler()
                }
            }
            else{
                print("FROM DATA MODEL")
                self.createViewModel()
                DispatchQueue.main.async {
                    handler()
                }
            }
        }
    }
    
    func requestNextAsteroidList(handler: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.currentURL = self.nextURL
            
            DispatchQueue.main.async {
                
                handler()
            }
        }
    }
    
    func createViewModel(){

        var newAsteroidsViewModel: [AsteroidViewModel] = []
        //Создание View Model
        let _ = self.asteroidsDataModel.map { dataObject in
            
            let detailApproachViewModel: [DetailApproachViewModel] = dataObject.detailApproachDataModel.map{
                
                let destination: String
                let velocity: String = "со скоростью \($0.velocity) км/с"
                let orbitingBody: String = "Орбитой вращения является: \(dataObject.orbitingBody)"
                
                switch self.filter.destinationType{
                    
                case .km:
                    destination = "на расстояние \(dataObject.distanceKm) км"
                case .lunar:
                    destination = "на расстояние \(dataObject.distanceLunar) лунных орбит"
                }
                
                return DetailApproachViewModel(distance: destination, orbitingBody: orbitingBody, velocity: velocity, destinationTime: "Подлетает \(self.dateWorker.convertForViewModel(date: dataObject.destinationTime))")
            }
            
            if (filter.showDangerousOnly && dataObject.isDangerous) || !(filter.showDangerousOnly){
                
                let computedDiameter: String
                let isDangerous: String
                let destination: String
                let asteroidSize: CGSize
                let dangerousColor: (startColor: CGColor, endColor: CGColor)
                
                if dataObject.diameter > 1100 {
                    computedDiameter = "Диаметр: \(dataObject.diameter / 1000) км"
                }
                else{
                    computedDiameter = "Диаметр: \(dataObject.diameter) м"
                }
                
                if dataObject.isDangerous{
                    isDangerous = "Опасность: опасен"
                    dangerousColor = (Colors.dcL.cgColor, Colors.dcR.cgColor)
                }
                else{
                    isDangerous = "Опасность: не опасен"
                    dangerousColor = (Colors.ndcL.cgColor, Colors.ndcR.cgColor)
                }
                
                switch self.filter.destinationType{
                    
                case .km:
                    destination = "на расстояние \(dataObject.distanceKm) км"
                case .lunar:
                    destination = "на расстояние \(dataObject.distanceLunar) лунных орбит"
                }
                
                switch dataObject.diameter{
                    
                case 0..<20:
                    asteroidSize = CGSize(width: 20, height: 20)
                case 20..<150:
                    asteroidSize = CGSize(width: dataObject.diameter, height: dataObject.diameter)
                case 150..<200:
                    asteroidSize = CGSize(width: 100, height: 100)
                case 200...:
                    asteroidSize = CGSize(width: 150, height: 150)
                    
                default:
                    asteroidSize = CGSize(width: 100, height: 100)
                }
                
                newAsteroidsViewModel.append(AsteroidViewModel(
                    diameter: computedDiameter,
                    destinationTime: "Подлетает \(self.dateWorker.convertForViewModel(date: dataObject.destinationTime))",
                    distance: destination,
                    isDangerous: isDangerous,
                    orbitingBody: "Орбитой вращения является \(dataObject.orbitingBody)", asteroidName: dataObject.name, asteroidDangerousColor: dangerousColor, asteroidSize: asteroidSize, detailApproachViewModel: detailApproachViewModel))
            }
        }
        
        self.asteroidsViewModel = newAsteroidsViewModel
    }
    
    func addToDestroyingList(index: Int, handler: @escaping () -> ()){
        
        var isContain: Bool = false
        let asteroidForDestroy = asteroidsViewModel[index]
        
        for asteroid in asteroidsForDestroyViewModel{
            
            if asteroid == asteroidForDestroy{
                
                isContain = true
            }
        }
        
        if !isContain{
            
            asteroidsForDestroyViewModel.append(asteroidForDestroy)
        }
    }
    
    func addToDestroyingList(asteroidForDestroy: AsteroidViewModel, handler: @escaping () -> ()){
        
        var isContain: Bool = false
        
        for asteroid in asteroidsForDestroyViewModel{
            
            if asteroid == asteroidForDestroy{
                
                isContain = true
            }
        }
        
        if !isContain{
            
            asteroidsForDestroyViewModel.append(asteroidForDestroy)
        }
    }
    
    func updateFilters(newFilter: FilterDataModel){
        
        self.filter = newFilter
    }
    
    func getFilters() -> FilterDataModel{
        return self.filter
    }
    
    func requestDestroingList(handler: @escaping () -> ()) {
        
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            DispatchQueue.main.async {
//                handler()
//            }
//        }
        handler()
    }
    
    func clearDestroyingList(handler: @escaping () -> ()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.asteroidsForDestroyViewModel = []
            
            DispatchQueue.main.async {
                handler()
            }
        }
    }
}
