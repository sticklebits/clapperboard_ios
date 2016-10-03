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
    
    init(searchType: SearchType) {
        self.searchType = searchType
        if searchType == .multi {
            plot = "short"
        }
        super.init()
    }
    
    func asDictionary() -> [String:String] {
        return ["s":title, "type":format, "plot":plot, "r":dataFormat]
    }
}
