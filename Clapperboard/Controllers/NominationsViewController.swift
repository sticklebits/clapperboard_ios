//
//  NominationsViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 04/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class NominationsViewController: UIViewController {

    enum TableViewSections: String {
        case today = "Today"
        case todayMovieList
        case recent = "Recent"
        case recentMovieList
        
        static func allSections() -> [TableViewSections] {
            return [.today, .todayMovieList, .recent, .recentMovieList]
        }
    }
    
    let NominationsHeaderIdentifier = "NominationsHeaderIdentifier"
    let MovieCellIdentifier = "MovieCellIdentifier"
    
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
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: MovieCellIdentifier)
        tableView.register(UINib(nibName: "LargeHeadingTableViewCell", bundle: nil), forCellReuseIdentifier: NominationsHeaderIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0))
    }
}


// MARK: - UITableViewDataSource

extension NominationsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSections.allSections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = TableViewSections.allSections()[section]
        
        switch (section) {
        case .today: return 1
        case .todayMovieList: return 2
        case .recent: return 1
        case .recentMovieList: return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = TableViewSections.allSections()[indexPath.section]
        
        switch (section) {
        case .today:
            fallthrough
        case .recent:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NominationsHeaderIdentifier) as? LargeHeadingTableViewCell {
                cell.largeHeaderLabel.text = section.rawValue
                return cell
            }
        case .todayMovieList:
            fallthrough
        case .recentMovieList:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCellIdentifier) {
                cell.textLabel?.text = "Movie"
                return cell
            }
        }
        return UITableViewCell()
    }
}


extension NominationsViewController : UITableViewDelegate {
    
}
