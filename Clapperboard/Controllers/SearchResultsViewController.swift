//
//  SearchResultsViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 03/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    fileprivate(set) var movies: [IndexPath:Movie] = [:]
    
    var delegate: SearchResultsViewControllerDelegate?
    
    var isLoading: Bool = false {
        didSet {
            loadingView?.isLoading = isLoading
        }
    }
    
    var contentInset: UIEdgeInsets? {
        didSet {
            collectionView?.contentInset = contentInset!
        }
    }
    
    let imageStore = IndexedImageStore(blankImage: UIImage(named: "no_movie_image"), diskPathToCache: "movie_poster_image_store")
    
    var pages: Int {
        return sections.count - 1
    }
    
    private let collectionView: UICollectionView!
    
    fileprivate var loadingView: LoadingView?
    fileprivate var touchToCancelView = UIView()
    
    required init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180.0, height: 320.0)
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180.0, height: 320.0)
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Results"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonWasTouched(sender:)))
        setupTouchToCancelView()
        setupCollectionView()
    }

    override func viewWillLayoutSubviews() {
        collectionView.frame = view.frame
    }
    
    func setupTouchToCancelView() {
        touchToCancelView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        view.addSubview(touchToCancelView)
        touchToCancelView.pin(insideView: view, insets: UIEdgeInsets.zero)
        touchToCancelView.isUserInteractionEnabled = true
        let closeSearchGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTouched(gesture:)))
        touchToCancelView.addGestureRecognizer(closeSearchGesture)
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        loadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? LoadingView
        collectionView.backgroundView = loadingView
        loadingView?.isLoading = isLoading
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.classForCoder()))
        view.addSubview(collectionView)
        collectionView.pin(insideView: view, insets: UIEdgeInsets.zero)
        
        updateCollectionView(page: nil)
    }
    
    func updateCollectionView(page: Int?) {
        refreshImageStore(page: page)
        collectionView.isUserInteractionEnabled = movies.count > 0
        collectionView.backgroundColor = collectionViewBackgroundColor()
        collectionView.reloadData()
    }
    
    func collectionViewBackgroundColor() -> UIColor? {
        return movies.count == 0 ? nil : UIColor.white
    }
    
    func refreshImageStore(page: Int?) {
        var item = 0
        movies.forEach { (indexPath, movie) in
            
            if page != nil {
                if indexPath.section != page { return }
            }
            
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

// MARK: - Actions

extension SearchResultsViewController {
    
    func viewWasTouched(gesture: UIGestureRecognizer) {
        if movies.count == 0 {
            delegate?.searchResultsViewControllerDidCancel(viewController: self)
        }
    }
    
    func cancelButtonWasTouched(sender: AnyObject) {
        delegate?.searchResultsViewControllerDidCancel(viewController: self)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultsViewController: UICollectionViewDataSource {
    
    func set(movies: [Movie], forPage page: Int) {
        clearMoviesInSection(section: page)

        for item in 0..<movies.count {
            let indexPath = IndexPath(item: item, section: page)
            self.movies[indexPath] = movies[item]
        }
        updateCollectionView(page: page)
    }
    
    func clearMovies() {
        movies = [:]
    }
    
    func clearMoviesInSection(section: Int) {
        for (indexPath, _) in movies {
            if indexPath.section == section {
                movies.removeValue(forKey: indexPath)
            }
        }
    }
    
    var sections: [Int:Int] {
        var sections = [0:0]
        for (indexPath, _) in movies {
            if let items = sections[indexPath.section] {
                sections[indexPath.section] = items + 1
            } else {
                sections[indexPath.section] = 1
            }
        }
        return sections
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section] != nil ? sections[section]! : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.classForCoder()), for: indexPath) as! MovieCollectionViewCell
        if let movie = movies[indexPath] {
            let movieYear = movie.year != "" ? " (\(movie.year))" : ""
            cell.movieTitleLabel.text = "\(movie.title)\(movieYear)"
            cell.moviePosterImageView.image = imageStore.image(atIndexPath: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = movies[indexPath] {
            delegate?.searchResultsViewController(viewController: self, didSelectMovie: movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isLoading { return }
        let sections = self.sections
        if indexPath.section == (sections.count - 1) && indexPath.item > (sections[indexPath.section]! - 2) {
            delegate?.searchResultsViewController(viewController: self, shouldFetchPage: pages + 1)
        }
    }
}

// MARK: - SearchResultsViewControllerDelegate protocol

protocol SearchResultsViewControllerDelegate {
    func searchResultsViewController(viewController: SearchResultsViewController, shouldFetchPage page: Int)
    func searchResultsViewController(viewController: SearchResultsViewController, didSelectMovie movie: Movie)
    func searchResultsViewControllerDidCancel(viewController: SearchResultsViewController)
}
