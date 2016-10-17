//
//  MovieCardViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 17/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class MovieCardViewController: UIViewController {

    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviePosterImageView.layer.cornerRadius = 8.0
        moviePosterImageView.contentMode = .scaleAspectFill
        moviePosterImageView.clipsToBounds = true
        
        buttonContainer.layer.cornerRadius = 8.0
        contentContainer.layer.cornerRadius = 8.0
        contentContainer.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        if movie == nil { return }
        movieTitleLabel.text = movie?.title
        yearLabel.text = movie?.year
    }
    
    @IBAction func closeButtonWasTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
