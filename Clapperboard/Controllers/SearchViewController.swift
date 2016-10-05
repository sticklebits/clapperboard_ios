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
        
        static func allSections() -> [CollectionViewSections] {
            return [.searchHeader, .searchResults]
        }
    }
    
    let SearchHeaderIdentifier = "SearchHeaderIdentifier"
    let SearchResultsIdentifier = "SearchResultsIdentifier"
    
    var collectionView: UICollectionView!
    var searchResults: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.register(SearchHeaderCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: SearchHeaderIdentifier)
        collectionView.register(MovieCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: SearchResultsIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0))
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewSection = CollectionViewSections.allSections()[indexPath.section]
    
        switch (collectionViewSection) {
        case .searchHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHeaderIdentifier, for: indexPath)
                return cell
            
        case .searchResults:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsIdentifier, for: indexPath)
                return cell
        }
    }
}

extension SearchViewController {
    
}
