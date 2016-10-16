//
//  MovieCardView.swift
//  Clapperboard
//
//  Created by Steve Johnson on 16/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class MovieCardView: UIView {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        movieImage.clipsToBounds = true
        movieImage.layer.cornerRadius = 8.0
    }
}
