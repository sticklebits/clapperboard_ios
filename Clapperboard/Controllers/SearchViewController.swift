//
//  SearchViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 05/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    enum CollectionViewSections: String {
        case searchHeader
        case searchResults
        case recentHeader
        case recent
        case trendingHeader
        case trending
    }
    
    var sections: [CollectionViewSections] {
        var sections: [CollectionViewSections] = []

        sections.append(.searchHeader)
        if searchResults.count > 0 {
            sections.append(.searchResults)
        } else if !omdbAPI.isWorking {
            if recentSearches.count > 0 {
                sections.append(.recentHeader)
                sections.append(.recent)
            }
            if trendingSearches.count > 0 {
                sections.append(.trendingHeader)
                sections.append(.trending)
            }
        }

        return sections
    }
    
    let omdbAPI = OMDbAPIConnector()
    
    let SearchHeaderIdentifier = "SearchHeaderIdentifier"
    let SearchResultsIdentifier = "SearchResultsIdentifier"
    let LargeHeaderIdentifier = "LargeHeaderIdentifier"
    let LabelRowIdentifier = "LabelRowIdentifier"
    
    var collectionView: UICollectionView!
    var recentSearches: [String] = [] {
        didSet {
            recentSearches = recentSearches.filter { (search) in
                return recentSearches.index(of: search)! < 3
            }
            refreshCollectionView()
        }
    }
    var trendingSearches: [String] = ["star wars", "bond", "jurassic park"]
    var searchResults: [Movie] = [] {
        didSet {
            refreshImageStore()
            refreshCollectionView()
        }
    }
    
    var headerTopConstraint: NSLayoutConstraint!
    
    let imageStore = IndexedImageStore(blankImage: UIImage(named: "no_movie_image"), diskPathToCache: "movie_poster_image_store")
    
    var searchHeaderCell: SearchHeaderCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        omdbAPI.delegate = self
        setupCollectionView()
    }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:"SearchHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SearchHeaderIdentifier)
        collectionView.register(UINib(nibName:"MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SearchResultsIdentifier)
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: LargeHeaderIdentifier)
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: LabelRowIdentifier)
        view.addSubview(collectionView)
        collectionView.pin(insideView: view, insets: UIEdgeInsets.zero)
    }
    
    func refreshImageStore() {
        if !sections.contains(.searchResults) { return }
        let section = sections.index(of: .searchResults)!
        var item = 0
        searchResults.forEach { (movie) in
            let indexPath = IndexPath(item: item, section: section)
            imageStore.clearImage(indexPath: indexPath)
            imageStore.loadImage(urlString: movie.poster, forIndexPath: indexPath) { (image, indexPath) in
                if let cell = self.collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
                    cell.moviePosterImageView.image = image
                }
            }
            item += 1
        }
    }
    
    func refreshCollectionView() {
        collectionView.reloadData()
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController : UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let collectionViewSection = sections[section]
        
        switch (collectionViewSection) {
        case .searchHeader: return 1
        case .searchResults: return searchResults.count
        case .recentHeader: return 1
        case .recent: return recentSearches.count
        case .trendingHeader: return 1
        case .trending: return trendingSearches.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewSection = sections[indexPath.section]
    
        switch (collectionViewSection) {
        case .searchHeader:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHeaderIdentifier, for: indexPath) as? SearchHeaderCollectionViewCell {
                cell.frame = CGRect(origin: cell.frame.origin, size: CGSize(width: collectionView.bounds.width, height: 160.0))
                searchHeaderCell = cell
                searchHeaderCell?.searchTextField.delegate = self
                searchHeaderCell?.delegate = self
                return cell
            }
            
        case .searchResults:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsIdentifier, for: indexPath) as? MovieCollectionViewCell {
                let movie = searchResults[indexPath.row]
                let movieYear = movie.year != "" ? " (\(movie.year))" : ""
                cell.movieTitleLabel.text = "\(movie.title)\(movieYear)"
                cell.moviePosterImageView.image = imageStore.image(atIndexPath: indexPath)
                cell.alpha = searchHeaderCell?.state == .closed ? 0.0 : 1.0
                return cell
            }
            
        case .recentHeader:
            return headerCell(title: "Recent", buttonText: "Clear", buttonAction: #selector(clearRecentSearches), atIndexPath: indexPath)
            
        case .recent:
            return labelRowCell(labelText: recentSearches[indexPath.row], underlined: indexPath.row + 1 < recentSearches.count, atIndexPath: indexPath)
            
        case .trendingHeader:
            return headerCell(title: "Trending", buttonText: "", buttonAction: nil, atIndexPath: indexPath)
            
        case .trending:
            return labelRowCell(labelText: trendingSearches[indexPath.row], underlined: indexPath.row + 1 < trendingSearches.count, atIndexPath: indexPath)
        }
        return UICollectionViewCell()
    }
    
    func headerCell(title: String, buttonText: String, buttonAction: Selector?, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeHeaderIdentifier, for: indexPath)
        
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let headerView = UINib(nibName: "LargeHeadingView", bundle: nil).instantiate(withOwner: self, options: nil).first as! LargeHeadingView
        
        cell.addSubview(headerView)
        headerView.pin(insideView: cell, insets: UIEdgeInsets.zero)
        headerView.headingLabel.text = title
        UIView.withoutAnimation {
            headerView.actionButton.setTitle(buttonText, for: .normal)
        }
        if buttonAction != nil {
            headerView.actionButton.addTarget(self, action: buttonAction!, for: .touchUpInside)
        }
        return cell
    }
    
    func labelRowCell(labelText: String, underlined: Bool, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelRowIdentifier, for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        
        if underlined {
            cell.contentView.underline(color: UIColor.init(white: 0.9, alpha: 1.0), height: 1.0, leftInset: 8.0)
        }
        
        label.backgroundColor = UIColor.white
        label.textAlignment = .left
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = view.tintColor
        cell.contentView.addSubview(label)
        label.pin(insideView: cell, insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 0.0))
        return cell
    }
}


