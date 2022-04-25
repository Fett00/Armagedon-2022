//
//  DetailViewController.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 25.04.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    let model: AsteroidViewModel
    
    let detailCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    let headerView: UIView = {
        
        let view = UIView()
        
        
        
        return view
    }()
    
    private let headerAsteroidView: UIImageView = {
        
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    private let headerDangerousGradientLayer: CAGradientLayer = {
        
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradient
    }()
    
    private let headerAsteroidImage: UIImageView = {
       
        let imageView = UIImageView(image: Images.asteroid)
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let headerDinoImage: UIImageView = {
        
        let imageView = UIImageView(image: Images.dino)
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let headerAsteroidName: UITextField = {
        
        let textField = UITextField()
    
        textField.font = .boldSystemFont(ofSize: 30)
        
        return textField
    }()
    
    private let headerAsteroidDiameter: UILabel = {
        
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
    
    private let headerAsteroidDistance: UILabel = {
        
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
    
    private let headerAsteroidTime: UILabel = {
        
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
    
    private let headerAsteroidEstimation: UILabel = {
        
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

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    init(model: AsteroidViewModel){
        
        self.model = model
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func confView(){
        
        let doneButton = UIBarButtonItem(image: Images.backArrow, style: .done , target: self, action: #selector(closeView))
        
        self.navigationItem.leftBarButtonItem = doneButton
        
        view.backgroundColor = .systemBackground
        self.navigationItem.title = model.asteroidName
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func confSubview(){
        
        view.addSubview(headerView, detailCollectionView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        headerView.constraints(top: safe.topAnchor, bottom: nil, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        detailCollectionView.constraints(top: headerView.bottomAnchor, bottom: safe.bottomAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, paddingTop: 0, paddingBottom: 20, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
    }
    
    private func confCollectionView(){
        
    }
    
    private func confHeaderView(){
        
        headerView.addSubview(headerAsteroidTime, headerAsteroidDiameter, headerAsteroidDistance, headerAsteroidEstimation, headerAsteroidView)
        
        headerAsteroidView.layer.addSublayer(headerDangerousGradientLayer)
        headerAsteroidView.addSubview(headerDinoImage, headerAsteroidImage, headerAsteroidName)
        
        headerAsteroidName.constraints(top: nil, bottom: headerAsteroidView.bottomAnchor, leading: headerAsteroidView.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 10, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        headerDinoImage.constraints(top: nil, bottom: headerAsteroidView.bottomAnchor, leading: headerAsteroidName.trailingAnchor, trailing: headerAsteroidView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 40, height: 40)
        headerAsteroidImage.constraints(top: headerAsteroidView.topAnchor, bottom: nil, leading: headerAsteroidView.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        headerAsteroidView.constraints(top: headerView.topAnchor, bottom: headerView.centerYAnchor, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        headerAsteroidDiameter.constraints(top: headerAsteroidView.bottomAnchor, bottom: nil, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        
        headerAsteroidTime.constraints(top: headerAsteroidDiameter.bottomAnchor, bottom: nil, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        
        headerAsteroidDistance.constraints(top: headerAsteroidDistance.bottomAnchor, bottom: nil, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        
        headerAsteroidEstimation.constraints(top: headerAsteroidEstimation.bottomAnchor, bottom: nil, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
    }
    
    func loadDataForHeader(){
        
        headerDangerousGradientLayer.colors = [model.asteroidDangerousColor.startColor, model.asteroidDangerousColor.endColor]
        
        //let newOrigin = CGPoint(x: 5, y: 5)
        headerAsteroidImage.frame.size = CGSize(width: model.asteroidSize.width, height: model.asteroidSize.height)//CGRect(origin: newOrigin, size: CGSize(width: model.asteroidSize.width, height: model.asteroidSize.height))
        //self.setNeedsLayout()
        //self.layoutIfNeeded()
        
        headerAsteroidName.text = model.asteroidName
        headerAsteroidDiameter.text = model.diameter
        headerAsteroidTime.text = model.destinationTime
        headerAsteroidDistance.text = model.distance
        headerAsteroidEstimation.text = model.isDangerous
    }
    
    @objc func closeView(){
        
        self.dismiss(animated: true, completion: nil)
    }
}
