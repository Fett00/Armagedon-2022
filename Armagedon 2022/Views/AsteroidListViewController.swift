//
//  AsteroidListViewController.swift
//  Armageddon2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit

class AsteroidListViewController: UIViewController {
    
    let dataWorker: DataWorkerForAsteroidListProtocol
    let data: DataWorkerCollectedData
    
    let asteroidsCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    init(dataWorker: DataWorkerForAsteroidListProtocol, data: DataWorkerCollectedData){
        
        self.dataWorker = dataWorker
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureSubview()
        //configureAsteroidsCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataWorker.requestAsteroidList{
            
            self.asteroidsCollectionView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        layoutAsteroidsCollectionView()
    }
    
    func configureView(){
        
        self.navigationItem.title = "Армагедон 2022"
        self.view.backgroundColor = .systemBackground
        
        let filterBarButtonItem = UIBarButtonItem(image: Images.filter, style: .plain, target: self, action: #selector(openFilters))
        
        self.navigationItem.rightBarButtonItem = filterBarButtonItem
    }
    
    func configureSubview(){
        
        view.addSubview(asteroidsCollectionView)
        
        asteroidsCollectionView.delegate = self
        asteroidsCollectionView.dataSource = self
        asteroidsCollectionView.register(AsteroidCollectionViewCell.self, forCellWithReuseIdentifier: AsteroidCollectionViewCell.id)
        
        let safeArea = view.safeAreaLayoutGuide
        asteroidsCollectionView.constraints(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func layoutAsteroidsCollectionView(){
        
        guard let flowLayout = asteroidsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellAtRow: CGFloat = 1.0
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let spacing = 20.0
        let deviceWidth = view.frame.width
        let itemSize = (deviceWidth - insets.left - insets.right)
        
//        switch itemSize - spacing{
//
//        case ..<390:
//            cellAtRow = 1
//        case 390..<390*2:
//            cellAtRow = 2
//        case 390*2..<390*3:
//            cellAtRow = 3
//        default:
//            cellAtRow = 1
//        }
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = insets
        flowLayout.itemSize = CGSize(width: itemSize / cellAtRow, height: (itemSize * 0.9) / cellAtRow)
        
        //asteroidsCollectionView.systemLayoutSizeFitting(CGSize(width: itemSize, height: itemSize))
    }
    
    @objc func openFilters(){
        
        let viewToPush = ProjectCoordinator.shared.createFiltersViewController()
        
        self.navigationController?.pushViewController(viewToPush, animated: true)
    }
}

extension AsteroidListViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        data.asteroidsViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AsteroidCollectionViewCell.id, for: indexPath) as? AsteroidCollectionViewCell else { return UICollectionViewCell() }
        
        cell.render(model: data.asteroidsViewModel[indexPath.item])
        
        return cell
    }
    
    
}

extension AsteroidListViewController: UICollectionViewDelegate{
    
}