// MARK: - Actions

extension SearchViewController {
    
    func clearRecentSearches() {
        recentSearches = []
    }
}


// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let collectionViewSection = sections[indexPath.section]
    
        let search: String
        
        switch (collectionViewSection) {
        case .searchHeader:
            fallthrough
        case .searchResults:
            fallthrough
        case .recentHeader:
            fallthrough
        case .trendingHeader:
            return
            
        case .recent:
            search = recentSearches[indexPath.row]
            
        case .trending:
            search = trendingSearches[indexPath.row]
        }
        
        searchHeaderCell?.searchTextField.text = search
        omdbAPI.searchForMovie(title: search, searchType: .multi)
        refreshCollectionView()
        DispatchQueue.main.async {
            self.updateSearchBarState()
        }
    }
}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSection = sections[indexPath.section]
        
        switch (collectionViewSection) {
        case .searchHeader: return CGSize(width: collectionView.bounds.width, height: 160.0)
        case .searchResults: return CGSize(width: 180.0, height: 320.0)
            
        case .trendingHeader:
            fallthrough
        case .recentHeader: return CGSize(width: collectionView.bounds.width, height: 48.0)
            
        case .trending:
            fallthrough
        case .recent: return CGSize(width: collectionView.bounds.width, height: 36.0)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let collectionViewSection = sections[section]
        
        switch (collectionViewSection) {
        case .searchHeader: fallthrough
        case .recentHeader: fallthrough
        case .recent: fallthrough
        case .trendingHeader: fallthrough
        case .trending: return UIEdgeInsets.zero
        case .searchResults: return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        }
    }
}


// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSearchBarState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if searchHeaderCell?.state != .closed {
            updateSearchBarState()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        omdbAPI.searchForMovie(title: textField.text!, searchType: .multi)
        recentSearches.insert(textField.text!, at: 0)
        textField.resignFirstResponder()
        return true
    }
    
    func updateSearchBarState() {
        
        if (searchHeaderCell?.searchTextField?.isEditing)! {
            searchHeaderCell?.state = .searchInput
            return
        }
        
        if omdbAPI.isWorking || searchResults.count > 0 {
            searchHeaderCell?.state = .searchResults
            return
        }
        
        if searchHeaderCell?.state == .closed { return }
    }
}


// MARK: - SearchHeaderDelegate

extension SearchViewController: SearchHeaderDelegate {
    
    func searchHeader(_ searchHeader: SearchHeaderCollectionViewCell, didTouchButton button: UIButton) {
        searchHeaderCell?.state = .closed
    }
    
    func searchHeaderWillClose(_ searchHeader: SearchHeaderCollectionViewCell) {
        UIView.animate(withDuration: 0.25) {
            self.imageStore.indexPaths().forEach { (indexPath) in
                if let cell = self.collectionView.cellForItem(at: indexPath) {
                    cell.alpha = 0.0
                }
            }
        }
    }
    
    func searchHeaderDidClose(_ searchHeader: SearchHeaderCollectionViewCell) {
        self.searchResults = []
    }
}


// MARK: - OMDbAPIConnectorDelegate

extension SearchViewController: OMDbAPIConnectorDelegate {
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didFindMovieList movieList: [Movie]) {
        searchResults = movieList
    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didFindMovie movie: Movie?) {

    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didReceiveError error: Error) {
        print("\(error.localizedDescription)")
    }
    
}
