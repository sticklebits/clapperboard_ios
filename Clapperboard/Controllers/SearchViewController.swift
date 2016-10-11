//
//  SearchViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 11/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Cell Identifiers
    
    let SearchHeaderCellIdentifier = "SearchHeaderCellIdentifier"
    let HeaderCellIdentifier = "HeaderCellIdentifier"
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Enums
    
    enum Sections: Int {
        case searchHeader
        case recentHeader
        case recent
        case trendingHeader
        case trending
    }
    
    // MARK: - Private Properties
    
    fileprivate var recentSearches: [String] = []
    fileprivate var trendingSearches: [String] = ["star wars", "bond", "jurassic park"]
    
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    fileprivate var searchHeaderCell: SearchHeaderTableViewCell?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.pin(insideView: view, insets: UIEdgeInsets.zero)
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        registerCells(tableView: tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func registerCells(tableView: UITableView) {
        tableView.register(UINib(nibName: "SearchHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: SearchHeaderCellIdentifier)
        tableView.register(UINib(nibName: "LargeHeadingTableViewCell", bundle: nil), forCellReuseIdentifier: HeaderCellIdentifier)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
    }
    
    var sections: [Sections] {
        var sections: [Sections] = [.searchHeader]
        if recentSearches.count > 0 {
            sections.append(.recentHeader)
            sections.append(.recent)
        }
        if trendingSearches.count > 0 {
            sections.append(.trendingHeader)
            sections.append(.trending)
        }
        return sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .searchHeader: return 1
        case .recentHeader: return 1
        case .trendingHeader: return 1
        case .recent: return recentSearches.count
        case .trending: return trendingSearches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .searchHeader: return searchHeaderCell(tableView: tableView)
        case .recentHeader: return headerCell(tableView: tableView, title: "Recent", buttonText: "Clear", buttonAction: #selector(clearRecentButtonWasTouched))
        case .trendingHeader: return headerCell(tableView: tableView, title: "Trending", buttonText: "", buttonAction: nil)
        case .recent:
            let underline = indexPath.row < recentSearches.count - 1
            return cell(tableView: tableView, title: recentSearches[indexPath.row], underline: underline)
        
        case .trending:
            let underline = indexPath.row < trendingSearches.count - 1
            return cell(tableView: tableView, title: trendingSearches[indexPath.row], underline: underline)
        }
    }
    
    func searchHeaderCell(tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchHeaderCellIdentifier) as? SearchHeaderTableViewCell {
            searchHeaderCell = cell
            return cell
        }
        return UITableViewCell()
    }
    
    func headerCell(tableView: UITableView, title: String, buttonText: String, buttonAction: Selector?) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCellIdentifier) as? LargeHeadingTableViewCell {
            cell.largeHeaderLabel.text = title
            cell.largeHeaderLabel.font = UIFont.systemFont(ofSize: 22.0, weight: 0.5)
            cell.actionButton.setTitle(buttonText, for: .normal)
            if buttonAction != nil {
                cell.actionButton.addTarget(self, action: buttonAction!, for: .touchUpInside)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func cell(tableView: UITableView, title: String, underline: Bool) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) {
            cell.textLabel?.text = title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: 0.1)
            cell.textLabel?.textColor = view.tintColor
            if underline {
                cell.underline(color: UIColor.init(white: 0.9, alpha: 1.0), height: 1.0, leftInset: 8.0)
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
}

// MARK: - Actions

extension SearchViewController {
    
    func clearRecentButtonWasTouched() {
        
    }
}
