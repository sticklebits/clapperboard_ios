//
//  Array+Extensions.swift
//  Clapperboard
//
//  Created by Steve Johnson on 15/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import Foundation

extension Array {
    
    func first(n: Int) -> Array {
        if n == 0 { return [] }
        if count <= n { return self }
        
        var truncatedArray: Array = []
        
        for index in 0..<n {
            truncatedArray.append(self[index])
        }
        
        return truncatedArray
    }
    
}
