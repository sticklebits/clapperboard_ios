//
//  SearchResultsViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 03/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    var delegate: SearchResultsViewControllerDelegate?
    
    var movies: [Movie] = [] {
        didSet {
            refreshImageStore()
            collectionView.reloadData()
        }
    }
    
    let imageStore = IndexedImageStore(blankImage: UIImage(named: "no_movie_image"), diskPathToCache: "movie_poster_image_store")
    private let collectionView: UICollectionView!
    
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
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.classForCoder()))
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
    }
    
    func refreshImageStore() {
        var item = 0
        movies.forEach { (movie) in
            let indexPath = IndexPath(item: item, section: 0)
            imageStore.clearImage(indexPath: indexPath)
            imageStore.loadImage(urlString: movie.poster, forIndexPath: indexPath) { (image, indexPath) in
                if let cell = self.collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
                    cell.moviePosterImageView.image = image
                }
            }
            item += 1
        }
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.frame = view.frame
    }
    
    func cancelButtonWasTouched(sender: AnyObject) {
        delegate?.searchResultsViewControllerDidCancel(viewController: self)
    }
}


extension SearchResultsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? movies.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.classForCoder()), for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        let movieYear = movie.year != "" ? " (\(movie.year))" : ""
        cell.movieTitleLabel.text = "\(movie.title)\(movieYear)"
        cell.moviePosterImageView.image = imageStore.image(atIndexPath: indexPath)
        return cell
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 { return }
        delegate?.searchResultsViewController(viewController: self, didSelectMovie: movies[indexPath.row])
    }
    
}

protocol SearchResultsViewControllerDelegate {
    func searchResultsViewController(viewController: SearchResultsViewController, didSelectMovie movie: Movie)
    func searchResultsViewControllerDidCancel(viewController: SearchResultsViewController)
}
