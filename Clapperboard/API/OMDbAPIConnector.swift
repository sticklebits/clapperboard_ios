//
//  OMDbAPIConnector.swift
//  Clapperboard
//
//  Created by Steve Johnson on 02/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class OMDbAPIConnector: APIConnector {
    
    var delegate: OMDbAPIConnectorDelegate?
    
    convenience init() {
        self.init(base: URL(fileURLWithPath: "http://omdbapi.com"))
    }
    
    func searchForMovie(title: String) {
        if (title.characters.count == 0) {
            let error = NSError(domain: "omdb", code: 0, userInfo: [NSLocalizedDescriptionKey:"Empty search string"])
            delegate?.omdbAPIConnector(self, didReceiveError: error)
            return
        }
        delegate?.omdbAPIConnector(self, didReceiveMovieDetails: ["movie":"Film found"])
    }
}

protocol OMDbAPIConnectorDelegate {
    func omdbAPIConnector(_ omdbAPIConnector:OMDbAPIConnector, didReceiveMovieDetails movieDetails:[String:Any])
    func omdbAPIConnector(_ omdbAPIConnector:OMDbAPIConnector, didReceiveError error:NSError)
}
