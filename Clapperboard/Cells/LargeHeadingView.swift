//
//  LargeHeadingView.swift
//  Clapperboard
//
//  Created by Steve Johnson on 10/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class LargeHeadingView: UIView {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    
    var onTouched: ((_ button: UIButton) -> (Void))?
    
    @IBAction func actionButtonWasTouched(_ sender: UIButton) {
        onTouched?(sender)
    }
}
