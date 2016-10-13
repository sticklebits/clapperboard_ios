//
//  SearchHeaderCollectionViewCell.swift
//  Clapperboard
//
//  Created by Steve Johnson on 05/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchHeaderCollectionViewCell: UICollectionViewCell {

    enum State {
        case closed
        case searchInput
        case searchResults
    }
    
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: SearchHeaderDelegate?
    
    var state: State = .closed {
        didSet {
            if state == .closed {
//                self.delegate?.searchHeaderWillClose?(self)
            }
            updateSearchBar()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchTextField.returnKeyType = .search
        updateSearchBar()
    }

    func updatePlaceholder() {
        searchTextField?.placeholder = filterSegment.titleForSegment(at: filterSegment.selectedSegmentIndex)
    }
    
    func updateSearchBar() {
        
        updatePlaceholder()
        
        if state == .closed && searchTextField.isEditing {
            searchTextField.resignFirstResponder()
        }
        
        self.layoutIfNeeded()
    
        searchBarTopConstraint.constant = state == .closed ? 99.0 : 24.0
        searchBarTrailingConstraint.constant = state == .closed ? 16.0 : 80.0
        cancelButton.setTitle(state == .searchResults ? "Done" : "Cancel", for: .normal)
        
        UIView .animate(withDuration: 0.25, animations: { 
            self.layoutIfNeeded()
            }) { (_) in
                if self.state == .closed {
//                    self.delegate?.searchHeaderDidClose?(self)
                }
        }
    }
    
    @IBAction func cancelButtonWasTouched(_ sender: AnyObject) {
//        delegate?.searchHeader(self, didTouchButton: sender as! UIButton)
    }
    
    @IBAction func filterSegmentDidChange(_ sender: UISegmentedControl) {
        updatePlaceholder()
    }
    
}
