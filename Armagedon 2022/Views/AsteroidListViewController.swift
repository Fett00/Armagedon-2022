//
//  AsteroidListViewController.swift
//  Armageddon2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit

class AsteroidListViewController: UIViewController {
    
    let dataWorker: DataWorkerForAsteroidListProtocol
    
    let asteroidsCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collection
    }()
    
    init(dataWorker: DataWorkerForAsteroidListProtocol){
        
        self.dataWorker = dataWorker
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureSubview()
        configureAsteroidsCollectionView()
        dataWorker.requestAsteroidList()
    }
    
    func configureView(){
        
        self.navigationItem.title = "Армагедон 2022"
        self.view.backgroundColor = .systemBackground
        
        let filterBarButtonItem = UIBarButtonItem(image: Images.filter, style: .plain, target: self, action: #selector(openFilters))
        
        self.navigationItem.rightBarButtonItem = filterBarButtonItem
    }
    
    func configureSubview(){
        
    }
    
    func configureAsteroidsCollectionView(){
        
        view.addSubview(asteroidsCollectionView)
        
        
    }
    
    @objc func openFilters(){
        
        let viewToPush = ProjectCoordinator.shared.createFiltersViewController()
        
        self.navigationController?.pushViewController(viewToPush, animated: true)
    }
}
