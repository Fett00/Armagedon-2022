//
//  AsteroidListViewController.swift
//  Armageddon2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit

final class AsteroidListViewController: UIViewController {
    
    private let dataWorker: DataWorkerForAsteroidListProtocol
    private let data: DataWorkerCollectedDataForAsteroidList
    
    //Таблица с астероидами
    private let asteroidsCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    //индикатор загрузки
    private let loadingView: LoadingBlurView = {
       
        let loadingView = LoadingBlurView(frame: .zero, blurStyle: .dark, activityStyle: .medium)
        
        return loadingView
    }()
    
    init(dataWorker: DataWorkerForAsteroidListProtocol, data: DataWorkerCollectedDataForAsteroidList){
        
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
        configureLoadingView()
        //configureAsteroidsCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingView.enableActivityWithAnimation {
            
            self.dataWorker.requestAsteroidList{
                
                self.asteroidsCollectionView.reloadData()
                self.loadingView.disableActivityWithAnimation {}
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        layoutAsteroidsCollectionView()
        
        loadingView.frame = self.view.frame
    }
    
    private func configureLoadingView(){
        
        view.addSubview(loadingView)
        loadingView.frame = self.view.frame
    }
    
    private func configureView(){
        
        self.navigationItem.title = "Армагедон 2022"
        self.view.backgroundColor = .systemBackground
        
        let filterBarButtonItem = UIBarButtonItem(image: Images.filter, style: .plain, target: self, action: #selector(openFilters))
        
        self.navigationItem.rightBarButtonItem = filterBarButtonItem
    }
    
    private func configureSubview(){
        
        view.addSubview(asteroidsCollectionView)
        
        asteroidsCollectionView.delegate = self
        asteroidsCollectionView.dataSource = self
        asteroidsCollectionView.register(AsteroidCollectionViewCell.self, forCellWithReuseIdentifier: AsteroidCollectionViewCell.id)
        
        let safeArea = view.safeAreaLayoutGuide
        asteroidsCollectionView.constraints(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func layoutAsteroidsCollectionView(){
        
        guard let flowLayout = asteroidsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        var cellAtRow: CGFloat = 1.0
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let spacing = 10.0
        let collectionWidth = asteroidsCollectionView.frame.width
        
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
        
        let itemSize = (collectionWidth - insets.left - insets.right - spacing * cellAtRow)
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing * 2
        //flowLayout.sectionInset = insets
        asteroidsCollectionView.contentInset = insets
        flowLayout.itemSize = CGSize(width: itemSize / cellAtRow, height: (itemSize * 0.9) / cellAtRow)
        
        //asteroidsCollectionView.systemLayoutSizeFitting(CGSize(width: itemSize, height: itemSize))
    }
    
    @objc private func openFilters(){
        
        let viewToPush = ProjectCoordinator.shared.createFiltersViewController()
        
        self.navigationController?.pushViewController(viewToPush, animated: true)
        
        let topRow = IndexPath(row: 0, section: 0)
        
        self.asteroidsCollectionView.scrollToItem(at: topRow, at: .centeredVertically, animated: false)
    }
    
    @objc private func addToDestroying(_ sender: UIButton){
        
        sender.showTapAnimation {
            
            self.dataWorker.addToDestroyingList(index: sender.tag) {}
        }
    }
}

extension AsteroidListViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        data.asteroidsViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AsteroidCollectionViewCell.id, for: indexPath) as? AsteroidCollectionViewCell else { return UICollectionViewCell() }
        
        cell.render(model: data.asteroidsViewModel[indexPath.item], indexPathElement: indexPath.item)
        
        return cell
    }
}

extension AsteroidListViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == data.asteroidsViewModel.count - 2{
            
            dataWorker.requestNextAsteroidList {
                
                self.dataWorker.requestAsteroidList {
                    
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailViewController = UINavigationController(rootViewController: ProjectCoordinator.shared.createDetailViewController(model: self.data.asteroidsViewModel[indexPath.item]))
        
        self.present(detailViewController, animated: true, completion: nil)
    }
}
