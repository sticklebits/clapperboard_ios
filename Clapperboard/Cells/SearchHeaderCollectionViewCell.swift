//
//  SearchHeaderCollectionViewCell.swift
//  Clapperboard
//
//  Created by Steve Johnson on 05/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var isSearchBarActive: Bool {
        return (searchTextField?.isEditing)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchTextField.returnKeyType = .search
        updateSearchBar()
    }

    func updateSearchBar() {
        self.layoutIfNeeded()
        searchBarTopConstraint.constant = isSearchBarActive ? 24.0 : 99.0
        searchBarTrailingConstraint.constant = isSearchBarActive ? 80.0 : 8.0
        UIView .animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelButtonWasTouched(_ sender: AnyObject) {
        searchTextField.resignFirstResponder()
    }
}
