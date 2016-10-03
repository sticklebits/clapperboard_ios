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
        self.init(base: URL(string: "https://omdbapi.com")!)
    }
    
    func searchForMovie(title: String, searchType: MovieRequest.SearchType) {
        if (title.characters.count < 3) { return }
        let request = MovieRequest(searchType: searchType)
        request.title = title
        sendRequest(endpoint: "", method: .get, request: request.asDictionary())
    }
    
    override func didReceive(response: [String:Any]?) {
        if response == nil { return }
        
        guard let status = response?["Response"] as? String else {
            return
        }
        
        DispatchQueue.main.async {
            if status == "True" {
                let movie = Movie(fromJSON: response!)
                self.delegate?.omdbAPIConnector(self, didFindMovie: movie)
            } else {
                self.delegate?.omdbAPIConnector(self, didFindMovie: nil)
            }
        }
    }
    
    override func didReceive(error: Error) {
        delegate?.omdbAPIConnector(self, didReceiveError: error)
    }
}


// MARK: - OBDbAPIConnectorDelegate protocol

protocol OMDbAPIConnectorDelegate {
    func omdbAPIConnector(_ omdbAPIConnector:OMDbAPIConnector, didFindMovie:Movie?)
    func omdbAPIConnector(_ omdbAPIConnector:OMDbAPIConnector, didReceiveError error:Error)
}
