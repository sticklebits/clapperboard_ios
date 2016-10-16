//
//  LoadingView.swift
//  Clapperboard
//
//  Created by Steve Johnson on 16/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                isHidden = false
                activityView?.startAnimating()
            } else {
                isHidden = true
                activityView?.stopAnimating()
            }
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
}
