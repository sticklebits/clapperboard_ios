//
//  APIRequest.swift
//  Clapperboard
//
//  Created by Steve Johnson on 03/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class APIRequest: NSObject {

    func httpString() -> String {
        let request = dictionary()
        if request.count == 0 { return "" }
        var requestString = ""
        var prefix = ""
        request.forEach { (key, value) in
            requestString += "\(prefix)\(key)=\(value)"
            prefix = "&"
        }
        return "?" + requestString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func dictionary() -> [String:String] {
        return [:]
    }
}
