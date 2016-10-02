//
//  ViewController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 02/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleInputField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    let omdbAPI = OMDbAPIConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        omdbAPI.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonWasTouched(_ sender: UIButton) {
        omdbAPI.searchForMovie(title: titleInputField.text!)
    }
}


extension ViewController: OMDbAPIConnectorDelegate {
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didReceiveMovieDetails movieDetails: [String : Any]) {
        print("\(movieDetails["movie"])")
    }
    
    func omdbAPIConnector(_ omdbAPIConnector: OMDbAPIConnector, didReceiveError error: NSError) {
        print("\(error.localizedDescription)")
    }
}
