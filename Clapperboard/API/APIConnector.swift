//
//  APIConnector.swift
//  Clapperboard
//
//  Created by Steve Johnson on 02/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class APIConnector: NSObject {
    
    var base: URL
    
    init(base: URL) {
        self.base = base
        super.init()
    }
}
