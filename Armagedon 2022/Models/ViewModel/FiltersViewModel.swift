//
//  FilterViewModel.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 21.04.2022.
//

import Foundation


struct FiltersViewModel{
    
    enum SecondaryView{
        
        case switcher
        case segmenter(String, String)
    }
    
    let title: String
    let secondaryView: SecondaryView
}
