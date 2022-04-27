//
//  AsteroidCollectionViewCell.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    
    static var id: String { DetailCollectionViewCell.description() }
    
    private let asteroidDistance: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize:  16)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let asteroidTime: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize:  16)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let asteroidVelocity: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize:  16)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let asteroidOrbitingBody: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize:  16)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let addToDestroyButton: UIButton = {
        
        let button = UIButton()
        
        
        button.layer.borderWidth = 0.2
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 15
        button.setTitle("УНИЧТОЖИТЬ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.buttonColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(nil, action: "addToDestroying:", for: .touchUpInside)
        //button.addTarget(nil, action: Selector(("addToCart:")), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .secondarySystemFill
        configureCell()
        confSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.backgroundColor = .secondarySystemFill
        
    }
    
    private func confSubview(){
        
        self.addSubview(asteroidTime, asteroidDistance, asteroidVelocity, asteroidOrbitingBody, addToDestroyButton)
        
        asteroidTime.constraints(top: self.topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        asteroidDistance.constraints(top: asteroidTime.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        asteroidVelocity.constraints(top: asteroidDistance.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        asteroidOrbitingBody.constraints(top: asteroidVelocity.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        addToDestroyButton.constraints(top: asteroidOrbitingBody.bottomAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 15, paddingBottom: 15, paddingLeft: 10, paddingRight: 10, width: 0, height: 40)
    }
    
    private func render(model: DetailApproachViewModel, indexPathElement: IndexPath.Element){
        
        asteroidTime.text = model.destinationTime
        asteroidDistance.text = model.distance
        asteroidVelocity.text = model.velocity
        asteroidOrbitingBody.text = model.orbitingBody
        
        addToDestroyButton.tag = indexPathElement
    }
}
