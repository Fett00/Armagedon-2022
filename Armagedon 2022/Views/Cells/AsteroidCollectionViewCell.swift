//
//  AsteroidCollectionViewCell.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit

class AsteroidCollectionViewCell: UICollectionViewCell {
    
    static var id: String { AsteroidCollectionViewCell.description() }
    
    private let asteroidImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let asteroidDiameter: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let asteroidRange: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.numberOfLines = 1
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
        button.layer.cornerRadius = 20
        button.setTitle("УНИЧТОЖИТЬ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.buttonColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        //button.addTarget(nil, action: Selector(("addToCart:")), for: .touchUpInside)
        
        return button
    }()
    
    private let asteroidEstimation: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .secondarySystemFill
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellFrame = self.bounds
        let buttonHeight = 50.0
        let labelHeight = asteroidDiameter.font.lineHeight
        let originX = 10.0
        let inset = 15.0
        let spacing = 5.0
        let spacingY = 15.0
        //let widthX = cellFrame.maxX - originX * 2
        
        let asteroidImageFrame = CGRect(x: cellFrame.minX,
                                        y: cellFrame.minY,
                                        width: cellFrame.width,
                                        height: cellFrame.midY - inset)
        
        let asteroidDiameterFrame = CGRect(x: originX,
                                           y: asteroidImageFrame.maxY + spacingY,
                                           width: cellFrame.width - inset,
                                           height: labelHeight)
        
        let asteroidTimeFrame = CGRect(x: originX,
                                       y: asteroidDiameterFrame.maxY + spacingY,
                                       width: cellFrame.width - inset,
                                       height: labelHeight)
        
        let asteroidRangeFrame = CGRect(x: originX,
                                        y: asteroidTimeFrame.maxY + spacingY,
                                        width: cellFrame.width - inset,
                                        height: labelHeight)
        
        let addToDestroyButtonFrame = CGRect(x: ((cellFrame.width / 3) * 2) - (inset * 2),
                                             y: asteroidRangeFrame.maxY + spacingY,
                                             width: (cellFrame.width / 3) + inset,
                                             height: labelHeight * 1.5)
        
        let asteroidEstimationFrame = CGRect(x: originX,
                                             y: addToDestroyButtonFrame.midY - (labelHeight / 2),
                                             width: ((cellFrame.width / 3) * 2) - (inset * 2) - spacing,
                                             height: labelHeight)
        
        asteroidImage.frame = asteroidImageFrame
        asteroidDiameter.frame = asteroidDiameterFrame
        asteroidTime.frame = asteroidTimeFrame
        asteroidRange.frame = asteroidRangeFrame
        asteroidEstimation.frame = asteroidEstimationFrame
        addToDestroyButton.frame = addToDestroyButtonFrame
    }
    
    func configureCell(){
        
        self.addSubview(asteroidImage, asteroidDiameter, asteroidTime, asteroidRange, asteroidEstimation, addToDestroyButton)
        
        self.backgroundColor = .systemBackground
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.backgroundColor = .secondarySystemFill
        
        asteroidImage.backgroundColor = .blue
        asteroidDiameter.text = "Диаметр: "
        asteroidTime.text = "Подлетает "
        asteroidRange.text = "на расстояние "
        asteroidEstimation.text = "Оценка: "
    }
    
    func render(){
        
    }
}
