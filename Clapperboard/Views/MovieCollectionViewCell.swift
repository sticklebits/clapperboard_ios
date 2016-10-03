//
//  MovieCollectionViewCell.swift
//  Clapperboard
//
//  Created by Steve Johnson on 03/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!

    override func awakeFromNib() {
        self.moviePosterImageView.layer.cornerRadius = 6.0
    }
}
