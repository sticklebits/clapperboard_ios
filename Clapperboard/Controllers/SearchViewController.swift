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
    
    fileprivate var searches: (recent: [String], trending: [String]) = ([], ["star wars", "bond", "jurassic park"]) {
        didSet {
            if (oldValue.recent != searches.recent) {
                searches.recent = searches.recent.first(n: 3)
            }
            if (oldValue.trending != searches.trending) {
                searches.trending = searches.trending.first(n: 3)
            }
        }
    }
    
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    fileprivate var searchBar:
        (cell: SearchHeaderTableViewCell?, view: UIView?, minHeight: CGFloat, maxHeight: CGFloat) = (nil, nil, 0.0, 0.0)
    
    fileprivate var searchResults = SearchResultsViewController()
    
    fileprivate let omdbAPI = OMDbAPIConnector()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        omdbAPI.delegate = self
        searchResults.delegate = self
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
        if searches.recent.count > 0 {
            sections.append(.recentHeader)
            sections.append(.recent)
        }
        if searches.trending.count > 0 {
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
        case .recent: return searches.recent.count
        case .trending: return searches.trending.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .searchHeader: return searchHeaderCell(tableView: tableView)
        case .recentHeader: return headerCell(tableView: tableView, title: "Recent", buttonText: "Clear", buttonAction: #selector(clearRecentButtonWasTouched))
        case .trendingHeader: return headerCell(tableView: tableView, title: "Trending", buttonText: "", buttonAction: nil)
        case .recent:
            let underline = indexPath.row < searches.recent.count - 1
            return cell(tableView: tableView, title: searches.recent[indexPath.row], underline: underline)
        
        case .trending:
            let underline = indexPath.row < searches.trending.count - 1
            return cell(tableView: tableView, title: searches.trending[indexPath.row], underline: underline)
        }
    }
    
    func searchHeaderCell(tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchHeaderCellIdentifier) as? SearchHeaderTableViewCell {
            
            if searchBar.cell == nil {
                searchBar.minHeight = cell.frame.maxY - 32.0
                searchBar.maxHeight = cell.filterSegment.frame.maxY
            }
            searchBar.cell?.backgroundColor = UIColor.white
            searchBar.cell = cell
            searchBar.cell?.delegate = self
            searchBar.cell?.stateDelegate = self
            
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
                cell.underline(color: UIColor.init(white: 0.9, alpha: 1.0), height: 1.0, leftInset: 16.0)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let search: String
        
        switch sections[indexPath.section] {
            
        case .searchHeader, .recentHeader, .trendingHeader: return

        case .recent:
            search = searches.recent[indexPath.row]
            
        case .trending:
            search = searches.trending[indexPath.row]
        }
        
        addRecentSearch(search)
        searchBar.cell?.searchField.text = search
        searchBar.cell?.state = .searchInput
        searchResults.isLoading = true
        omdbAPI.searchForMovie(title: search, searchType: .multi)
    }
}

// MARK: - SearchHeaderDelegate

extension SearchViewController: SearchHeaderDelegate {
    
    func searchHeader(_ searchHeader: SearchHeaderTableViewCell, didRequestSearch: String?) {
        
        let search = searchHeader.searchField.text!
        if search == "" { return }
        
        searchHeader.searchField.resignFirstResponder()
        searchResults.isLoading = true
        omdbAPI.searchForMovie(title: search, searchType: .multi)
        addRecentSearch(search)
    }
    
    func searchHeader(_ searchHeader: SearchHeaderTableViewCell, didTouchButton button: UIButton) {
        
    }
    
    func searchHeaderShouldUpdateState(_ searchHeader: SearchHeaderTableViewCell) -> SearchHeaderTableViewCell.State {
        return .searchInput
    }
}

// MARK: - SearchHeaderStateDelegate

extension SearchViewController: SearchHeaderStateDelegate {
    
