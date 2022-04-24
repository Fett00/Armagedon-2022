//
//  FilterCellWithSegment.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 24.04.2022.
//

import UIKit

class FilterCellWithSegment: UITableViewCell {
    
    static var id: String { FilterCellWithSegment.description() }
    
    let label: UILabel = {
        
        let label = UILabel()
        
        return label
    }()
    
    let segment: UISegmentedControl = {
        
        let segment = UISegmentedControl()
        
        segment.addTarget(nil, action: "updateFilters:", for: .valueChanged)
        
        return segment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        configSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(with model: FiltersViewModel, indexPathRow: Int, state: FilterDataModel.DestinationType){
        
        label.text = model.title
        
        segment.tag = indexPathRow
        
        switch model.secondaryView{
            
        case .segmenter(let lS, let rS):
            
            segment.insertSegment(withTitle: lS, at: 0, animated: false)
            segment.insertSegment(withTitle: rS, at: 1, animated: false)
            
        case .switcher:
            break
        }
        
        switch state{
            
        case .km:
            segment.selectedSegmentIndex = 0
            
        case .lunar:
            segment.selectedSegmentIndex = 1
        }
        
    }
    
    func configSubview(){
        
        self.contentView.addSubview(segment, label)
        
        let view = self.contentView
        
        label.constraints(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: nil, paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 0, width: 0, height: 0)
        label.trailingAnchor.constraint(greaterThanOrEqualTo: segment.leadingAnchor, constant: -15).isActive = true
        segment.constraints(top: view.topAnchor, bottom: view.bottomAnchor, leading: nil, trailing: view.trailingAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 5, width: 0, height: 0)
    }
}
