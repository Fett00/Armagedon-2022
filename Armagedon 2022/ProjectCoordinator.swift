//
//  ProjectCoordinator.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit

class ProjectCoordinator{
    
    private let dataWorker = DataWorker() //Координация все остальних воркеров. Работа с данными
    private let networkWorker = NetworkWorker() //Работа с сетью
    private let imageWorker = ImageWorker() // Работа с изображениями
    private let fileWorker = FileWorker() // Работа с файлами
    private let jsonDecoderWorker = JSONDecoderWorker() // Декодер JSON
    private let jsonEncoderWorker = JSONEncoderWorker() // Энкодер JSON
    private let coreDataWorker = CoreDataWorker() // Работа с core data
    private let userDefaultsWorker = UserDefaultsWorker()//Работа с user defaults
    private let dateWorker = DateWorker()//Работа с датой
    
    //singleton
    public static let shared = ProjectCoordinator()
    private init(){
        
        dataWorker.coreDataWorker = coreDataWorker
        dataWorker.jsonDecoderWorker = jsonDecoderWorker
        dataWorker.jsonEncoderWorker = jsonEncoderWorker
        dataWorker.networkWorker = networkWorker
        dataWorker.dateWorker = dateWorker
        
        imageWorker.fileWorker = fileWorker
        imageWorker.networkWorker = networkWorker
    }
    
    ///Создание входной точки для приложения
    func createEnteryPointOfProject() -> UIViewController{

        let tabBar = UITabBarController()
        tabBar.tabBar.backgroundColor = .secondarySystemFill

        //Настройка вкладки с меню
        let asteroidsTab = UINavigationController(rootViewController: AsteroidListViewController(dataWorker: self.dataWorker))

        asteroidsTab.tabBarItem = UITabBarItem(title: "Астероиды", image: Images.planet, tag: 0)
        //

        //Настройка вкладки с профилем пользователя
        let destroyingTab = UINavigationController(rootViewController: DestroyListViewController())

        destroyingTab.tabBarItem = UITabBarItem(title: "Уничтожение", image: Images.trashCan, tag: 1)
        //

        tabBar.viewControllers = [asteroidsTab, destroyingTab]

        return tabBar
    }
    
    func createFiltersViewController() -> UIViewController{
        FiltersViewController()
    }
    
    func createDestroyListViewController() -> UIViewController{
        DestroyListViewController()
    }
}
