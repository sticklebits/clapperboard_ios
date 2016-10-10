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
        case recentSearchesHeader
        case recentSearches
        
        static func allSections() -> [CollectionViewSections] {
            return [.searchHeader, .searchResults, .recentSearchesHeader, .recentSearches]
        }
    }
    
    let omdbAPI = OMDbAPIConnector()
    
    let SearchHeaderIdentifier = "SearchHeaderIdentifier"
    let SearchResultsIdentifier = "SearchResultsIdentifier"
    let RecentSearchesHeaderIdentifier = "RecentSearchesHeaderIdentifier"
    let RecentSearchIdentifier = "RecentSearchIdentifier"
    
    var collectionView: UICollectionView!
    var recentSearches: [String] = []
    var searchResults: [Movie] = [] {
        didSet {
            refreshImageStore()
            collectionView.reloadData()
        }
    }
    
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
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:"SearchHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SearchHeaderIdentifier)
        collectionView.register(UINib(nibName:"MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SearchResultsIdentifier)
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: RecentSearchesHeaderIdentifier)
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: RecentSearchIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0))
    }
    
    func refreshImageStore() {
        let section = CollectionViewSections.allSections().index(of: .searchResults)!
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
}


// MARK: - UITableViewDataSource

extension SearchViewController : UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CollectionViewSections.allSections().count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let collectionViewSection = CollectionViewSections.allSections()[section]
        
        switch (collectionViewSection) {
        case .searchHeader: return 1
        case .searchResults: return searchResults.count
        case .recentSearchesHeader: return 1
        case .recentSearches: return recentSearches.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewSection = CollectionViewSections.allSections()[indexPath.section]
    
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
            
        case .recentSearchesHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchesHeaderIdentifier, for: indexPath)
            cell.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            
            let headerView = UINib(nibName: "LargeHeadingView", bundle: nil).instantiate(withOwner: self, options: nil).first as! LargeHeadingView
            cell.addSubview(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraint(NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: cell, attribute: .leading, multiplier: 1.0, constant: 0.0))
            cell.addConstraint(NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: cell, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            cell.addConstraint(NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: 0.0))
            cell.addConstraint(NSLayoutConstraint(item: headerView, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            
            headerView.headingLabel.text = "Recent Searches"
            headerView.actionButton.setTitle("Clear", for: .normal)

            return cell
            
        case .recentSearches:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchIdentifier, for: indexPath)
            let label = UILabel()
            label.textAlignment = .left
            label.text = recentSearches[indexPath.row]
            cell.contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: cell, attribute: .leading, multiplier: 1.0, constant: 0.0))
            cell.addConstraint(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: cell, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            cell.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: 0.0))
            cell.addConstraint(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSection = CollectionViewSections.allSections()[indexPath.section]
        
        switch (collectionViewSection) {
        case .searchHeader: return CGSize(width: collectionView.bounds.width - 12.0, height: 160.0)
        case .searchResults: return CGSize(width: 180.0, height: 320.0)
        case .recentSearchesHeader: return CGSize(width: collectionView.bounds.width - 12.0, height: 48.0)
        case .recentSearches: return CGSize(width: collectionView.bounds.width - 12.0, height: 48.0)
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
        collectionView.reloadData()
    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didFindMovie movie: Movie?) {

    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didReceiveError error: Error) {
        print("\(error.localizedDescription)")
    }
    
}
