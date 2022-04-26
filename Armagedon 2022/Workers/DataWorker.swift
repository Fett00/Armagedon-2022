////
////  DataWorker.swift
////
////  Created by Садык Мусаев on 12.12.2021.
////
//
//import UIKit
//import CoreData
//
//protocol DataWorkerForAddToCartProtocol: AnyObject{
//
//    func addMealToCart(byIndex: Int, handler: @escaping () -> ())
//}
//
//protocol DataWorkerForMainMenueProtocol: AnyObject, DataWorkerForAddToCartProtocol{
//
//    var delegate: DataWorkerDelegate? { get set }
//
//    func requestCategories()
//
//    func requestMeals(for category: String)
//
//    func addMealToCart(byIndex: Int, handler: @escaping () -> ())
//}
//
//protocol DataWorkerForCartProtocol: AnyObject{
//
//    func requestCartContent(withCondition condition: String?, handler: @escaping () -> ())
//
//    func requestClearCart(withCondition condition: String?, handler: @escaping () -> ())
//
//    func changeMealValue(mealID: String, increaseOrDecrease: Bool, handler: @escaping () -> ())
//}
//
//protocol DataWorkerCollectedDataForCartProtocol: AnyObject{
//
//    var cartContent: [CartContentModel] { get }
//}
//
//protocol DataWorkerCollectedDataProtocol: AnyObject{
//
//    var categoryModels: [CategoryModel] { get } //Массив с категориями
//
//    var mealModels: [MealModel] { get } //Массив для хранения блюд текущей категории
//}
//
//protocol DataWorkerDelegate: AnyObject {
//
//    func updateCategories()
//
//    func updateMeals()
//}
//
//
//
//final class DataWorker: DataWorkerForMainMenueProtocol, DataWorkerForCartProtocol, DataWorkerCollectedDataProtocol, DataWorkerCollectedDataForCartProtocol{
//
//    weak var delegate: DataWorkerDelegate? //Заменить на множественное делегирование
//
//
//
//    var coreDataWorker: CoreDataWorkerProtocol!
//    var jsonDecoderWorker: JSONDecoderWorkerProtocol!
//    var jsonEncoderWorker: JSONEncoderWorkerProtocol!
//    var networkWorker: NetworkWorkerProtocol!
//
//    //АПИ для получения категорий
//    private let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
//
//    //АПИ для получения блюд для категории
//    private let mealsURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
//
//    //Массив с категориями
//    var categoryModels: [CategoryModel] = [CategoryModel]()
//
//    //Массив для хранения блюд текущей категории
//    var mealModels: [MealModel] = [MealModel]()
//
//    // Массив с содержимым корзины
//    var cartContent: [CartContentModel] = [CartContentModel]()
//
//
//    func requestCategories() {
//
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            let sortingBy = ["categoryID"]
//
//            let categoriesFormCD = self.coreDataWorker.get(type: CDCategory.self, sortingBy: sortingBy, withCondition: nil, withLimit: nil, offset: nil).map{ CategoryModel(idCategory: String($0.categoryID), strCategory: $0.categoryName ?? "") }
//
//
//            if !categoriesFormCD.isEmpty{
//
//                self.categoryModels = categoriesFormCD
//
//                DispatchQueue.main.async {
//
//                    print("Categ from CD")
//                    self.delegate?.updateCategories()
//                }
//            }
//            //
//
//            self.networkWorker.getData(from: self.categoriesURL) { result in
//
//                switch result {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                case .success(let data):
//
//                    guard let categories = self.jsonDecoderWorker.decode(type: CategoriesModel.self, data: data)?.categories else { return }
//
//
//                    var coreDataNeedToUpdate = false
//                    if categories.count != self.categoryModels.count{
//
//                        coreDataNeedToUpdate = true
//                        self.categoryModels = categories
//
//                        DispatchQueue.main.async {
//                            self.delegate?.updateCategories()
//                        }
//                    }
//
//                    if coreDataNeedToUpdate{
//
//                        self.coreDataWorker.delete(type: CDCategory.self, withCondition: nil) {
//
//                            self.coreDataWorker.add { context in
//
//                                for category in categories {
//
//                                    let cdCategory = CDCategory(context: context)
//
//                                    cdCategory.categoryName = category.strCategory
//                                    cdCategory.categoryID = Int32(category.idCategory) ?? -1
//                                }
//                            } handler: {}
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//    func requestMeals(for category: String) {
//
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            let condition = "categoryName=\(category)"
//            let sortedBy = ["mealName", "mealID"]
//
//            //Если присваивать прямо, появляется ошибка
//            //self.mealModels = []
//            let mealsFromCD = self.coreDataWorker.get(type: CDMeal.self, sortingBy: sortedBy, withCondition: condition, withLimit: nil, offset: nil).map{ MealModel(strMeal: $0.mealName ?? "", strMealThumb: $0.mealImageURL ?? "", idMeal: String($0.mealID), price: Int($0.price)) }
//
//
//            if !mealsFromCD.isEmpty{
//
//                self.mealModels = mealsFromCD
//
//                DispatchQueue.main.async {
//
//                    print("Meals from CORE DATA")
//                    self.delegate?.updateMeals()
//                }
//            }
//            //
//
//            self.networkWorker.getData(from: self.mealsURL + category) { result in
//
//                switch result {
//                case .failure(let error):
//
//                    print(error.localizedDescription)
//                case .success(let data):
//
//                    guard var meals = self.jsonDecoderWorker.decode(type: MealsModel.self, data: data)?.meals else { return }
//
//                    for i in 0..<meals.count{
//                        meals[i].price = (Int.random(in: 100...4000))
//                    }
//
//                    var coreDataNeedToUpdate = false
//                    if meals.count != self.mealModels.count{
//
//                        if !self.mealModels.isEmpty{
//                            coreDataNeedToUpdate = true
//                        }
//
//                        self.mealModels = meals
//
//                        //self.coreDataWorker.delete(type: CDCartContent.self, withCondition: nil, handler: {})
//
//                        DispatchQueue.main.async {
//                            print("Meal from net")
//                            self.delegate?.updateMeals()
//                        }
//                    }
//
//                    if coreDataNeedToUpdate{
//                        print("Create cache in CD")
//                        self.coreDataWorker.delete(type: CDMeal.self, withCondition: condition) {
//
//                            self.coreDataWorker.add { context in
//                                for meal in meals {
//
//                                    let cdMeal = CDMeal(context: context)
//
//                                    cdMeal.mealID = Int32(meal.idMeal) ?? -1
//                                    cdMeal.mealImageURL = meal.strMealThumb
//                                    cdMeal.mealName = meal.strMeal
//                                    cdMeal.categoryName = category
//                                    cdMeal.price = Int32(meal.price)
//                                }
//                            } handler: {}
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func addMealToCart(byIndex: Int, handler: @escaping () -> ()){
//
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            let condition = "mealID=\(self.mealModels[byIndex].idMeal)"
//
//            if self.coreDataWorker.count(type: CDCartContent.self, withCondition: condition, withLimit: nil, offset: nil) != 0 {
//
//                self.coreDataWorker.changeIntegerValue(type: CDCartContent.self, withCondition: condition, key: "count", increaseOrDecrease: true) {
//
//                    print("Add another meal to cart")
//                    handler()
//                }
//            }
//
//            else{
//
//                let meal = self.mealModels[byIndex]
//
//                self.coreDataWorker.add { context in
//
//                    let cdModel = CDCartContent(context: context)
//
//                    cdModel.imageURL = meal.strMealThumb
//                    cdModel.price = Int32(meal.price)
//                    cdModel.name = meal.strMeal
//                    cdModel.count = 1
//                    cdModel.mealID = Int32(meal.idMeal) ?? -1
//
//                } handler: {
//                    print("Add to cart")
//                    handler()
//                }
//            }
//        }
//    }
//
//    func requestCartContent(withCondition condition: String?, handler: @escaping () -> ()){
//
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            self.cartContent = self.coreDataWorker.get(type: CDCartContent.self, sortingBy: nil, withCondition: condition, withLimit: nil, offset: nil).map{ CartContentModel(name: $0.name ?? "", price: Int($0.price), count: Int($0.count), imageURL: $0.imageURL ?? "", mealID: Int($0.mealID)) }
//
//            DispatchQueue.main.async {
//                handler()
//            }
//        }
//    }
//
//    func requestClearCart(withCondition condition: String?, handler: @escaping () -> ()) {
//
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            self.coreDataWorker.delete(type: CDCartContent.self, withCondition: condition) {
//
//                DispatchQueue.main.async {
//                    handler()
//                }
//            }
//        }
//    }
//
//    func changeMealValue(mealID: String, increaseOrDecrease: Bool, handler: @escaping () -> ()){
//
//        let condition = "mealID=\(mealID)"
//
//        if self.coreDataWorker.count(type: CDCartContent.self, withCondition: condition, withLimit: nil, offset: nil) != 0 {
//
//            self.coreDataWorker.changeIntegerValue(type: CDCartContent.self, withCondition: condition, key: "count", increaseOrDecrease: increaseOrDecrease) {
//
//                handler()
//            }
//        }
//    }
//}
//

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

class DataWorker: DataWorkerForAsteroidListProtocol, DataWorkerForDestroyListProtocol, DataWorkerForFiltersProtocol, DataWorkerCollectedDataForAsteroidList, DataWorkerCollectedDataForDestroyList, DataWorkerForDetailListProtocol{
    
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
    let filtersViewModel: [FiltersViewModel]  = [
        
        .init(title: "Ед. изм. расстояний", secondaryView: .segmenter("км", "л. орб.")),
        .init(title: "Показывать только опасные", secondaryView: .switcher)
    ]
    
    var currentURL: String = ""
    var nextURL: String = ""
    
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
                
                let imageModel = AsteroidImageDataModel(asteroidName: dataObject.name, asteroidSize: .medium, isDangerous: dataObject.isDangerous, imageSize: CGSize(width: 400, height: 200) )
                
                newAsteroidsViewModel.append(AsteroidViewModel(
                    asteroidImage: self.imageWorker.createViewWithAsteroidAndDinosaur(model: imageModel),
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
