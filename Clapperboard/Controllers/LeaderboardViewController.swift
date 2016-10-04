//
//  LeaderboardViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 04/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {

    enum TableViewSections: String {
        case header
        case movie
        
        static func allSections() -> [TableViewSections] {
            return [.header, .movie]
        }
    }
    
    let TopTenHeaderCellIdentifier = "TopTenHeaderCellIdentifier"
    let TopTenCellIdentifier = "TopTenCellIdentifier"
    
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
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: TopTenCellIdentifier)
        tableView.register(UINib(nibName: "LargeHeadingTableViewCell", bundle: nil), forCellReuseIdentifier: TopTenHeaderCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0))
    }
}


// MARK: - UITableViewDataSource

extension LeaderboardViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSections.allSections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = TableViewSections.allSections()[section]
        
        switch (section) {
        case .header: return 1
        case .movie: return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = TableViewSections.allSections()[indexPath.section]
        
        switch (section) {
        case .header:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TopTenHeaderCellIdentifier) as? LargeHeadingTableViewCell {
                cell.largeHeaderLabel.text = "Top Ten"
                return cell
            }
        case .movie:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TopTenCellIdentifier) {
                cell.textLabel?.text = "Film"
                return cell
            }
        }
        return UITableViewCell()
    }
}


extension LeaderboardViewController : UITableViewDelegate {
    
}
