//
//  SearchHeaderTableViewCell.swift
//  Clapperboard
//
//  Created by Steve Johnson on 11/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class SearchHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchFieldTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchLabelSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    
    enum State {
        case closed
        case searchInput
        case searchResults
    }
    
    var height: CGFloat! {
        didSet {
            cellHeightConstraint.constant = height
            setNeedsUpdateConstraints()
        }
    }
    
    var delegate: SearchHeaderDelegate?
    var stateDelegate: SearchHeaderStateDelegate?
    
    var state: State = .closed {
        didSet {
            if state == .closed {
                self.stateDelegate?.searchHeaderWillClose(self)
            } else {
                if oldValue == .closed {
                    self.stateDelegate?.searchHeaderWillOpen(self)
                }
            }
            updateSearchBar()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        height = 160.0
        selectionStyle = .none
        setupSearchField()
        updateSearchBar()
    }

    func setupSearchField() {
        searchField.returnKeyType = .search
        searchField.delegate = self
    }
    
    func updatePlaceholder() {
        searchField?.placeholder = filterSegment.titleForSegment(at: filterSegment.selectedSegmentIndex)
    }
    
    func updateSearchBar() {
        
        updatePlaceholder()
        
        if state == .closed && searchField.isEditing {
            searchField.resignFirstResponder()
        }
        
        self.layoutIfNeeded()
        
        searchFieldBottomConstraint.constant = state == .closed ? 0.0 : 70.0
        searchFieldTrailingConstraint.constant = state == .closed ? 16.0 : 80.0
        searchLabelSpacingConstraint.constant = state == .closed ? 8.0 : 32.0
        actionButton.setTitle(state == .searchResults ? "Done" : "Cancel", for: .normal)
        
        UIView .animate(withDuration: 0.25, animations: {
            self.searchLabel.alpha = self.state == .closed ? 1.0 : 0.0
            self.layoutIfNeeded()
            }, completion: { (finished) in
                if self.state == .closed {
                    self.stateDelegate?.searchHeaderDidClose(self)
                } else {
                    self.stateDelegate?.searchHeaderDidOpen(self)
                }
        })
    }
    
    @IBAction func actionButtonWasTouched(_ sender: UIButton) {
        state = .closed
    }
    
    @IBAction func filterSegmentDidChange(_ sender: UISegmentedControl) {
        updatePlaceholder()
    }
}


extension SearchHeaderTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSearchBarState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if state != .closed {
            updateSearchBarState()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchHeader(self, didRequestSearch: textField.text)
        return true
    }
    
    func updateSearchBarState() {
        
        if (searchField?.isEditing)! {
            state = .searchInput
            return
        }
        
        if let newState = delegate?.searchHeaderShouldUpdateState(self) {
            state = newState
        }
    }
}


// MARK: - SearchHeaderDelegate Protocol

protocol SearchHeaderDelegate {
    func searchHeader(_ searchHeader: SearchHeaderTableViewCell, didRequestSearch: String?)
    func searchHeader(_ searchHeader: SearchHeaderTableViewCell, didTouchButton button: UIButton)
    func searchHeaderShouldUpdateState(_ searchHeader: SearchHeaderTableViewCell) -> SearchHeaderTableViewCell.State
}

protocol SearchHeaderStateDelegate {
    // Opening states
    func searchHeaderWillOpen(_ searchHeader: SearchHeaderTableViewCell)
    func searchHeaderDidOpen(_ searchHeader: SearchHeaderTableViewCell)
    
    // Closing states
    func searchHeaderWillClose(_ searchHeader: SearchHeaderTableViewCell)
    func searchHeaderDidClose(_ searchHeader: SearchHeaderTableViewCell)
}
