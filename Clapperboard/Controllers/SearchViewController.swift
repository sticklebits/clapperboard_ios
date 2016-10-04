//
//  SearchViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 05/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    enum TableViewSections: String {
        case header
        case searchInput
        
        static func allSections() -> [TableViewSections] {
            return [.header, .searchInput]
        }
    }
    
    let SearchHeaderIdentifier = "SearchHeaderIdentifier"
    let SearchInputIdentifier = "SearchInputIdentifier"
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: SearchInputIdentifier)
        tableView.register(UINib(nibName: "LargeHeadingTableViewCell", bundle: nil), forCellReuseIdentifier: SearchHeaderIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0))
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSections.allSections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = TableViewSections.allSections()[section]
        
        switch (section) {
        case .header: return 1
        case .searchInput: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = TableViewSections.allSections()[indexPath.section]
        
        switch (section) {
        case .header:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchHeaderIdentifier) as? LargeHeadingTableViewCell {
                cell.largeHeaderLabel.text = "Search"
                return cell
            }
        case .searchInput:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchInputIdentifier) {
                cell.textLabel?.text = "..."
                return cell
            }
        }
        return UITableViewCell()
    }
}


extension SearchViewController : UITableViewDelegate {
    
}
