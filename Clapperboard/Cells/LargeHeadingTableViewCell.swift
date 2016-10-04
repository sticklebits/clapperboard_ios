//
//  LargeHeadingTableViewCell.swift
//  Clapperboard
//
//  Created by Steve Johnson on 04/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class LargeHeadingTableViewCell: UITableViewCell {

    @IBOutlet weak var largeHeaderLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
