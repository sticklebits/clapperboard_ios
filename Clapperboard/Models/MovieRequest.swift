//
//  MovieRequest.swift
//  Clapperboard
//
//  Created by Steve Johnson on 03/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class MovieRequest: APIRequest {
    
    enum SearchType: String {
        case single = "t"
        case multi = "s"
    }
    
    var searchType: SearchType
    var title = ""
    var format = ""
    var plot = "full"
    var dataFormat = "r"
    var imdbID = ""
    
    init(title: String, searchType: SearchType) {
        self.title = title
        self.searchType = searchType
        if searchType == .multi {
            plot = "short"
        }
        super.init()
    }
    
    init(imdbID: String) {
        self.imdbID = imdbID
        searchType = .single
        plot = "full"
        super.init()
    }
    
    override func dictionary() -> [String:String] {
        let searchTitle = "*" + title.trimmingCharacters(in: CharacterSet(charactersIn: " ")) + "*"
        var returnDictionary = [searchType.rawValue:searchTitle, "type":format, "plot":plot, "r":dataFormat]
        if (imdbID.characters.count > 0) { returnDictionary[imdbID] = imdbID }
        return returnDictionary
    }
}
