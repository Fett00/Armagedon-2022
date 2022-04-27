//
//  AsteroidCollectionViewCell.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit

final class AsteroidCollectionViewCell: UICollectionViewCell {
    
    static var id: String { AsteroidCollectionViewCell.description() }
    
    private let asteroidView: UIImageView = {
        
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    private let dangerousGradientLayer: CAGradientLayer = {
        
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradient
    }()
    
    private let asteroidImage: UIImageView = {
       
        let imageView = UIImageView(image: Images.asteroid)
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let dinoImage: UIImageView = {
        
        let imageView = UIImageView(image: Images.dino)
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let asteroidName: UITextField = {
        
        let textField = UITextField()
    
        textField.font = .boldSystemFont(ofSize: 30)
        
        return textField
    }()
    
    private let asteroidDiameter: UILabel = {
        
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
    
    private let asteroidEstimation: UILabel = {
        
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
        _ = 50.0
        let labelHeight = asteroidDiameter.font.lineHeight
        let originX = 10.0
        let inset = 15.0
        let spacing = 5.0
        let spacingY = 15.0
        //let widthX = cellFrame.maxX - originX * 2
        
        let asteroidViewFrame = CGRect(x: cellFrame.minX,
                                        y: cellFrame.minY,
                                        width: cellFrame.width,
                                        height: cellFrame.midY - inset)
        
        let asteroidDiameterFrame = CGRect(x: originX,
                                           y: asteroidViewFrame.maxY + spacingY,
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
                                             width: ((cellFrame.width / 3) * 2) - (inset * 3) - spacing,
                                             height: labelHeight)
        
        asteroidView.frame = asteroidViewFrame
        asteroidDiameter.frame = asteroidDiameterFrame
        asteroidTime.frame = asteroidTimeFrame
        asteroidDistance.frame = asteroidRangeFrame
        asteroidEstimation.frame = asteroidEstimationFrame
        addToDestroyButton.frame = addToDestroyButtonFrame
        
        dangerousGradientLayer.frame = asteroidView.bounds
    }
    
    private func configureCell(){
        
        self.addSubview(asteroidView, asteroidDiameter, asteroidTime, asteroidDistance, asteroidEstimation, addToDestroyButton)
        
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.backgroundColor = .secondarySystemFill
        
        asteroidView.layer.addSublayer(dangerousGradientLayer)
        asteroidView.addSubview(dinoImage, asteroidImage, asteroidName)
        asteroidName.constraints(top: nil, bottom: asteroidView.bottomAnchor, leading: asteroidView.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 10, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        dinoImage.constraints(top: nil, bottom: asteroidView.bottomAnchor, leading: nil, trailing: asteroidView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 40, height: 40)
    }
    
    func render(model: AsteroidViewModel, indexPathElement: IndexPath.Element){
        
        //Сделать адекватное обновление топика с астероидом и динозавром
        
        dangerousGradientLayer.colors = [model.asteroidDangerousColor.startColor, model.asteroidDangerousColor.endColor]
        
        let newOrigin = CGPoint(x: 5, y: 5)
        asteroidImage.frame = CGRect(origin: newOrigin, size: CGSize(width: model.asteroidSize.width, height: model.asteroidSize.height))
        //self.setNeedsLayout()
        //self.layoutIfNeeded()
        
        asteroidName.text = model.asteroidName
        asteroidDiameter.text = model.diameter
        asteroidTime.text = model.destinationTime
        asteroidDistance.text = model.distance
        asteroidEstimation.text = model.isDangerous
        
        addToDestroyButton.tag = indexPathElement
    }
}
