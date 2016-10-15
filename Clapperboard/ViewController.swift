//
//  ViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 02/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleInputField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    let omdbAPI = OMDbAPIConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        omdbAPI.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonWasTouched(_ sender: UIButton) {
        omdbAPI.searchForMovie(title: titleInputField.text!, searchType: .multi)
    }
}


extension ViewController: OMDbAPIConnectorDelegate {
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didFindMovieList movieList: [Movie]) {
        let searchResultsViewController = SearchResultsViewController()
        searchResultsViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: searchResultsViewController)
        searchResultsViewController.movies = movieList
        navigationController.modalPresentationStyle = .formSheet
        show(navigationController, sender: self)
    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didFindMovie movie: Movie?) {
        
        if (movie == nil) {
            let alertController = UIAlertController(title: "Not found", message: "Could not find the movie you were looking for...", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (alertAction) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        print("\(movie!.title)")
        
        let posterURL = URL(string: movie!.poster)!
        
        guard let posterData = try? Data(contentsOf: posterURL) else {
            print("Couldn't load poster...")
            return
        }
        
        DispatchQueue.main.async {
            self.posterImageView.image = UIImage(data: posterData)
        }
    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didReceiveError error: Error) {
        print("\(error.localizedDescription)")
    }
}

extension ViewController: SearchResultsViewControllerDelegate {
    
    func searchResultsViewControllerDidCancel(viewController: SearchResultsViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func searchResultsViewController(viewController: SearchResultsViewController, didSelectMovie movie: Movie) {
        omdbAPI.searchForMovie(imdbID: movie.imdbID)
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
