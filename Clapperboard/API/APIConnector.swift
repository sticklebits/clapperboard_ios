//
//  APIConnector.swift
//  Clapperboard
//
//  Created by Steve Johnson on 02/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class APIConnector: NSObject {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    var request: APIRequest? {
        didSet {
            response = [:]
        }
    }
    
    var base: URL
    
    private(set) var endpoint: String? {
        didSet {
            response = [:]
        }
    }
    

    private(set) var response: [String:Any]?
    private(set) var isWorking = false {
        didSet {
            didChange(working: isWorking)
        }
    }
    
    init(base: URL) {
        self.base = base
        super.init()
    }
    
    func sendRequest(endpoint: String, method: Method, request: APIRequest) {
        
        if isWorking { return }
        
        isWorking = true
        
        self.request = request
        
        guard let url = URL(string:"\(endpoint)\(method == .get ? request.httpString() : "")", relativeTo: base) else {
            didReceive(error: NSError(domain: "APIConnector", code: 400, userInfo: [NSLocalizedDescriptionKey:"Bad URL request."]))
            return
        }
        
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            
            self.isWorking = false
            
            if (error != nil) {
                self.didReceive(error: error!)
            } else {
                guard let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) else {
                    self.didReceive(error: NSError(domain: "APIConnector", code: 400, userInfo: [NSLocalizedDescriptionKey:"Could not parse JSON response."]))
                    return
                }
                
                self.didReceive(response: json as? [String:Any])
            }
        }
        
        task.resume()
    }
}


// MARK: - Empty functions for subclass override

extension APIConnector {
    
    func didReceive(response: [String:Any]?) {
        
    }
    
    func didReceive(error: Error) {
        
    }
    
    func didChange(working: Bool) {
        
    }
}
