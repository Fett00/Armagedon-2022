//
//  DestroyingTableViewCell.swift
//
//
//  Created by Садык Мусаев.
//

import UIKit

final class DestroyingTableViewCell: UITableViewCell {

    static var id: String { DestroyingTableViewCell.description() }
    
    //картинка астероида в корзине
    private let asteroidImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = Images.asteroid
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    
    //названия в корзине
    private let asteroidName: UILabel = {
        
        let label = UILabel()
        
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    //расстояние астероида до земли
    private let asteroidDistance: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    //Время прибытия
    private let asteroidTime: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configurateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateCell(){

        self.contentView.addSubview(asteroidImage, asteroidName, asteroidTime, asteroidDistance)
        self.contentView.clipsToBounds = true
        self.selectionStyle = .none
        
        asteroidImage.constraints(top: self.contentView.topAnchor, bottom: self.contentView.bottomAnchor, leading: self.contentView.leadingAnchor, trailing: nil, paddingTop: 20, paddingBottom: 20, paddingLeft: 20, paddingRight: 0, width: 60, height: 60)
        
        asteroidName.constraints(top: self.contentView.topAnchor, bottom: nil, leading: asteroidImage.trailingAnchor, trailing: self.contentView.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 20, paddingRight: 10, width: 0, height: 0)
        
        asteroidTime.constraints(top: asteroidName.bottomAnchor, bottom: nil, leading: asteroidImage.trailingAnchor, trailing: self.contentView.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 20, paddingRight: 10, width: 0, height: 0)
        
        asteroidDistance.constraints(top: asteroidTime.bottomAnchor, bottom: self.contentView.bottomAnchor, leading: asteroidImage.trailingAnchor, trailing: self.contentView.trailingAnchor, paddingTop: 5, paddingBottom: 20, paddingLeft: 20, paddingRight: 10, width: 0, height: 0)
    }
    
    private func setUpCell(asteroid: AsteroidViewModel){
        
        self.asteroidName.text = asteroid.asteroidName
        self.asteroidDistance.text = asteroid.distance
        self.asteroidTime.text = asteroid.destinationTime
        self.asteroidImage.backgroundColor = UIColor(cgColor: asteroid.asteroidDangerousColor.endColor)
        //self.asteroidImage.text = String(meal.price) + " ₽"
    }
    
    private func setUpCellImage(image: UIImage){
        
        asteroidImage.image = image
    }
    
//    override func prepareForReuse() {
//
//        asteroidName.text = ""
//        asteroidDistance.text = ""
//        mealCount.text = "1"
//    }
}
