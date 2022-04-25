//
//  CartViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.01.2022.
//

import UIKit

final class DestroyListViewController: UIViewController {
    
    private let dataWorker: DataWorkerForDestroyListProtocol //Запрос данных
    private let data: DataWorkerCollectedDataForDestroyList //Данные для заполнения
     
    //Таблица с астероидами
    private let destroyingTableView: UITableView = {
       
        let tableView = UITableView()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    //Вью с кнопкой вызова
    private let secondaryView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = .secondarySystemBackground
        
        return view
    }()
    
    // Кнопка вызова
    private let callBruceButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Call Bruce Team", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        button.backgroundColor = Colors.buttonColor
        button.layer.borderWidth = 0.5
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(callBruce), for: .touchUpInside)
        
        return button
    }()
    
    //индикатор загрузки
    private let loadingView: LoadingBlurView = {
       
        let loadingView = LoadingBlurView(frame: .zero, blurStyle: .dark, activityStyle: .medium)
        
        return loadingView
    }()
    
    init(dataWorker: DataWorkerForDestroyListProtocol, data: DataWorkerCollectedDataForDestroyList){
        
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
        configureDestroyViewController()
        configureDesrtroyTableView()
        configureSecondaryView()
        configureLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadAsteroids()
    }
    
    override func viewWillLayoutSubviews() {
        
        loadingView.frame = self.view.frame
    }
    
    private func configureView(){
        
        self.navigationItem.title = "Список уничтожения"
        self.view.backgroundColor = .systemBackground
        
        let filterBarButtonItem = UIBarButtonItem(image: Images.trashCan, style: .plain, target: self, action: #selector(clearDestroyingList))
        
        self.navigationItem.rightBarButtonItem = filterBarButtonItem
    }
    
    private func configureDestroyViewController(){
        
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Cart"
    }
    
    private func configureLoadingView(){
        
        view.addSubview(loadingView)
        loadingView.frame = self.view.frame
    }
    
    //Конфигурация таблицы с выбранными блюдами
    private func configureDesrtroyTableView(){
        
        view.addSubview(destroyingTableView)
        
        destroyingTableView.dataSource = self
        //destroingTableView.delegate = self
        destroyingTableView.register(DestroyingTableViewCell.self, forCellReuseIdentifier: DestroyingTableViewCell.id)
        
        destroyingTableView.constraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //Конфигурация нижнего поля с итоговой суммой заказа
    private func configureSecondaryView(){
        
        view.addSubview(secondaryView)
        secondaryView.addSubview(callBruceButton)
        
        secondaryView.constraints(top: destroyingTableView.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        callBruceButton.constraints(top: secondaryView.topAnchor, bottom: secondaryView.bottomAnchor, leading: secondaryView.centerXAnchor, trailing: secondaryView.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: -40, paddingRight: 30, width: 0, height: 60)
    }
    
    //Загрузка астероидов
    private func loadAsteroids(){
        
        self.dataWorker.requestDestroingList {
            
            self.destroyingTableView.reloadData()
            self.checkCartFilling()
        }
    }
    
    //Вызов команды зачистки
    @objc private func callBruce(_ sender: UIButton){
        
        let popup = UIAlertController(title: "Вызов бригады", message: "Бригады им. Брюса Уиллиса в пути 💪😎", preferredStyle: .alert)
        popup.addAction(.init(title: "Ура!", style: .default, handler: nil))
        
        self.present(popup, animated: true) {
            
            self.dataWorker.clearDestroyingList {
                
                self.destroyingTableView.reloadData()
            }
        }
    }
    
    @objc private func clearDestroyingList(_ sender: UIButton){
        
        dataWorker.clearDestroyingList {
            
            self.destroyingTableView.reloadData()
        }
    }
    
    //Проверка наполнения корзины и измененния активности кнопки покупки
    private func checkCartFilling(){
        
        if self.data.asteroidsForDestroyViewModel.isEmpty{
            
            callBruceButton.isEnabled = false
            callBruceButton.setTitleColor(.lightGray, for: .normal)
            callBruceButton.backgroundColor = .darkGray
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else{
            
            callBruceButton.isEnabled = true
            callBruceButton.setTitleColor(.white, for: .normal)
            callBruceButton.backgroundColor = Colors.buttonColor
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

extension DestroyListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        data.asteroidsForDestroyViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DestroyingTableViewCell.id, for: indexPath) as? DestroyingTableViewCell else { return UITableViewCell() }
        
        cell.setUpCell(asteroid: data.asteroidsForDestroyViewModel[indexPath.row])
        
        return cell
    }
}


