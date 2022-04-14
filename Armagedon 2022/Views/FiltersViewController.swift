//
//  FiltersViewController.swift
//  Armageddon2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit

class FiltersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubview()
    }
    
    func configureView(){
        
        self.navigationItem.title = "Фильтр"
        self.view.backgroundColor = .systemBackground
        
        let acceptBarButtonItem = UIBarButtonItem(title: "Применить", style: .plain, target: self, action: #selector(acceptFilter))
        
        self.navigationItem.rightBarButtonItem = acceptBarButtonItem
    }
    
    func configureSubview(){
        
    }
                                                  
    @objc func acceptFilter(){
            
    }
}