    func searchHeaderWillOpen(_ searchHeader: SearchHeaderTableViewCell) {
        
        tableView.bounces = false
        
        addChildViewController(searchResults)
        searchResults.view.alpha = 0.0
        view.addSubview(searchResults.view)
        searchResults.view.pin(insideView: view, insets: UIEdgeInsets.zero)
        
        view.addSubview(searchHeader)
        searchHeader.backgroundColor = nil
        let bottomOfTabBar = tabBarController != nil ? tabBarController!.tabBar.frame.height : 0.0
        searchResults.contentInset = UIEdgeInsets(top: searchHeader.height, left: 0.0, bottom: bottomOfTabBar, right: 0.0)
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.searchResults.view.alpha = 1.0
        })
    }
    
    func searchHeaderDidOpen(_ searchHeader: SearchHeaderTableViewCell) {
        
    }
    
    func searchHeaderWillClose(_ searchHeader: SearchHeaderTableViewCell) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
            self.searchResults.view.alpha = 0.0
            }) { (finished) in

                self.searchResults.clearMovies()
                self.searchResults.view.removeFromSuperview()
                
                self.tableView.reloadData()
                self.tableView.bounces = true
        }
    }
    
    func searchHeaderDidClose(_ searchHeader: SearchHeaderTableViewCell) {

    }
}

// MARK: - OMDbAPIConnectorDelegate

extension SearchViewController: OMDbAPIConnectorDelegate {
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didFindMovieList movieList: [Movie], forPage page: Int) {
        searchResults.set(movies: movieList, forPage: page)
        searchResults.isLoading = false
    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didFindMovie movie: Movie?) {
        
    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didReceiveError error: Error) {
        print("\(error.localizedDescription)")
    }
    
}


// MARK: - SearchResultsViewControllerDelegate

extension SearchViewController: SearchResultsViewControllerDelegate {
    
    func searchResultsViewController(viewController: SearchResultsViewController, didSelectMovie meta: (movie: Movie, image: UIImage?)) {
        
        let movieViewController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let movieView = UINib(nibName: "MovieCardView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MovieCardView
        
        movieView.movieImage.image = meta.image
        movieView.movieImage.contentMode = .scaleAspectFill
        movieView.movieTitleLabel.text = meta.movie.title
        movieView.movieYearLabel.text = meta.movie.year
        movieView.movieDescriptionLabel.text = meta.movie.description
        
        movieViewController.view.addSubview(movieView)
        movieView.pin(insideView: movieViewController.view, insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 120.0, right: 0.0))
    
        let trailer = UIAlertAction(title: "Watch Trailer", style: .default) { (alertAction) in
            print("Watch trailer for \(meta.movie.title)")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        movieViewController.addAction(cancel)
        movieViewController.addAction(trailer)
        
        present(movieViewController, animated: true, completion: nil)
    }
    
    func searchResultsViewControllerDidCancel(viewController: SearchResultsViewController) {
        searchBar.cell?.state = .closed
    }
    
    func searchResultsViewController(viewController: SearchResultsViewController, shouldFetchPage page: Int) {
        if omdbAPI.isWorking { return }
        omdbAPI.currentSearch(fetchPage: page)
    }
}


// MARK: - Actions

extension SearchViewController {
    
    func clearRecentButtonWasTouched() {
        if searches.recent.count == 0 { return }
        
        if let location = sections.index(of: .recentHeader) {
            tableView.beginUpdates()
            searches.recent = []
            let range = NSMakeRange(location, 2)
            let indexSet = NSIndexSet(indexesIn: range) as IndexSet
            tableView.deleteSections(indexSet, with: .bottom)
            tableView.endUpdates()
        }
    }
    
    func closeSearchBar(gesture: UITapGestureRecognizer) {
        searchBar.cell?.state = .closed
    }
}


// MARK: - Helpers

extension SearchViewController {
    
    func addRecentSearch(_ search: String) {
        if let existingIndex = searches.recent.index(of: search) {
            searches.recent.remove(at: existingIndex)
        }
        searches.recent.insert(search, at: 0)
    }
}
