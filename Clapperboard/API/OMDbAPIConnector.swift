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
        if (title.characters.count == 0) { return }
        request = MovieRequest(title: title, searchType: searchType)
        sendRequest(endpoint: "", method: .get, request: request!)
    }
    
    func searchForMovie(imdbID: String) {
        if (imdbID.characters.count == 0) { return }
        request = MovieRequest(imdbID: imdbID)
        sendRequest(endpoint: "", method: .get, request: request!)
    }
    
    func currentSearch(fetchPage page: Int) {
        if let request = self.request as? MovieRequest {
            request.page = page
            sendRequest(endpoint: "", method: .get, request: request)
        }
    }
    
    override func didReceive(response: [String:Any]?) {
        if response == nil { return }
        
        guard let status = response?["Response"] as? String else {
            return
        }
        
        DispatchQueue.main.async {
            if status == "True" {
                let request = self.request as! MovieRequest
                if request.searchType == .multi {
                    let movies = self.movies(fromJSON: response!)
                    self.delegate?.omdbAPIConnector(self, didFindMovieList: movies, forPage: request.page)
                } else {
                    let movie = Movie(fromJSON: response!)
                    self.delegate?.omdbAPIConnector(self, didFindMovie: movie)
                }
            } else {
                self.delegate?.omdbAPIConnector(self, didFindMovie: nil)
            }
        }
    }
    
    override func didReceive(error: Error) {
        delegate?.omdbAPIConnector(self, didReceiveError: error)
    }
    
    func movies(fromJSON json: [String:Any]) -> [Movie] {
        var movies: [Movie] = []
        
        guard let searchResults: [[String:Any]] = json["Search"] as! [[String : Any]]? else {
            return movies
        }

        searchResults.forEach { (movie) in
            movies.append(Movie(fromJSON: movie))
        }
        
        return movies
    }
}


// MARK: - OBDbAPIConnectorDelegate protocol

protocol OMDbAPIConnectorDelegate {
    func omdbAPIConnector(_ omdbAPIConnector:OMDbAPIConnector, didFindMovie movie:Movie?)
    func omdbAPIConnector(_ omdbAPIConnector:OMDbAPIConnector, didFindMovieList movieList:[Movie], forPage page:Int)
    func omdbAPIConnector(_ omdbAPIConnector:OMDbAPIConnector, didReceiveError error:Error)
}
