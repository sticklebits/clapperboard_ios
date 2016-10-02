//
//  Movie.swift
//  Clapperboard
//
//  Created by Steve Johnson on 02/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class Movie: NSObject {

    var title = ""
    var year = ""
    var rated = ""
    var released = ""
    var runtime = ""
    var genre = ""
    var director = ""
    var write = ""
    var actors = ""
    var plot = ""
    var language = ""
    var country = ""
    var awards = ""
    var poster = ""
    var metascore = ""
    var imdbRating = ""
    var imdbVotes = ""
    var imdbID = ""
    var type = ""
    
    convenience init(fromJSON json: [String:Any]) {
        self.init()
        if let title = json["Title"] as? String { self.title = title }
        if let year = json["Year"] as? String { self.year = year }
        if let poster = json["Poster"] as? String { self.poster = poster }
    }
}
