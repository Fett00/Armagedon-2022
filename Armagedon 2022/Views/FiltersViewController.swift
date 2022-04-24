//
//  FiltersViewController.swift
//  Armageddon2022
//
//  Created by Садык Мусаев on 14.04.2022.
//

import UIKit
//""" Ед. изм. расстояний км л. орб. Показывать только опасные """
class FiltersViewController: UIViewController {
    
    let dataWorker: DataWorkerForFiltersProtocol!
    
    let tableView: UITableView
    
    init(dataWorker: DataWorkerForFiltersProtocol, style: UITableView.Style = .insetGrouped){
        
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
        self.dataWorker = dataWorker
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubview()
    }
    
    func configureView(){
        
        self.navigationItem.title = "Фильтр"
        self.view.backgroundColor = .systemBackground
        
        let acceptBarButtonItem = UIBarButtonItem(title: "Применить", style: .plain, target: self, action: #selector(acceptFilter))
        
        self.navigationItem.rightBarButtonItem = acceptBarButtonItem
    }
    
    func configureSubview(){
        
        view.addSubview(tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isScrollEnabled = false
        
        tableView.register(FilterCellWithSegment.self, forCellReuseIdentifier: FilterCellWithSegment.id)
        tableView.register(FilterCellWithSwitcher.self, forCellReuseIdentifier: FilterCellWithSwitcher.id)
        
        let safe = self.view.safeAreaLayoutGuide
        tableView.constraints(top: safe.topAnchor, bottom: safe.bottomAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func updateFilters(_ sender: UIView){
        
        let viewType = dataWorker.filtersViewModel[sender.tag].secondaryView
        
        switch viewType {
        case .switcher:
            
            guard let switcher = sender as? UISwitch else { return }
            
            dataWorker.updateFilters(newFilter: .init(destinationType: dataWorker.filter.destinationType, showDangerousOnly: switcher.isOn))
            
        case .segmenter(_, _):
            
            guard let segmenter = sender as? UISegmentedControl else { return }
            
            let index = segmenter.selectedSegmentIndex
            
            if index == 0{
                
                dataWorker.updateFilters(newFilter: .init(destinationType: .km, showDangerousOnly: dataWorker.filter.showDangerousOnly))
            }
            else if index == 1{
                
                dataWorker.updateFilters(newFilter: .init(destinationType: .lunar, showDangerousOnly: dataWorker.filter.showDangerousOnly))
            }
        }
    }
    
    @objc func acceptFilter(){
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataWorker.filtersViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch dataWorker.filtersViewModel[indexPath.row].secondaryView{
        case .switcher:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCellWithSwitcher.id, for: indexPath) as? FilterCellWithSwitcher else { return UITableViewCell() }
            
            cell.render(with: dataWorker.filtersViewModel[indexPath.row], indexPathRow: indexPath.row, state: dataWorker.filter.showDangerousOnly)
            return cell
            
        case .segmenter(_, _):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCellWithSegment.id, for: indexPath) as? FilterCellWithSegment else { return UITableViewCell() }
            
            cell.render(with: dataWorker.filtersViewModel[indexPath.row], indexPathRow: indexPath.row, state: dataWorker.filter.destinationType)
            return cell
        }
    }
}

extension FiltersViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}

