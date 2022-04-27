//
//  DetailViewController.swift
//  Armagedon 2022
//
//  Created by Садык Мусаев on 25.04.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let model: AsteroidViewModel
    private let dataWorker: DataWorkerForDetailListProtocol
    
    private let detailCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    private let headerView: UIView = {
        
        let view = UIView()
        
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
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
    
    init(model: AsteroidViewModel, dataWorker: DataWorkerForDetailListProtocol){
        
        self.model = model
        self.dataWorker = dataWorker
        
        super.init(nibName: nil, bundle: nil)
        
//        confView()
//        confSubview()
//        confHeaderView()
//        confCollectionView()
//        loadDataForHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        confView()
        confSubview()
        confHeaderView()
        //confCollectionView()
        loadDataForHeader()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        headerDangerousGradientLayer.frame = headerView.bounds
        confCollectionView()
    }
    
    private func confView(){
        
        let doneButton = UIBarButtonItem(image: Images.backArrow, style: .done , target: self, action: #selector(closeView))
        
        self.navigationItem.leftBarButtonItem = doneButton
        
        self.navigationItem.title = model.asteroidName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = .systemBackground
    }
    
    private func confSubview(){
        
        view.addSubview(headerView, detailCollectionView)
        
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
        detailCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.id)
        
        let safe = self.view.safeAreaLayoutGuide
        
        headerView.constraints(top: safe.topAnchor, bottom: nil, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        detailCollectionView.constraints(top: headerView.bottomAnchor, bottom: safe.bottomAnchor, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 10, paddingBottom: 20, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func confCollectionView(){
        
        guard let flowLayout = detailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        var cellAtRow: CGFloat = 1.0
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let spacing = 20.0
        let collectionWidth = detailCollectionView.frame.width
        
        switch collectionWidth{

        case ..<390:
            cellAtRow = 1
        case 390..<390*2:
            cellAtRow = 2
        case 390*2..<390*3:
            cellAtRow = 3
        default:
            cellAtRow = 1
        }
        
        let itemHeight = UIFont.preferredFont(forTextStyle: .title3).lineHeight * 4 + 15 * 6 + 40
        let itemWidth = (collectionWidth - insets.left - insets.right - spacing * (cellAtRow - 1))
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        //flowLayout.sectionInset = insets
        detailCollectionView.contentInset = insets
        flowLayout.itemSize = CGSize(width: itemWidth / cellAtRow, height: (itemHeight * 0.9))
    }
    
    private func confHeaderView(){
        
        headerView.layer.cornerCurve = .continuous
        headerView.layer.cornerRadius = 20
        headerView.clipsToBounds = true
        headerView.backgroundColor = .secondarySystemFill
        
        headerView.addSubview(headerAsteroidDiameter, headerAsteroidEstimation, headerAsteroidView)
        
        headerAsteroidView.layer.addSublayer(headerDangerousGradientLayer)
        headerAsteroidView.addSubview(headerDinoImage, headerAsteroidImage, headerAsteroidName)
        
        headerAsteroidName.constraints(top: nil, bottom: headerAsteroidView.bottomAnchor, leading: headerAsteroidView.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 10, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        headerDinoImage.constraints(top: nil, bottom: headerAsteroidView.bottomAnchor, leading: headerAsteroidName.trailingAnchor, trailing: headerAsteroidView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 40, height: 40)
        
        headerAsteroidView.constraints(top: headerView.topAnchor, bottom: nil, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 155)
        
        headerAsteroidDiameter.constraints(top: headerAsteroidView.bottomAnchor, bottom: nil, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        
        headerAsteroidEstimation.constraints(top: headerAsteroidDiameter.bottomAnchor, bottom: headerView.bottomAnchor, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, paddingTop: 15, paddingBottom: 15, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
    }
    
    private func loadDataForHeader(){
        
        headerDangerousGradientLayer.colors = [model.asteroidDangerousColor.startColor, model.asteroidDangerousColor.endColor]
        
        let newOrigin = CGPoint(x: 5, y: 5)
        headerAsteroidImage.frame = CGRect(origin: newOrigin, size: CGSize(width: model.asteroidSize.width, height: model.asteroidSize.height))
        //self.setNeedsLayout()
        //self.layoutIfNeeded()
        
        headerAsteroidName.text = model.asteroidName
        headerAsteroidDiameter.text = model.diameter
        headerAsteroidEstimation.text = model.isDangerous
    }
    
    @objc private func addToDestroying(_ sender: UIButton){
        
        let index = sender.tag
        
        let asteroidForDestroy = AsteroidViewModel(asteroidImage: model.asteroidImage, diameter: model.diameter, destinationTime: model.detailApproachViewModel[index].destinationTime, distance: model.detailApproachViewModel[index].distance, isDangerous: model.isDangerous, orbitingBody: model.detailApproachViewModel[index].orbitingBody, asteroidName: model.asteroidName, asteroidDangerousColor: model.asteroidDangerousColor, asteroidSize: model.asteroidSize, detailApproachViewModel: model.detailApproachViewModel)
        
        sender.showTapAnimation {
            
            self.dataWorker.addToDestroyingList(asteroidForDestroy: asteroidForDestroy) {}
        }
    }
    
    @objc private func closeView(){
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        model.detailApproachViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.id, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        
        cell.render(model: model.detailApproachViewModel[indexPath.item], indexPathElement: indexPath.item)
        
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate{
    
}
