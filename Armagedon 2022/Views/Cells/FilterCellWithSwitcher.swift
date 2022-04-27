//
//  FilterCellWithSwitcher.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 24.04.2022.
//

import UIKit

final class FilterCellWithSwitcher: UITableViewCell {

    static var id: String { FilterCellWithSwitcher.description() }
    
    private let label: UILabel = {
        
        let label = UILabel()
        
        return label
    }()
    
    private let switcher: UISwitch = {
        
        let switcher = UISwitch()
        
        switcher.addTarget(nil, action: "updateFilters:", for: .valueChanged)
        
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        configSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(with model: FiltersViewModel, indexPathRow: Int, state: Bool){
        
        label.text = model.title
        switcher.tag = indexPathRow
        switcher.isOn = state
    }

    private func configSubview(){
        
        self.contentView.addSubview(switcher, label)
        
        let view = self.contentView
        
        label.constraints(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: nil, paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 0, width: 0, height: 0)
        label.trailingAnchor.constraint(greaterThanOrEqualTo: switcher.leadingAnchor, constant: -15).isActive = true
        switcher.constraints(top: view.topAnchor, bottom: view.bottomAnchor, leading: nil, trailing: view.trailingAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 15, width: 0, height: 0)
    }
}
